#!/bin/bash

if [ $# -ne 4 ]
then
    echo "Usage: ./PushToGitHub.sh <folder_name> <commit_message> <file_name> <branch_name>"
    exit 1
fi

cd "$1" || exit 1

echo "Checking if folder has a local repo"

if [ -d ".git" ]
then
    echo "Folder already has a local repo"

else
    echo "No local repo found, initializing now"

    git init

    echo "Please enter your Git username:"
    read USERname
    git config user.name "$USERname"

    echo "Please enter your Git email:"
    read USERemail
    git config user.email "$USERemail"

    echo "Setting branch name to main"
    git branch -M main
fi

echo "Checking remote connection"

isConnected=$(git remote)

if [ -z "$isConnected" ]
then
    echo "Remote repo is not connected"

    echo "Please enter remote repo link:"
    read Link

    git remote add origin "$Link"

    echo "Remote repo connected"

else
    echo "Remote repo already connected"
fi

git checkout "$4" 2>/dev/null || git checkout -b "$4"

echo "Fetching remote changes"
git fetch

echo "Pulling remote changes"
git pull origin "$4"

if [ $? -eq 0 ]
then
    echo "Pull completed successfully"

else
    echo "Merge conflict or pull error detected"
    echo "Please resolve conflicts manually before running the script again"
    exit 1
fi

echo "Checking for changes"

if [ -z "$(git status --porcelain)" ]
then
    echo "No changes detected"
    exit 0
fi

echo "Adding files"
git add "$3"

echo "making a commit"
git commit -m "$2"

if [ $? -eq 0 ]
then
    echo "Commit created successfully"

else
    echo "Commit failed"
    exit 1
fi

echo "Pushing changes to remote repo"
git push -u origin "$4"

if [ $? -eq 0 ]
then
    echo "Push completed successfully"

else
    echo "Push failed"
    exit 1
fi

echo "Task completed successfully"

exit 0
