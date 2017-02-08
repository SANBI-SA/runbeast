#!/bin/bash

BEAST_DIR=/var/tmp/beast
for num in $(seq 1 2) ; do 
  for dir in $(ssh -x gridg$num.sanbi.ac.za ls $BEAST_DIR) ; do 
    qstat -j $dir 2>&1 | grep "Following jobs do not exist" >/dev/null
    if [ $? -eq 0 ] ; then
      echo "dead job $dir"
      ssh -x gridg$num.sanbi.ac.za sudo /cip0/software/no-arch/runbeast/bin/rmbeastjob.sh $dir
    else
      echo "live job $dir"
    fi
  done
done 
