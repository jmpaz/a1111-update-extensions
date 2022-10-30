#!/bin/bash

# This shell script updates every subdirectory in extensions/ (or your custom path).
# Usage: ./update_extensions.sh [extensions_path]

# Set the path to your extensions folder here.
EXTENSIONS_PATH="extensions"

# If provided, use the first argument as extensions path
if [ $# -eq 1 ]; then
    EXTENSIONS_PATH=$1
fi

# Check that the extensions directory exists
if [ ! -d "$EXTENSIONS_PATH" ]; then
    echo "Extensions directory $EXTENSIONS_PATH does not exist."
    exit 1
fi

# Iterate over all subdirectories of the extensions folder.
UPDATED_EXTENSIONS=()
for dir in $EXTENSIONS_PATH/*/
do
    echo "Updating $dir"
    # Get the current commit hash.
    CURRENT_COMMIT=$(git -C $dir rev-parse HEAD)
    git -C $dir pull
    # Get the new commit hash.
    NEW_COMMIT=$(git -C $dir rev-parse HEAD)
    # If the commit hash has changed, add the extension to the list of updated extensions, along with its original and updated commit hashes.
    if [ "$CURRENT_COMMIT" != "$NEW_COMMIT" ]; then
        UPDATED_EXTENSIONS=("${UPDATED_EXTENSIONS[@]}" "$dir $CURRENT_COMMIT $NEW_COMMIT")
    fi
done

# If any extensions were updated, list name and commit hashes for each
if [ ${#UPDATED_EXTENSIONS[@]} -gt 0 ]; then
    echo "\nUpdated extensions:"
    for extension in "${UPDATED_EXTENSIONS[@]}"
    do
        echo "  $extension"
    done
else
    echo "\nNo updates."
fi