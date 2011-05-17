#!/bin/bash
#
set -e
#
boxes=(lucid32 lucid64)
branches=(bfast bfast-bwa)
tmp="/tmp/$0.$(echo $RANDOM)"
git_url="git://bfast.git.sourceforge.net/gitroot/bfast"

log()
{
  echo "`date`>> $1" 1>&2
}

look_for_changes()
{
  local b=$1
  if [ -d $b ];then
    cd $b
    [ `git pull | wc -l` == 1 ] && echo 0 || echo 1
  else
    git clone -q $git_url/$b
    echo 1 
  fi
}

# 
# Main
for branch in "${branches[@]}"; do
  changes=$(look_for_changes $branch)
  if [ $changes == "1" ];then
    log "$branch: CHANGES"
  else
    log "$branch: NO changes"
  fi
done
