#!/bin/bash

set -e ;

DEBUG=1 ;

gitBranch=nonInteractiveMinimal ;
# ivyrepoGitUrl=https://github.com/archiecobbs/ivyroundup.git ;
ivyrepoGitUrl=https://github.com/brianoflan/ivyroundup-non-interactive.git

if [[ -f $IVY_JAR ]] ; then
  # export IVY_JAR=~/workspace/w/gen_use/lang/ivy/resource/ivy/ivy.jar ;
  export IVY_JAR=/usr/share/java/ivy.jar ;
fi ;
if [[ -f $IVY_JAR ]] ; then
  # export IVY_JAR=~/workspace/w/gen_use/lang/ivy/resource/ivy/ivy.jar ;
  export IVY_JAR=~/workspace/w/gen_use/lang/ivy/ivy_repo4/org.apache.ivy/ivy/2.1.0/jars/ivy-2.1.0.jar ;
fi ;

d0="$1" ;
if [[ -z $1 ]] ; then
  # d0=~/workspace/w/gen_use/lang/ivy/resource/ivyroundup ;
  d0=`dirname $0` ;
fi ;
shift || true ;
if [[ $DEBUG -gt 0 ]] ; then
  echo "d0 = q($d0)." ;
fi ;

echo here ;

if [[ ! -d "$d0" ]] ; then
  mkdir -p "$d0"
fi ;
cd "$d0" ;

getIvyroundupDir() {
  testFolder=`ls -lartd ivyroundup* | awk '{print $NF}' | tac` ;
  for d in $testFolder ; do
    if [[ -d $d ]] ; then
      ivyrDir=$d ;
      break ;
    fi ;
  done ;
  if [[ -n $ivyrDir ]] ; then
    if [[ "$ivyrDir" != "ivyroundup" ]] ; then
      if [[ ! -d ivyroundup ]] ; then
        ln -s $ivyrDir/ ivyroundup 1>&2 ;
      fi ;
    fi ;
  fi ;
  echo "$ivyrDir" ;
}

ivyrDir=`getIvyroundupDir` ;

if [[ ! -d ivyroundup ]] ; then
  # git clone https://github.com/archiecobbs/ivyroundup.git ;
  git clone $ivyrepoGitUrl ;
fi ;

if [[ -z $ivyrDir ]] ; then
  ivyrDir=`getIvyroundupDir` ;
fi ;
if [[ -z $ivyrDir ]] ; then
  echo "ERROR:  Failed to find ivyroundup dir after cloning the Git repo." 1>&2 ;
  exit 1 ;
fi ;

if [[ ! -L repomod ]] ; then
  ln -s ivyroundup/repo/modules/ ./repomod ;
fi ;

if [[ ! -L srcmod ]] ; then
  ln -s ivyroundup/src/modules/ ./srcmod ;
fi ;

cd ivyroundup ;
git checkout $gitBranch ;
export ANT_OPTS="$ANT_OPTS -Xmx500m" ;
( ant get-xalan all "$@" || true ) ;
git add repo/modules.xml 
git checkout -- repo/css/index.html
git checkout -- repo/images/index.html
git checkout -- repo/xsd/index.html
git checkout -- repo/xsl/index.html
git checkout -- repo/modules/org.apache.xerces
git checkout -- repo/modules/org.apache.xml
# git status

#
