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

# 
# Main
for box in "${boxes[@]}";do
  for branch in "${branches[@]}"; do
    if [ $box == "darwin" ];then
      ci_darwin $branch
    else
      echo "$box:$branch"
    fi
  done
done
