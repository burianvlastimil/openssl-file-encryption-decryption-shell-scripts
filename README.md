# OpenSSL file encryption / decryption shell scripts

Cipher: AES-256 in CBC mode

https://en.wikipedia.org/wiki/Advanced_Encryption_Standard

https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher_Block_Chaining_(CBC)

Message digest algorithm: SHA-256

https://en.wikipedia.org/wiki/SHA-2

These scripts have been created for general use under the LICENSE terms.

They are standard POSIX shell scripts, so you most probably can run it in every Linux environment.

https://en.wikipedia.org/wiki/POSIX

https://en.wikipedia.org/wiki/Unix_shell

They should contain every safety measure / error check, that I thought of.

Multiple arguments (files) are currently not supported, but I plan on implementing it in the future.


----------------------------------------------------


# Download and Installation


1. Download it from this repository using `git`:
    ```
    git clone https://github.com/burianvlastimil/openssl-file-encryption-decryption-shell-scripts
    ```

2. Go to the downloaded directory:
    ```
    cd openssl-file-encryption-decryption-shell-scripts/
    ```

3. Install it for example to `/usr/local/bin`:
    ```
    sudo install -m 0755 -o root -g root -t /usr/local/bin ??crypt-file-aes256
    ```


----------------------------------------------------


# Uninstallation / Removal

```
sudo rm /usr/local/bin/encrypt-file-aes256 /usr/local/bin/decrypt-file-aes256
```


----------------------------------------------------


# Usage

1. Encryption

    ```
    encrypt-file-aes256 filename
    ```

    will always produce the `filename` with `.enc` extension, even if you encrypt a file multiple files, for instance the following file:

    ```
    filename.enc.enc.enc
    ```

    has been encrypted 3 times.

2. Decryption

    ```
    decrypt-file-aes256 filename.enc
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


----------------------------------------------------


# Exit codes

0 - Successful encryption / decryption.

1 - One argument needs to be given. Both relative, and absolute file paths are supported.

2 - Multiple arguments are not supported.

3 - The given argument is not an existing file.

4 - Input file is not readable by you.

5 - Destination directory is not writable by you.

6 - Destination file exists.

7 - Failed encryption / decryption.


----------------------------------------------------


# Reporting bugs and suggestions

Please send an email to me: info@vlastimilburian.cz
