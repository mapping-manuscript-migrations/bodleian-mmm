#!/usr/bin/env bash

set -e

OWNER=$1
REPO=$2
BRANCH=$3
LOG=${4:-"`basename -s .sh $0`.log"}

echo >> $LOG
echo "***** START OF: `basename $0` *****" >> $LOG
date >> $LOG

cd $REPO 2>> $LOG

echo "Updating RDF files in $BRANCH branch of the $OWNER/$REPO repository on GitHub..." | tee -a ../$LOG
git add -A >> ../$LOG 2>&1
git commit -a -m "RDF regenerated from source TEI" >> ../$LOG 2>&1
git push >> ../$LOG 2>&1
echo "Update finished." | tee -a ../$LOG

echo "***** END OF: `basename $0` *****" >> ../$LOG

exit 0;

