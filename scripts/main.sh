#!/usr/bin/env bash

set -e

LOG="`basename -s .sh $0`.log"

onerror() {
    echo >> $LOG
    echo "***** PROCESS FAILED *****" >> $LOG
    echo "Process failed. See $LOG for details."
}

trap onerror EXIT

echo >> $LOG
echo "***** START OF: `basename $0` *****" >> $LOG
date >> $LOG

source settings.conf

if [[ -z "$TEI_SOURCE_BRANCH" || -z "$DEST_FORK_OWNER" || -z "$X3ML_VERSION" || -z "$NAME" || -z "$EMAIL" ]]; then
    echo "Please edit settings.conf and set values for all variables" | tee -a $LOG
    exit 1;
fi

scripts/download-x3ml.sh $LOG
scripts/pull-from-github.sh "bodleian" "medieval-mss" $TEI_SOURCE_BRANCH $LOG
scripts/simplify-tei-for-x3ml.sh $LOG
scripts/pull-from-github.sh $DEST_FORK_OWNER "bodleian-RDF" "master" $LOG
scripts/x3ml-map-tei-to-rdf.sh $LOG
scripts/push-to-github.sh $DEST_FORK_OWNER "bodleian-RDF" "master" $LOG

trap - EXIT
echo "***** END OF: `basename $0` *****" >> $LOG
echo "Process finished."