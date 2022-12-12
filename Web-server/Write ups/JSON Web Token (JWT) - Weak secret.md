# JWT - weak password

## Description

JSON Web Token (JWT) is a compact, URL-safe means of representing claims to be transferred between two parties. The claims in a JWT are encoded as a JSON object that is digitally signed using JSON Web Signature (JWS) and/or encrypted using JSON Web Encryption (JWE). JWTs can be signed using a secret (with the HMAC algorithm) or a public/private key pair using RSA.

## Solution

### Get the JWT

<http://challenge01.root-me.org/web-serveur/ch59/token>

### Crack the JWT

use jwt_tool to find the secret:

```bash
python3 jwt_tool.py <token> -C -d <wordlist>
```

> Tips: A basic wordlist is rockyou.txt

### Create a new JWT

Use [jwt.io](https://jwt.io/) to create a new JWT, changing "guest" to "admin", and sign it with the cracked secret.

### Ask for the flag

Do a POST request to : <http://challenge01.root-me.org/web-serveur/ch59/admin>
Adding the new JWT in the header.

```http
Authorization: Bearer <token>
```
