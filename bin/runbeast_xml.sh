#!/bin/bash

if [ -z "$BEAST_VER" -o "$BEAST_VER" = "default" ] ; then
  BEAST_VER=1.10.4--hdfd78af_2
fi
echo "BEAST is: $BEAST_VER"

BEAST_CMD="singularity exec /tools/containers/beast/beast-${BEAST_VER}.simg beast"

if [ -n "$SLURM_NPROCS" ] ; then
  THREADS="-threads $SLURM_NPROCS"
else
  THREADS="-threads 1"
fi

if [ -n "$BEAST_SEED" ] ; then
  SEED=$(/tools/software/runbeast/bin/make_seed.py $BEAST_SEED)
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
$BEAST_CMD -overwrite $SEED_OPT $THREADS $BEAGLE_OPT $XML

# if [[ "$HOSTNAME" =~ ^gridg[0-9]+ ]] ; then
#   cp * $ORIG_WORKDIR
#   cd $ORIG_WORKDIR
#   rm -rf $WORKDIR
# fi
