# HTTP Directory Indexing

## Description

This vulnerability is a directory indexing issue, where the contents of a directory are publicly accessible and can be easily viewed by an attacker. This is often caused by the server's directory indexing feature being enabled by default.

## The attack

The attack consists of accessing the directory and viewing its contents.

- The attacker accesses the directory on the server.
- The server's directory indexing feature is enabled, allowing the attacker to view the contents of the directory.
- The attacker can easily obtain sensitive information, such as a password, that is stored in a file in the directory.
