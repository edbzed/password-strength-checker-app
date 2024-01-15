
# Bash Password Checker and Encryptor

This is a Bash script that allows you to check the strength of a password and encrypt the password using OpenSSL. The script provides a menu-driven interface for encrypting and decrypting passwords.

## Features

- Password strength checking based on customizable criteria.
- Encryption of passwords using AES-256-CBC with key derivation using PBKDF2.
- Option to decrypt encrypted passwords.
- Password blacklist to prevent common passwords.
- Password masking for security.
- A colorful header using Figlet.
- Display menu for various options.
- Option to remove the original password file after encryption.

## Requirements

- Bash shell (Linux/macOS)
- OpenSSL

## Usage

1. Clone or download the script to your local machine.
2. Make the script executable:

   ```bash
   chmod +x password_checker.sh
   ```
3. Run the script:

   ```bash
   ./password_checker.sh
   ```
4. Follow the on-screen instructions:

   - Enter a password to check its strength.
   - Choose the option to encrypt or decrypt passwords.
   - Provide the necessary passwords for encryption and decryption.

## Customization

You can customize the script by adjusting the password strength criteria and modifying the `blacklist.txt` file to include common passwords you want to block.

## Caution

- Ensure that you remember the encryption password you set, as it is required for decryption.
- Keep your encrypted password files and decryption passwords secure.

## License

This script is released under the [MIT](LICENSE)

## Acknowledgments

- The script uses the Figlet tool for the colorful header.
- OpenSSL is used for encryption and decryption.
