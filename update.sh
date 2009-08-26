#!/bin/sh

PACKAGEDIR=$CAPP_BUILD/Cappuccino/objj

if [ -d $PACKAGEDIR ]; then
    # copy package contents
    cp -r $PACKAGEDIR/* .
    
    # strip extra .j files
    SJS=$(find . -name "*.sj")
    for SJ in $SJS; do
        DIR=$(dirname $SJ)
        find $DIR -depth 1 -name "*.j" -delete
    done
    
else
    echo "Package doesn't exist at $PACKAGEDIR"
fi

