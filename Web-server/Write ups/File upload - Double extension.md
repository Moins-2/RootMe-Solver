# File upload - Double extensions

## Description

This vulnerability is a file upload issue that allows an attacker to bypass the restriction of only allowing certain file types to be uploaded, such as image files. This is done by adding a second file extension to the file name, which is not checked by the system.

## The attack

The attack consists of two main steps: uploading the malicious file and executing it.

### Upload

- The system has a restriction on the type of files that can be uploaded, such as only allowing image files.
- The attacker tries to upload a PHP file, but it is not allowed by the system.
- The attacker then adds a second file extension, such as `.jpg`, to the file name.
- The file is successfully uploaded to the server.

### Using the file

- The file has a `.jpg` extension, which makes it appear as an image file to the system.
- However, the original file name with the `.php` extension is not checked by the system and is still present in the file name.
- The attacker can then execute the file as a PHP file and run arbitrary commands on the server.
