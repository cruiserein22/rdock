#!/bin/bash

# Set the repository root directory
REPO_ROOT=$(git rev-parse --show-toplevel)

# Set the separator character
SEPARATOR="^"

# Change to the repository root directory
cd "$REPO_ROOT" || exit

# Find all files excluding those in the .git directory
find . -type f -not -path "./.git/*" -print0 | while IFS= read -r -d $'\0' file; do
    # Get the relative path of the file
    RELATIVE_PATH=$(dirname "$file")

    # Replace directory separators with the separator character
    FLATTENED_PATH=$(echo "$RELATIVE_PATH" | tr '/' "$SEPARATOR")

    # Construct the new filename
    NEW_FILENAME="${FLATTENED_PATH}${SEPARATOR}$(basename "$file")"

    # If the new filename already exists, add a unique suffix
    if [ -e "$NEW_FILENAME" ]; then
        SUFFIX=$(date +%s%N)
        NEW_FILENAME="${FLATTENED_PATH}${SEPARATOR}$(basename "$file")${SEPARATOR}${SUFFIX}"
    fi

    # Move the file and rename it
    mv -i "$file" "$NEW_FILENAME"
done

# Stage all changes for commit
git add .
     # ... (previous code)

# Use a default commit message
COMMIT_MESSAGE="Flatten repository and prepend paths to filenames"

     # Or read the commit message from a file (e.g., commit_message.txt)
     # COMMIT_MESSAGE=$(cat commit_message.txt)

     # Commit the changes
git commit -m "$COMMIT_MESSAGE"

     # ... (rest of the script)

# Push the changes to the remote repository
git push origin main  # Assuming 'main' is your default branch