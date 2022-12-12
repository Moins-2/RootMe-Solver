## Description

This vulnerability is a CRLF (Carriage Return Line Feed) injection issue, which allows an attacker to inject additional HTTP headers and/or manipulate the response of the server. This is done by adding a CRLF sequence (`%0D%0A`) in the request.

## The attack

The attack consists of injecting a CRLF sequence in the request to manipulate the server's response.

- The attacker adds a CRLF sequence (`%0D%0A`) in the request, in the username parameter.
- The server processes the request and interprets the CRLF sequence as a new line, effectively splitting the username into two.
- The first part of the username is treated as a regular username, while the second part is treated as an additional HTTP header, "authenticated."
- This allows the attacker to bypass authentication and gain access to the system.
