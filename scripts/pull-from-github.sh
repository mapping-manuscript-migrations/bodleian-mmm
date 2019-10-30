#!/usr/bin/env bash

set -e

OWNER=$1
REPO=$2
BRANCH=$3
LOG=${4:-"`basename -s .sh $0`.log"}

echo >> $LOG
echo "***** START OF: `basename $0` *****" >> $LOG
date >> $LOG

source settings.conf

if [ ! -d "$REPO/.git" ]; then
    # No local copy, so clone the repository
    if [ ! -d "$REPO" ]; then rm -rf "$REPO" 2>> $LOG; fi
    echo "Downloading $OWNER/$REPO GitHub respository..." | tee -a $LOG
    if [ ! -z "$GITHUB_TOKEN" ]; then
        git clone "https://$GITHUB_TOKEN:@github.com/$OWNER/$REPO.git" >> $LOG 2>&1
    else
        git clone "https://github.com/$OWNER/$REPO.git" >> $LOG 2>&1
    fi
    cd $REPO >> $LOG 2>&1
    git config --local push.default matching >> ../$LOG 2>&1
    git config --local user.name "$NAME" >> ../$LOG 2>&1
    git config --local user.email "$EMAIL" >> ../$LOG 2>&1
    git checkout "$BRANCH" >> ../$LOG 2>&1
    echo "Download finished." | tee -a ../$LOG
else
    # Force-pull to update the local copy
    echo "Updating local copy of $OWNER/$REPO GitHub respository..." | tee -a $LOG
    cd $REPO
    git fetch --all >> ../$LOG 2>&1
    git reset --hard "origin/$BRANCH" >> ../$LOG 2>&1
    git checkout "$BRANCH" >> ../$LOG 2>&1
    echo "Update finished." | tee -a ../$LOG
fi

echo "***** END OF: `basename $0` *****" >> ../$LOG

exit 0;