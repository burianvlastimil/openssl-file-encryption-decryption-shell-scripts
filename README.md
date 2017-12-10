# OpenSSL file encryption / decryption shell scripts

Cipher: AES-256-CBC

Message digest algorithm: SHA-256

These scripts have been created for general use.

They are standard POSIX shell scripts, so you most probably can run it in every Linux environment.

They should contain every safety measure / error check, that I thought of.

Multiple arguments (files) are currently not supported, but I plan on implementing it in the future.

----------------------------------------------------

# Usage

1. Encryption

    ```
    ./encrypt-file-aes256 filename
    ```

    will always produce the `filename` with `.enc` extension, even if you encrypt a file multiple files, for instance the following file:

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
    
----------------------------------------------------------------


# Exit codes

0 - Successful encryption / decryption.

1 - One argument needs to be given. Both relative, and absolute file paths are supported.

2 - Multiple arguments are not supported.

3 - The given argument is not an existing file.

4 - Input file is not readable by you.

5 - Destination directory is not writable by you.

6 - Destination file exists.

7 - Failed encryption / decryption.


----------------------------------------------------------------


# Reporting bugs and suggestions

Please send an email to me: info@vlastimilburian.cz