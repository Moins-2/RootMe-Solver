# HTTP Improper redirect

## Description

This vulnerability is an issue with improper redirects in HTTP responses, where an attacker can manipulate the redirect location to gain access to sensitive information.

## The attack

The attack consists of manipulating the redirect location to access sensitive information.

- The attacker accesses the web page and sets the `allow_redirects` header to `False`.
- The server responds with a redirect to a location that contains sensitive information, such as a password.
- The attacker can easily access the sensitive information by modifying the redirect location.
