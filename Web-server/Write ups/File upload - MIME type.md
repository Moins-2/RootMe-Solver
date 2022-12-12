# File upload - MIME type

## Description

This vulnerability is a file upload issue that allows an attacker to bypass the restriction of only allowing certain file types to be uploaded, such as image files. This is done by setting the MIME type of the file to a different value than its actual file type.

## The attack

The attack consists of two main steps: uploading the malicious file and executing it.

### Upload

- The system has a restriction on the type of files that can be uploaded, such as only allowing image files.
- The attacker tries to upload a PHP file, but it is not allowed by the system.
- The attacker then sets the MIME type of the file to an image type, such as `image/jpeg`.
- The file is successfully uploaded to the server.

### Using the file

- The file has a MIME type of `image/jpeg`, which makes it appear as an image file to the system.
- However, the actual file type is a PHP file, which can be executed by the attacker.
- The attacker can then execute the file and run arbitrary commands on the server.
