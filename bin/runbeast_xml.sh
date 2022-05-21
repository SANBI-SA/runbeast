#!/bin/bash

echo "BEAST is: $BEAST"
if [ -z "$BEAST" ] ; then
  BEAST=1.10.4--hdfd78af_2
fi

BEAST_CMD=singularity exec /tools/containers/beast/beast-${BEAST}.simg beast

THREADS=
if [ -n "$SLURM_NPROCS" ] ; then
  THREADS="-threads $SLURM_NPROCS
fi

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

XML=$1

# this is old node-specific logic
# HOSTNAME=$(hostname -s)
# echo "running on :$HOSTNAME:"
# if [[ $HOSTNAME =~ ^gridg[0-9]+ ]] ; then
#   echo "running on gridg"
#   ORIG_WORKDIR=$(pwd)
#   WORKDIR=/var/tmp/beast/$JOB_ID
#   if [[ -d $WORKDIR ]] ; then rm -rf $WORKDIR ; fi
#   mkdir $WORKDIR
#   cp $XML $WORKDIR
#   cd $WORKDIR
# else
#   echo "not running on gridg"
# fi

echo $BEAST_CMD -overwrite $SEED_OPT $THREADS $BEAGLE_OPT $XML
time $BEAST_CMD -overwrite $SEED_OPT $THREADS $BEAGLE_OPT $XML

# if [[ "$HOSTNAME" =~ ^gridg[0-9]+ ]] ; then
#   cp * $ORIG_WORKDIR
#   cd $ORIG_WORKDIR
#   rm -rf $WORKDIR
# fi
