# Security policy

## Credentials

- Never commit a permanent Decart `dct_` API key, a client token, an application session token, or a signing key.
- `config/development.example.json` and `backend/.env.example` contain placeholders only. Local files are ignored by Git.
- A `dct_` key belongs on a private backend. The mobile release app should call an authenticated HTTPS endpoint and receive a short-lived client token.
- The debug key input in the app is for local development. Do not ship a release build with a development key or a test session allowlist.

## If a key is exposed

1. Revoke it in the [Decart console](https://decart.ai) immediately.
2. Create a replacement key and update the private environment or local ignored file.
3. Search the repository, commit history, CI logs, screenshots, and issue comments for the old value.
4. If it was committed, remove it from the branch history and rotate it anyway; deleting the file in a later commit is not sufficient.

## Reporting

For a private report, open a GitHub security advisory or contact the repository owner directly. Do not publish working credentials in a public issue.
