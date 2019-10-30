#!/usr/bin/env bash

set -e

LOG=${1:-"`basename -s .sh $0`.log"}

INDIR="simple_xml"
OUTDIR="bodleian-RDF"
CONFIGDIR="x3ml"

source settings.conf

X3MLJAR="x3ml/x3ml-engine-$X3ML_VERSION-exejar.jar"

echo >> $LOG
echo "***** START OF: `basename $0` *****" >> $LOG
date >> $LOG

mkdir -p $OUTDIR 2>> $LOG

echo "Mapping simplified XML to RDF..." | tee -a $LOG

# Run x3ml on each chunk created by simplify-tei-for-x3ml.sh
for i in {0..19}
do
    java -Xmx1G -jar $X3MLJAR -i $INDIR/manuscripts_chunk$i.xml -x "$CONFIGDIR/manuscripts_mapping.x3ml" -p "$CONFIGDIR/generator.xml" -o $OUTDIR/manuscripts_chunk$i.rdf >> $LOG 2>&1
done

# Run x3ml on authority files, which for persons and works are chunked
for i in {0..4}
do
    java -Xmx1G -jar $X3MLJAR -i $INDIR/persons_chunk$i.xml -x "$CONFIGDIR/persons_mapping.x3ml" -p "$CONFIGDIR/generator.xml" -o $OUTDIR/persons_chunk$i.rdf >> $LOG 2>&1
    java -Xmx1G -jar $X3MLJAR -i $INDIR/works_chunk$i.xml -x "$CONFIGDIR/works_mapping.x3ml" -p "$CONFIGDIR/generator.xml" -o $OUTDIR/works_chunk$i.rdf >> $LOG 2>&1
done

# Places authority file is smaller, so does not need to be chunked
java -Xmx1G -jar $X3MLJAR -i $INDIR/places.xml -x "$CONFIGDIR/places_mapping.x3ml" -p "$CONFIGDIR/generator.xml" -o $OUTDIR/places.rdf >> $LOG 2>&1

echo "Mapping finished. RDF files generated." | tee -a $LOG

echo "***** END OF: `basename $0` *****" >> $LOG

exit 0;