#!/bin/bash

error='' ;
/bin/bash $0.sh "$@" 2>&1 | tee out.txt || error=$? ;
if [[ $error -gt 0 ]] ; then
  echo "Error: non-zero exit code from $0.sh: '$error'." ;
  exit 1 ;
fi ;

#
