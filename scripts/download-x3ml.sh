#!/usr/bin/env bash

set -e

LOG=${1:-"`basename -s .sh $0`.log"}

echo >> $LOG
echo "***** START OF: `basename $0` *****" >> $LOG
date >> $LOG

source settings.conf

X3MLJAR="x3ml/x3ml-engine-$X3ML_VERSION-exejar.jar"

if [ ! -e "$X3MLJAR" ]; then
    echo "Downloading x3ml software from FORTH-ICS ISL's GitHub repository..." | tee -a $LOG
    curl -fsL "https://github.com/isl/x3ml/releases/download/$X3ML_VERSION/x3ml-engine-$X3ML_VERSION-exejar.jar" -o "$X3MLJAR" 2>> $LOG
    echo "Download finished." | tee -a $LOG
else
    echo "Version $X3ML_VERSION of x3ml software already downloaded." | tee -a $LOG
fi

echo "***** END OF: `basename $0` *****" >> $LOG

exit 0;