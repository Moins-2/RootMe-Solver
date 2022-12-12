# Directory traversal

## Description

This vulnerability is a directory traversal issue, which allows an attacker to access files outside of the intended directory. This is done by using special characters, such as `../`, in the request path.

## The attack

The attack consists of using special characters in the request path to access files outside of the intended directory.

- The attacker crafts a request with a path that contains the `../` special characters, in order to access files outside of the intended directory.
- The server processes the request and interprets the `../` characters as a request to go back one directory.
- This allows the attacker to access files outside of the intended directory and potentially obtain sensitive information, such as a password file.
