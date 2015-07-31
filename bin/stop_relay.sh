#!/bin/bash

script_path=$(readlink -f $0)
bin_dir=$(dirname $script_path)
root_dir=$(dirname $bin_dir)

cd $root_dir

relay_pid_file=${root_dir}/var/databus2-relay.pid

kill `cat $relay_pid_file`
