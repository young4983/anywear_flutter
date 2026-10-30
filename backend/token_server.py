"""Small authenticated token-service example; Python 3.9+, no dependencies.

Use your application's normal login/session system in production. The bearer
allowlist here is for private integration testing, never a public mobile secret.
"""
import hmac
import json
import os
import re
import threading
import time
import urllib.error
import urllib.request
from collections import defaultdict, deque
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


def mint_client_token(api_key):
    request = urllib.request.Request(
        "https://api.decart.ai/v1/client/tokens",
        data=json.dumps({
            "expiresIn": 60,
            "allowedModels": ["lucy-vton-latest", "lucy-vton-3.6"],
            "constraints": {"realtime": {"maxSessionDuration": 120}},
        }).encode(),
        headers={"X-API-KEY": api_key, "Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=15) as response:
        payload = json.loads(response.read(64 * 1024))
    token = payload.get("apiKey")
    if not isinstance(token, str) or not (
        (token.startswith("ek_") and len(token) > 3)
        or re.fullmatch(r"[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+", token)
    ):
        raise ValueError("Invalid upstream response")
    return {"apiKey": payload["apiKey"], "expiresAt": payload["expiresAt"]}


class TokenServer(ThreadingHTTPServer):
    daemon_threads = True

    def __init__(self, address, api_key, session_tokens, mint=mint_client_token):
        if not api_key.startswith("dct_") or not session_tokens:
            raise ValueError("Server credentials and authorized test sessions are required")
        super().__init__(address, Handler)
        self.api_key = api_key
        self.session_tokens = session_tokens
        self.mint = mint
        self.requests = defaultdict(deque)
        self.rate_lock = threading.Lock()


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *_):
        pass  # No request headers, media, or tokens in access logs.

    def respond(self, status, payload):
        body = json.dumps(payload).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Cache-Control", "no-store")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_POST(self):
        if self.path != "/api/realtime-token":
            return self.respond(404, {"error": "Not found"})
        auth = self.headers.get("Authorization", "")
        token = auth[7:] if auth.startswith("Bearer ") else ""
        identity = next((i for i, allowed in enumerate(self.server.session_tokens)
                         if hmac.compare_digest(token.encode(), allowed.encode())), None)
        if identity is None:
            return self.respond(401, {"error": "Unauthorized"})
        with self.server.rate_lock:
            now = time.monotonic()
            requests = self.server.requests[identity]
            while requests and requests[0] <= now - 60:
                requests.popleft()
            if len(requests) >= 6:
                return self.respond(429, {"error": "Too many requests"})
            requests.append(now)
        try:
            payload = self.server.mint(self.server.api_key)
        except (urllib.error.URLError, TimeoutError, ValueError, KeyError):
            return self.respond(502, {"error": "Try-on service unavailable"})
        self.respond(200, payload)


if __name__ == "__main__":
    api_key = os.environ.get("DECART_API_KEY", "")
    sessions = [value.strip() for value in os.environ.get("APP_SESSION_TOKENS", "").split(",")
                if value.strip()]
    server = TokenServer(("127.0.0.1", int(os.environ.get("PORT", "8080"))), api_key, sessions)
    print("Token service listening on 127.0.0.1:%s" % server.server_port)
    server.serve_forever()
