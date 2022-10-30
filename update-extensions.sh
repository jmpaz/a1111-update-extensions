# This shell script runs `git pull` in every subdirectory of extensions/ (or your custom folder path).


# Set the path to your extensions folder here.
EXTENSIONS_PATH="extensions"

if [ $# -eq 1 ]; then
    EXTENSIONS_PATH=$1
fi

# Iterate over all subdirectories of the extensions folder.
for dir in $EXTENSIONS_PATH/*/
do
    echo "Updating $dir"
    cd $dir
    git pull
    cd ../../
done

# Print a list of results.
echo "Updated the following extensions:"
for dir in $EXTENSIONS_PATH/*/
do
    # Fetch commit details
    cd $dir
    COMMIT_HASH=$(git rev-parse HEAD)
    COMMIT_DATE=$(git log -1 --format=%cd --date=short)
    cd ../../
    # Print the result
    echo "$(basename $dir) ($COMMIT_HASH, $COMMIT_DATE)"
done

echo "Done."