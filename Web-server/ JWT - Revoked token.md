# JWT - Revoked token

## Description

JSON Web Token (JWT) is a compact, URL-safe means of representing claims to be transferred between two parties. The claims in a JWT are encoded as a JSON object that is digitally signed using JSON Web Signature (JWS) and/or encrypted using JSON Web Encryption (JWE). JWTs can be signed using a secret (with the HMAC algorithm) or a public/private key pair using RSA.

## Solution

### Get the JWT

Ask <http://challenge01.root-me.org/web-serveur/ch63/login> with a POST method and the following body:

```json
{
    "username": "admin",
    "password": "admin"
}
```

### Connect to the server

Connect to <http://challenge01.root-me.org/web-serveur/ch63/admin> with the following header:

```http
Authorization: Bearer <token>=
```

By adding the `=` at the end of the token, we can bypass the check that the token is in the Blacklist, but the token is still valid (because it's base64 encoded, so the `=` change nothing).
