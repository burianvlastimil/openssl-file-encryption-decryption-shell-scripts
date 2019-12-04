# OpenSSL file encryption / decryption shell scripts

[Encryption](https://en.wikipedia.org/wiki/Encryption) [cipher](https://en.wikipedia.org/wiki/Cipher) is [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)-256 in [CBC](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher_Block_Chaining_(CBC)) mode.

[Message digest](https://en.wikipedia.org/wiki/Cryptographic_hash_function) is SHA-512 (from [SHA-2](https://en.wikipedia.org/wiki/SHA-2) family); this had changed from SHA-256 used before version 2.0.

They are standard [POSIX](https://en.wikipedia.org/wiki/POSIX) shell scripts, which should work in any [Linux](https://en.wikipedia.org/wiki/Linux) distribution (more precisely, your [shell](https://en.wikipedia.org/wiki/Unix_shell)).

Multiple arguments (files) and / or pipes are **currently** not supported.

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


----------------------------------------------------


# Reporting bugs and suggestions

Please open a [new issue ticket](https://github.com/burianvlastimil/openssl-file-encryption-decryption-shell-scripts/issues/new).
