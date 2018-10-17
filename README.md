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

Multiple arguments (files) and / or pipes are currently not supported.


----------------------------------------------------


# Download, Authenticity check, and Extract


1. Download the latest release and its signature from here:

    https://github.com/burianvlastimil/openssl-file-encryption-decryption-shell-scripts/releases/latest

2. Go to the download directory, where you have saved the files (note that you need the signature file too).

3. Import my public GPG key:

    ```
    gpg --recv-keys 7D2E022E39A88ACF3EF6D4498F37AF4CE46008C3
    ```

4. Verify autenticity of the archive:

    ```
    gpg --verify openssl-encryption.tar.xz.asc openssl-encryption.tar.xz
    ```

5. Extract the `xz` packed tarball with:

    ```
    tar -xJvf openssl-encryption.tar.xz
    ```

----------------------------------------------------


# Installation


There are basically 3 ways to install the scripts:


1. **Easy** being to use the Makefile's default location, which is `/usr/local/bin`:

    ```
    sudo make install
    ```

2. **Advanced** users may install the scripts wherever they wish, in this example to current directory's `./test` sub-directory:

    ```
    make install PREFIX=./test
    ```

    Note 1: the destination directory will be created if it does not exist.
    Note 2: `sudo` is not needed in this case, so even non-root users can install them easily.

3. **Experts** may avoid the `Makefile` altogether and copy the two files into whichever destination they wish.


----------------------------------------------------


# Uninstallation / Removal

It is as simple as the installation method you chose.

1. If you have chosen to use the `Makefile` method #1, it is as simple as:

    ```
    sudo make uninstall
    ```

2. If you have chosen to use the `Makefile` method #2, it is also very easy:

    ```
    make uninstall PREFIX=./test
    ```

3. If you have chosen to avoid the makefile, you are advanced enough to handle this.


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
    
    Note, that it is entirely possible to decrypt files without the defined extension.
    In this case we will append `.dec` to the filename and produce for example:
    
    ```
    filename.dec
    ```


----------------------------------------------------


# Exit codes

0 - Successful encryption / decryption.

1 - Some error occurred. 


----------------------------------------------------

# Testing

I did the following tests so far:

- every fail exit code has been tested: PASS

- encrypting / decrypting a very small file, 1 KB: PASS

- encrypting / decrypting a medium size file, 15 GB: PASS

- encrypting / decrypting a very large file, 750 GB: PASS

----------------------------------------

# If you like the script, consider donating any amount to my cryptocurrency accounts

**Bitcoin**
```
32fD1Qkx5Kf6GbjewTLhBkjrZGryYjTotS
```

**Bitcoin Cash**
```
qrsh8dwwrpvdxj6le8gvv9uq0u72zzmjzvger0qzd6
```

**Ethereum**
```
0x2537a26e5F8AF085Fce9fBe0e45BDA6dBa0c0349
```

**Ethereum Classic**
```
0x3fbf8Cba84FAB0F3Bd5aaa7a81663e4831fb5eC4
```

**Litecoin**
```
MNg1JdTmC1FmYLiGiB5XzRRXJVg325X84Y
```

Thank you!

----------------------------------------------------


# Reporting bugs and suggestions

Please open a [new issue ticket](https://github.com/burianvlastimil/openssl-file-encryption-decryption-shell-scripts/issues/new).
