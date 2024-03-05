#!/bin/sh

title=$1
echo "Post title: $1"

# Escape special characters for HTML
html_title=$(echo $title | sed -e 's/"/\&quot;/g')
html_title=$(echo $html_title | sed -e "s/'/\&#039;/g")
html_title=$(echo $html_title | sed -e 's/&/\&amp;/g')
html_title=$(echo $html_title | sed -e 's/</\&lt;/g')
html_title=$(echo $html_title | sed -e 's/>/\&gt;/g')

echo "Escaped post title: $html_title"

# Generate the file name
file=$(echo $title | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:] ' | tr -s ' ' | tr '[:space:]' '-')
file=$(echo $file | sed -e 's/-$//' | sed -e 's/^-//')
file=$(date +%Y-%m-%d)-$file.md
file=_posts/$file
echo "File path: $file"

# Check if the file already exists
if [ -f $file ]; then
    echo "File $file already exists!"
    exit 1
fi

# Create the file
touch $file

echo "---" >>$file
echo "layout: post" >>$file
echo "title: $html_title" >>$file
echo "---" >>$file

echo "Created $file"

# Open the file in VSCode or the default editor
if [ -x "$(command -v code)" ]; then
    code $file
elif [ -x "$(command -v xdg-open)" ]; then
    xdg-open $file
else
    open $file
fi
