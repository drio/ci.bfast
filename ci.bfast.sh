#!/bin/bash
#
set -e
#
# The process looks like this:
#
# box
#   branch
#     unless Darwin
#       + fireup box
#       + clone, autogen, config, make, make test 
#       + destory box
#     else
#       + clone, autogen, config, make, make test 
#       + remove
#   update html page
# 
boxes=(darwin lucid32 lucid64)
branches=(bfast bfast-bwa)
tmp="/tmp/$0.$(echo $RANDOM)"
git_url="git://bfast.git.sourceforge.net/gitroot/bfast/"

have_changes()
{
  [ `git pull | wc -l` == 1 ] && return 0 || return 1
}

before_darwin()
{
  if [ -d $brand ];then
    cd $brand
    have_changes
    [ $? -eq 1 ] && return 1 || return 0
  else
    git clone $git_url/$branch
  fi
}

# 
# Main
for box in "${boxes[@]}";do
  for branch in "${branches[@]}"; do
    if [ $box == "darwin" ];then
      before_darwin
      after_darwin
    else
      echo "$box:$branch"
      before_vb
      after_vb 
    fi
  done
done
