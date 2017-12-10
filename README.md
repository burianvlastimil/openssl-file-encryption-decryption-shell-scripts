# OpenSSL file encryption / decryption POSIX shell scripts

These scripts have been created for general use.

They should contain every safety measure / error check, that I thought of.

Multiple arguments (files) are currently not supported, but I plan on implementing it in the future.

----------------------------------------------------

# Usage

1. Encryption

    ```
    ./encrypt-file-aes256 filename
    ```

    will always produce the `filename` with `.enc` extension,
    even if you encrypt a file multiple files,
    for instance the following file:

    ```
    filename.enc.enc.enc
    ```

    has been encrypted 3 times.

2. Decryption

    ```
    ./decrypt-file-aes256 filename.enc
    ```
    
    will strip the defined `.enc` extension and produce a file named:
    
    ```
    filename
    ```
    
    But it has to be possible to decrypt files without the defined extension.
    In this case we will append `.dec` to the filename and produce for example:
    
    ```
    filename.dec
    ```
