#!/bin/sh

function usage {
  local msg=$1
  echo
  echo "ERROR: $msg"
  echo
  echo "Usage:"
  echo "./sftp-run.sh <root> <organization> <port>"
  echo
  exit -1
}

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

root=$1
organization=$2
port=$3

[[ -z $root ]]         && usage 'missing root argument'
[[ -z $organization ]] && usage 'missing organization argument'
[[ -z $port ]]         && usage 'missing port argument'

mkdir -p $root/data/$organization
sudo cp $scriptdir/data/readme.txt $root/data/$organization

docker stop sftp.$organization 2> /dev/null
docker rm   sftp.$organization 2> /dev/null

docker run -d \
-p $port:22 \
-v $root/data/$organization:/sftp \
-v $root/keys:/keys \
--name sftp.$organization \
42technologies/sftp