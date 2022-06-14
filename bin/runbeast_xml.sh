#!/bin/bash

if [ -z "$BEAST_VER" -o "$BEAST_VER" = "default" ] ; then
  if [[ $SLURM_CLUSTER_NAME == "ilifu"* ]] ; then
    BEAST_VER=1.10.4
  else
    BEAST_VER=1.10.4--hdfd78af_2
  fi
fi
echo "BEAST is: $BEAST_VER"

if [[ $SLURM_CLUSTER_NAME == "ilifu"* ]] ; then
  module add beast/beast$BEAST_VER
  BEAST_CMD=${BASH_ALIASES[beast]}
else
  BEAST_CMD="singularity exec /tools/containers/beast/beast-${BEAST_VER}.simg"
fi

if [ -n "$SLURM_NPROCS" ] ; then
  THREADS="-threads $SLURM_NPROCS"
else
  THREADS="-threads 1"
fi

if [ -n "$BEAST_SEED" ] ; then
  SEED=$RANDOM$RANDOM
  SEED_OPT="-seed $SEED"
else
  SEED_OPT=""
fi

if [ -z "$BEAGLE" ] ; then
  if [[ $SLURM_CLUSTER_NAME == "ilifu"* ]] ; then
    BEAGLE_OPT="-beagle_GPU"
  else
    BEAGLE_OPT="-beagle"
  fi
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

echo $BEAST_CMD beast -overwrite $SEED_OPT $THREADS $BEAGLE_OPT $XML
$BEAST_CMD -overwrite $SEED_OPT $THREADS $BEAGLE_OPT $XML

# if [[ "$HOSTNAME" =~ ^gridg[0-9]+ ]] ; then
#   cp * $ORIG_WORKDIR
#   cd $ORIG_WORKDIR
#   rm -rf $WORKDIR
# fi
