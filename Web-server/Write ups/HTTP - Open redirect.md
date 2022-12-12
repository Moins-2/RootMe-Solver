# HTTP Open redirect

## Description

This vulnerability is an issue with open redirects in HTTP responses, where an attacker can manipulate the URL parameters to redirect to an unauthorized website.

## The attack

The attack consists of modifying the URL parameters to redirect to an unauthorized website.

- The attacker accesses the web page and manipulates the `url` parameter to redirect to an unauthorized website, such as `https://google.fr`.
- The server responds with a message indicating that the redirect was successful, such as "Well done".
- The attacker can then access sensitive information or perform unauthorized actions on the unauthorized website.
