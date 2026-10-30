import json
import threading
import unittest
from unittest.mock import patch
import urllib.error
import urllib.request

from token_server import TokenServer, mint_client_token


class UpstreamResponseTests(unittest.TestCase):
    def test_current_jwt_response_and_permanent_key_rejection(self):
        jwt = "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjQwNzA5MDg4MDB9.test_signature"
        for token, accepted in [(jwt, True), ("ek_test", True), ("dct_test", False)]:
            with self.subTest(token_format=token.split("_")[0]):
                with patch("token_server.urllib.request.urlopen") as open_url:
                    open_url.return_value.__enter__.return_value.read.return_value = json.dumps({
                        "apiKey": token, "expiresAt": "2099-01-01T00:00:00Z",
                    }).encode()
                    if accepted:
                        self.assertEqual(mint_client_token("dct_test")["apiKey"], token)
                    else:
                        with self.assertRaises(ValueError):
                            mint_client_token("dct_test")


class TokenServiceTests(unittest.TestCase):
    def setUp(self):
        self.mints = 0

        def mint(_):
            self.mints += 1
            return {"apiKey": "ek_test", "expiresAt": "2099-01-01T00:00:00Z"}

        self.server = TokenServer(("127.0.0.1", 0), "dct_test", ["test-user-session"], mint)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()

    def tearDown(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join()

    def request(self, session=None):
        headers = {"Authorization": "Bearer " + session} if session else {}
        req = urllib.request.Request(
            "http://127.0.0.1:%s/api/realtime-token" % self.server.server_port,
            data=b"{}", headers=headers, method="POST",
        )
        try:
            with urllib.request.urlopen(req, timeout=3) as response:
                return response.status, json.load(response)
        except urllib.error.HTTPError as error:
            return error.code, json.load(error)

    def test_unknown_users_cannot_spend_api_credits(self):
        self.assertEqual(self.request()[0], 401)
        self.assertEqual(self.request("wrong")[0], 401)
        self.assertEqual(self.mints, 0)

    def test_authorized_users_only_receive_ephemeral_tokens(self):
        status, payload = self.request("test-user-session")
        self.assertEqual(status, 200)
        self.assertEqual(payload["apiKey"], "ek_test")
        self.assertNotIn("dct_test", json.dumps(payload))

    def test_rate_limit_blocks_additional_upstream_calls(self):
        for _ in range(6):
            self.assertEqual(self.request("test-user-session")[0], 200)
        self.assertEqual(self.request("test-user-session")[0], 429)
        self.assertEqual(self.mints, 6)


if __name__ == "__main__":
    unittest.main()
