# HTTP Headers

## Description

This vulnerability is an issue with the usage of HTTP headers, where sensitive information, such as a password, is stored in a custom HTTP header and can be easily accessed by an attacker.

## The attack

The attack consists of accessing the HTTP headers and obtaining the sensitive information.

- The attacker accesses the web page and inspects the HTTP headers.
- The attacker finds a custom HTTP header with sensitive information, such as a password.
- The attacker can easily obtain the password and use it to gain unauthorized access to the system.
