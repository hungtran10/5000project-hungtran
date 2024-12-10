git pull
# DEFINE PATH
dir1=${PWD}

# START FRESH
rm -rf 5000-Project;

# BUILD WEBSITE
quarto render

# CLEAN UP 
cd 5000-Project; for i in $(find  ./ -name .DS_Store); do rm $i; done; cd "$dir1"

# SET CORRECT PERMISSIONS FOR ALL FILES 
for i in $(find 5000-Project -type f); do chmod 644 $i; done
for i in $(find 5000-Project -type d); do chmod 755 $i; done

# GITHUB SYNC
printf 'Would you like to push to GITHUB? (y/n)? '
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then 

    git config http.postBuffer 20242880000

    # PULL CLOUD REPO TO LOCAL
    git pull 

    # SYNC TO LOCAL REPO TO CLOUD 
    read -p 'ENTER MESSAGE: ' message
    echo "commit message = "$message; 
    git add ./; 
    # MAIN BRANCH
    git commit -m "$message"; 

    # PUSH NON-MAIN BRANCH
    #git push  -u origin w05-draft

    # PUSH MAIN BRANCH
    git push

else
    echo NOT PUSHING TO GTIHUB!
fi


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




# PUSH WEBSITE TO GU DOMAINS 
# printf 'Would you like to push to GU domains? (y/n)? '
# read answer
# if [ "$answer" != "${answer#[Yy]}" ] ;then 
#     rsync -alvr --delete _site/* jfhgeorg@gtown.reclaimhosting.com:/home/jfhgeorg/public_html/dsan-5000/
# else
#     echo NOT PUSHING TO GU DOMAINS!
# fi