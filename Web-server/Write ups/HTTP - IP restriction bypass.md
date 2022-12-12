# HTTP IP restriction bypass

## Description

This vulnerability is an issue with IP restrictions in HTTP responses, where an attacker can bypass the restrictions by modifying the IP address in the request headers.

## The attack

The attack consists of modifying the IP address in the request headers to bypass the IP restrictions.

- The attacker accesses the web page and sets the `X-Forwarded-For` header to a different IP address.
- The server responds with a message indicating that the IP restriction has been bypassed, such as "Well done".
- The attacker can then access sensitive information or perform unauthorized actions.
