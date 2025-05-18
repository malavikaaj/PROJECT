#!/bin/bash

# Encrypted Journal Script

# Directory to store encrypted journals
JOURNAL_DIR="$HOME/myjournal"

# Check if the journal directory exists
if [ ! -d "$JOURNAL_DIR" ]; then
    echo "The journal directory '$JOURNAL_DIR' does not exist. Please create it manually."
    exit 1
fi

# Function to write a new journal entry
write_entry() {
    # Prompt for password
    read -sp "Enter encryption password: " password
    echo

    # Prompt for a custom journal name
    read -p "Enter a name for your journal entry (no spaces, e.g., my_journal): " journal_name
    filename="${JOURNAL_DIR}/${journal_name}.enc"

    # Check if the file already exists
    if [ -f "$filename" ]; then
        echo "A journal entry with this name already exists. Please choose a different name."
        return
    fi

    # Prompt for journal entry
    echo "Enter your journal entry (press Ctrl+D when finished):"
    entry=$(cat)

    # Encrypt the entry using DES
    echo "$entry" | openssl enc -des3 -salt -pbkdf2 -out "$filename" -pass pass:"$password"

    echo "Journal entry saved successfully."
}

# Function to list and read existing journals
read_entry() {
    # Check if any journals exist
    if [ -z "$(ls -A "$JOURNAL_DIR"/*.enc 2>/dev/null)" ]; then
        echo "No journal entries found."
        return
    fi

    # List available journals (only show file names without path)
    echo "Available Journal Entries:"
    ls "$JOURNAL_DIR"/*.enc | xargs -n 1 basename | nl

    # Prompt for journal selection
    read -p "Enter the number of the journal to read: " selection
    selected_file=$(ls "$JOURNAL_DIR"/*.enc | sed -n "${selection}p")

    if [ -z "$selected_file" ]; then
        echo "Invalid selection."
        return
    fi

    # Extract the file name from the path (for decryption)
    selected_file_name=$(basename "$selected_file")

    # Prompt for password
    read -sp "Enter decryption password: " password
    echo

    # Attempt to decrypt and display the entry
    decrypted_content=$(openssl enc -d -des3 -salt -pbkdf2 -in "$JOURNAL_DIR/$selected_file_name" -pass pass:"$password")
    
    if [ $? -eq 0 ]; then
        echo -e "\n--- Journal Entry ---"
        echo "$decrypted_content"
    else
        echo "Decryption failed. Incorrect password or corrupted file."
    fi
}

# Main menu
while true; do
    echo -e "\nEncrypted Journal"
    echo "1. Write a New Entry"
    echo "2. Read Existing Journal"
    echo "3. Exit"
    read -p "Choose an option (1-3): " choice

    case $choice in
        1) write_entry ;;
        2) read_entry ;;
        3) 
            echo "Exiting. Have a nice day!"
            exit 0 
            ;;
        *) 
            echo "Invalid option. Please try again."
            ;;
    esac
done