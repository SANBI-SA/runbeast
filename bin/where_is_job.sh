#!/bin/bash

if [[ $# -ne 1 ]] ; then
  echo "Usage: where_is_job.sh <JOBID>" >&2
  exit 1
fi

JOBID=$1

QUEUE=$(qstat | grep $JOBID | awk '{print $8}')
HOST=$(echo $QUEUE | cut -d@ -f 2)
echo "$HOST:/var/tmp/beast/$JOBID"
