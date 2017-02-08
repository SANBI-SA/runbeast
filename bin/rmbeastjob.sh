#!/bin/bash

if [[ $# -ne 1 ]] ; then
  echo "Usage: rmbeastjob.sh <JOBID>" >& 2
  exit 1
fi

BEAST_DIR=/var/tmp/beast
if [[ -d $BEAST_DIR/$1 ]] ; then
  rm -rf $BEAST_DIR/$1
fi
