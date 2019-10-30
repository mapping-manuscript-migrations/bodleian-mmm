#!/usr/bin/env bash

set -e

LOG=${1:-"`basename -s .sh $0`.log"}

INDIR="medieval-mss"
OUTDIR="simple_xml"
XQUERYDIR="xquery"
SAXONJAR="saxon/saxon9he.jar"

echo >> $LOG
echo "***** START OF: `basename $0` *****" >> $LOG
date >> $LOG

mkdir -p $OUTDIR 2>> $LOG

echo "Converting TEI to simpler XML format for mapping..." | tee -a $LOG

# Output to 20 chunks, to avoid x3ml memory issues
for i in {0..19}
do
    java -Xmx1G -cp $SAXONJAR net.sf.saxon.Query -xi:on -q:"$XQUERYDIR/simplify-records-for-x3ml.xquery" -o:$OUTDIR/manuscripts_chunk$i.xml collectionsfolder="../$INDIR/collections" chunk=$i numchunks=20 2>> $LOG
done

echo "Conversion finished" | tee -a $LOG

echo "Converting authority files to simpler XML format for mapping..." | tee -a $LOG

# Chunk persons and works, again so the x3ml can process them in minutes rather than hours.
for i in {0..4}
do
    java -Xmx1G -cp $SAXONJAR net.sf.saxon.Query -xi:on -q:"$XQUERYDIR/simplify-authorities-for-x3ml.xquery" -o:$OUTDIR/persons_chunk$i.xml authorityfile="../$INDIR/persons.xml" chunk=$i numchunks=5 2>> $LOG
    java -Xmx1G -cp $SAXONJAR net.sf.saxon.Query -xi:on -q:"$XQUERYDIR/simplify-authorities-for-x3ml.xquery" -o:$OUTDIR/works_chunk$i.xml authorityfile="../$INDIR/works.xml" chunk=$i numchunks=5 2>> $LOG
done

# Places authority file is smaller, so does not need to be chunked
java -Xmx1G -cp $SAXONJAR net.sf.saxon.Query -xi:on -q:"$XQUERYDIR/simplify-authorities-for-x3ml.xquery" -o:$OUTDIR/places.xml authorityfile="../$INDIR/places.xml" chunk=0 numchunks=1 2>> $LOG

echo "Conversion finished." | tee -a $LOG

echo "***** END OF: `basename $0` *****" >> $LOG

exit 0;