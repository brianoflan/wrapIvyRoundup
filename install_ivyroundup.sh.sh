#!/bin/bash

set -e ;

# ivyrepoGitUrl=https://github.com/archiecobbs/ivyroundup.git ;
ivyrepoGitUrl=https://github.com/brianoflan/ivyroundup-non-interactive.git

if [[ -z $IVY_JAR ]] ; then
  # export IVY_JAR=~/workspace/w/gen_use/lang/ivy/resource/ivy/ivy.jar ;
  export IVY_JAR=~/workspace/w/gen_use/lang/ivy/ivy_repo4/org.apache.ivy/ivy/2.1.0/jars/ivy-2.1.0.jar ;
fi ;

d0="$1" ;
if [[ -z $1 ]] ; then
  d0=~/workspace/w/gen_use/lang/ivy/resource/ivyroundup ;
fi ;
shift || true ;

echo here ;

if [[ ! -d "$d0" ]] ; then
  mkdir -p "$d0"
fi ;
cd "$d0" ;

if [[ ! -d ivyroundup ]] ; then
  # git clone https://github.com/archiecobbs/ivyroundup.git ;
  git clone $ivyrepoGitUrl ;
fi ;

if [[ ! -L repomod ]] ; then
  ln -s ivyroundup/repo/modules/ ./repomod ;
fi ;

if [[ ! -L srcmod ]] ; then
  ln -s ivyroundup/src/modules/ ./srcmod ;
fi ;

cd ivyroundup ;
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
