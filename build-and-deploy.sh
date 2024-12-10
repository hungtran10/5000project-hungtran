#!/bin/bash

# Clean-up Step: Remove any existing build
echo "Cleaning up old builds..."
rm -rf 5000-Project
echo "Old build removed."

# Build the Website: Render the Quarto website
echo "Building the website..."
quarto render
echo "Website build completed."

# Remove unnecessary files
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Removing unnecessary .DS_Store files..."
    find 5000-Project -name ".DS_Store" -delete
    echo ".DS_Store files removed."
fi

# Set correct file permissions
echo "Setting file permissions..."
# Set file permissions to 644
find 5000-Project -type f -exec chmod 644 {} \;
# Set directory permissions to 755
find 5000-Project -type d -exec chmod 755 {} \;
echo "Permissions set."

# Prompt the user to push the website
read -p "Do you want to push the website to the server? (y/n): " choice
if [[ "$choice" == [Yy]* ]]; then
    # Push the website to the server
    echo "Pushing the website to the server..."
    #rsync -avz --delete 5000-Project/ mt1584@georgetown.edu:/path/to/your/domains/folder
    scp -r 5000-Project htrangeo@htran.georgetown.domains:/home/htrangeo/public_html/
    echo "Website pushed successfully."
else
    echo "Skipping deployment."
fi
