#!/bin/bash
#
set -e
#
boxes=(lucid32 lucid64)
branches=(bfast bfast-bwa)
tmp="/tmp/$0.$(echo $RANDOM)"
git_url="git://bfast.git.sourceforge.net/gitroot/bfast"
logs_dir="`pwd`/logs"
ts=`date +%d.%m.%y.%H.%S.%s`

log()
{
  echo "`date`>> $1" 1>&2
}

look_for_changes()
{
  local b=$1
  if [ -d $b ];then
    log "pulling"
    cd $b
    [ `git pull | wc -l` == 1 ] && echo 0 || echo 1
    cd ..
  else
    log "cloning"
    git clone -q $git_url/$b
    echo 1 
  fi
}

compile_pipe()
{
  local b=$1
  local arch=$2
  cd $b 
  log "Building $b branch in arch $arch"
  (
  sh ./autogen.sh && ./configure && make && make check
  ) &> $logs_dir/$arch.$b.$ts.log
  log "Exit status: $?"
  cd ..
}

# 
# Main
# The local machine is a Darwin(OSX) box. 
#
mkdir -p $logs_dir
for branch in "${branches[@]}"; do
  log "Looking for changes in branch: $branch"
  changes=$(look_for_changes $branch)
  if [ $changes == "1" ];then
    log "$branch: NEW commits."
    compile_pipe $branch "Darwin"
  else
    log "$branch: NO new commits"
  fi
done
