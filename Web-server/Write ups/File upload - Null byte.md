# File upload - Null byte

## Description

This vulnerability is a file upload issue that allows an attacker to bypass the restriction of only allowing certain file types to be uploaded, such as image files. This is done by appending a null byte (`%00`) to the file name, followed by a file extension that is allowed by the system.

## The attack

The attack consists of two main steps: uploading the malicious file and executing it.

### Upload

- The system has a restriction on the type of files that can be uploaded, such as only allowing image files.
- The attacker tries to upload a PHP file, but it is not allowed by the system.
- The attacker then adds a null byte (`%00`) to the file name, followed by a file extension that is allowed by the system, such as `.jpeg`.
- The file is successfully uploaded to the server.

### Using the file

- The file has a `.jpeg` extension, which makes it appear as an image file to the system.
- However, the null byte in the file name allows the attacker to call it as a PHP file.
- The attacker can then execute the file and run arbitrary commands on the server.
