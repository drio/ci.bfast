#!/bin/bash
#
set -e
set -x
#
boxes=(lucid32 lucid64)
branches=(bfast bfast-bwa)
tmp="/tmp/$0.$(echo $RANDOM)"
git_url="git://bfast.git.sourceforge.net/gitroot/bfast"
logs_dir="`pwd`/logs"
ts=`date +%d.%m.%y.%H.%S.%s`
identity_file=`vagrant ssh_config | grep IdentityFile | awk '{print $2}'`
ssh_cmd="ssh -p 2222 -o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no -o IdentitiesOnly=yes \
-i $identity_file -o LogLevel=ERROR vagrant@127.0.0.1"

log()
{
  echo "`date`>> $1" 1>&2
}

look_for_changes()
{
  local b=$1
  if [ -d $b ];then
    cd $b
    log "make clean" ; make clean &>/dev/null
    log "pulling"
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
active_branches=""
for branch in "${branches[@]}"; do
  log "Looking for changes in branch: $branch"
  changes=$(look_for_changes $branch)
  if [ $changes == "1" ];then
    log "$branch: NEW commits."
    active_branches="$active_branches $branch"  
    compile_pipe $branch "Darwin"
  else
    log "$branch: NO new commits"
    active_branches="$active_branches $branch"  
  fi
done

# If new commits in branch, run pipe in the 
# different virtual boxes
# 1. set vagrant file
# 2. destory vb
# 3. up vb
# 4. ssh bfast pipe and log
#
v_file="Vagrantfile"
v_cfg_files="vagrant_files"
logs_dir="`pwd`/logs"
for box in "${boxes[@]}"; do
  for branch in $active_branches; do
    current_log="$logs_dir/$box.$ts.log"
    log "Working on box: ${box} branch: ${branch}"
    
    rm -f $v_file; ln -s $v_cfg_files/${box}.vf $v_file
    log "Starting box: ${box}"
    vagrant up #2>&1 >> $current_log

    log "Building bfast: ${box}"
    $ssh_cmd "cd /vagrant/bfast && \
    make clean && sh ./autogen.sh && \
    ./configure && make && make check"  #2>&1 >> $current_log
    log "Exit status: $?"
  done 
  log "Destroying vb: ${box}"
  vagrant destroy #2>&1 >> $current_log 
done
