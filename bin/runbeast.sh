#!/bin/sh

if [ -z "$BEAST_QUEUE" ] ; then
  BEAST_QUEUE=long.q
  export BEAST_QUEUE
fi

if [ -z "$BEAST_HMEM" ] ; then
  BEAST_HMEM=6G
  export BEAST_HMEM
fi

if [ $# -ne 1 -a $# -ne 2 ] ; then
  echo "Usage: runbeast.sh <XML filename> [<BEAST version>]" >&2
  echo "    If you want to use non-standard BEAGLE flags, set BEAGLE environment variable (e.g 'export BEAGLE=-beagle_SSE')" >&2
  echo "    and the queue is set to $BEAST_QUEUE, set the BEAST_QUEUE environment variable to use a different queue." >&2
  echo "    By default 6GB of RAM is requested (-l h_vmem=6G), if you want more set BEAST_HMEM environment variable to the" >&2
  echo "    value you want (e.g. export BEAST_HMEM=8G). BEAST uses 64m for Java stack size and 2048m for Java heap size by" >&2
  echo "    default, if you want to change these set BEAST_STACK and BEAST_MEM respectively. Finally the BEAST_SEED" >&2
  echo "    environment variable allows for manual setting of the BEAST seed. Whatever you set this variable to will" >&2
  echo "    be used as the seed for BEAST (e.g. setting BEAST_SEED to 141 will result in seeds that start with 141)." >&2

  exit 1
fi

XML=$1

if [ $# -eq 2 ] ; then
  BEAST=$2
else
  BEAST="default"
fi
export BEAST

if [ -n "$BEAST_SEED" ] ; then
  echo "BEAST SEED: $BEAST_SEED"
else
  # generate our own seed because BEAST uses current time for seed
  # here we generate a single random digit, the code in make_seed.py will fill in the rest in runbeast_xml.sh
  BEAST_SEED=`python -c 'from __future__ import print_function; import random; print(random.SystemRandom().randint(0, 9))'`
  export BEAST_SEED
fi

count=0
for i in `find . -maxdepth 1 -type d` ; do
  if [ $i = "." ] ; then
    continue
  fi
  count=`expr $count + 1`
  NAME=`basename \`pwd\``_`basename $i`
  CURDIR=`pwd`
  WD=$CURDIR/$i
  PATH=$PATH:$CURDIR
  qsub -v BEAST_SEED -v BEAST_MEM -v BEAST_STACK -v BEAST -v BEAGLE -l h_vmem=$BEAST_HMEM -wd $WD -N $NAME -q $BEAST_QUEUE `which runbeast_xml.sh` $CURDIR/$XML
done
if [ $count -eq 0 ] ; then
  echo "No jobs submitted. Do you have rep subdirectories?" >& 2
fi
