#!/bin/bash

. /etc/profile.d/module.sh

echo "BEAST is: $BEAST"
if [ -z "$BEAST" ] ; then
  BEAST=default
fi

module add beast/$BEAST
THREADS=
if [ -n "$pe_slots" ] ; then
  THREADS="-threads $pe_slots"
fi

module add runbeast

if [ -n "$BEAST_SEED" ] ; then
  SEED=`make_seed.py $BEAST_SEED`
  SEED_OPT="-seed $SEED"
else
  SEED_OPT=""
fi

if [ -z "$BEAGLE" ] ; then
  BEAGLE_OPT="-beagle"
else
  BEAGLE_OPT=$BEAGLE
fi

if [ $# != 1 ] ; then
  echo "Usage: runbeast_xml.sh <XML filename>" >&2
  exit 1
fi

which beast
XML=$1
echo beast -overwrite $SEED_OPT $THREADS $BEAGLE_OPT $XML
time beast -overwrite $SEED_OPT $THREADS $BEAGLE_OPT $XML
