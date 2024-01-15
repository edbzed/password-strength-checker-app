#!/bin/bash

# Display colored header using figlet
echo -e "\033[0;33m"  # Set text color to yellow
figlet "Password Checker"
echo -e "\033[0m"  # Reset text color to default

# Check if output.txt exists and delete it
if [ -f "output.txt" ]; then
    echo "Deleting existing output.txt..."
    rm "output.txt"
fi

check_password_strength() {
    password="$1"
    min_length="$2"
    min_upper="$3"
    min_lower="$4"
    min_digits="$5"
    min_special="$6"
    
    strength=0

    # Check if the password is blank
    if [ -z "$password" ]; then
        echo "Password cannot be blank, enter a password"
        return 1
    fi

    # Check password length
    if [ ${#password} -ge "$min_length" ]; then
        ((strength += 2))
    fi

    # Check for uppercase letters
    if [ "$(grep -o -E [A-Z] <<< "$password" | wc -l)" -ge "$min_upper" ]; then
        ((strength += 2))
    fi

    # Check for lowercase letters
    if [ "$(grep -o -E [a-z] <<< "$password" | wc -l)" -ge "$min_lower" ]; then
        ((strength += 2))
    fi

    # Check for digits
    if [ "$(grep -o -E [0-9] <<< "$password" | wc -l)" -ge "$min_digits" ]; then
        ((strength += 2))
    fi

    # Check for special characters
    if [ "$(grep -o -E '[!@#$%^&*()]' <<< "$password" | wc -l)" -ge "$min_special" ]; then
        ((strength += 2))
    fi

    # Check if the password is in the blacklist (you can maintain a file with blacklisted passwords)
    if grep -q -w -F "$password" blacklist.txt; then
        echo "Password is too common and should be avoided"
        return 1
    fi

    if [ "$strength" -lt 6 ]; then
        echo "Password is weak"
    elif [ "$strength" -lt 10 ]; then
        echo "Password is moderate"
    else
        echo "Password is strong"
    fi

    # Write the password to an output file
    echo "$password" >> output.txt
    
    return 0
}

encrypt_output_file() {
    # Prompt the user for a password to encrypt the output file
    read -sp "Enter a password to encrypt the output file: " encryption_password
    echo

    # Encrypt the output file using openssl with -pbkdf2
    openssl enc -aes-256-cbc -salt -pbkdf2 -in output.txt -out encrypted_output.enc -pass pass:"$encryption_password"

    # Check if encryption was successful
    if [ $? -eq 0 ]; then
        echo "The output file has been encrypted as 'encrypted_output.enc'."
        echo "Make sure to remember the encryption password as it is required for decryption."
        # Remove the original output.txt file
        rm "output.txt"
    else
        echo "Encryption failed. Please try again."
    fi
}

decrypt_output_file() {
    # Prompt the user for the decryption password
    read -sp "Enter the decryption password: " decryption_password
    echo

    # Decrypt the encrypted output file using openssl with -pbkdf2
    openssl enc -d -aes-256-cbc -salt -pbkdf2 -in encrypted_output.enc -out decrypted_output.txt -pass pass:"$decryption_password"

    echo "The output file has been decrypted as 'decrypted_output.txt'."
}

display_menu() {
    echo "Choose an option:"
    echo "1. Encrypt Output File"
    echo "2. Decrypt Output File"
    echo "3. Quit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            encrypt_output_file
            ;;
        2)
            decrypt_output_file
            ;;
        3)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a valid option."
            ;;
    esac
}

# Set your desired criteria here
min_length=15
min_upper=1
min_lower=1
min_digits=1
min_special=1

mask_password() {
    while true; do
        read -sp "Enter a password: " user_password
        echo
        if [ -z "$user_password" ]; then
            echo "Password cannot be blank, enter a password"
        else
            check_password_strength "$user_password" "$min_length" "$min_upper" "$min_lower" "$min_digits" "$min_special"
            display_menu
            break
        fi
    done
}

mask_password
