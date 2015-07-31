#!/bin/bash

# Base path
script_path=$(readlink -f $0)
bin_dir=$(dirname $script_path)
root_dir=$(dirname $bin_dir)

relay_config=$1

if [ -z "$relay_config" ] ; then
  echo "Must specify one relay config file"
  exit 1
fi

cd $root_dir

conf_dir="./conf"
lib_dir="./lib"
log_dir="./logs"

cp="."
for f in ${lib_dir}/*.jar ; do
  cp="${cp}:${f}"
done

relay_pid_file=${root_dir}/var/databus2-relay.pid
relay_out_file=${root_dir}/logs/databus2-relay.out

jvm_gc_log="$log_dir/relay-gc.log"

# JVM ARGUMENTS
jvm_direct_memory_size=2g
jvm_direct_memory="-XX:MaxDirectMemorySize=${jvm_direct_memory_size}"
jvm_min_heap_size="1024m"
jvm_min_heap="-Xms${jvm_min_heap_size}"
jvm_max_heap_size="1024m"
jvm_max_heap="-Xmx${jvm_max_heap_size}"

jvm_gc_options="-XX:NewSize=512m -XX:MaxNewSize=512m -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -XX:SurvivorRatio=6 -XX:MaxTenuringThreshold=7"
jvm_gc_log_option="-XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution "
if [ ! -z "${jvm_gc_log}" ] ; then
  jvm_gc_log_option="${jvm_gc_log_option} -Xloggc:${jvm_gc_log}"
fi

jvm_arg_line="-d64 ${jvm_direct_memory} ${jvm_min_heap} ${jvm_max_heap} ${jvm_gc_options} ${jvm_gc_log_option} -ea"

log4j_file_option="-l ${conf_dir}/relay_log4j.properties"
config_file_option="-p ${conf_dir}/$relay_config.properties"

java_arg_line="${config_file_option} ${log4j_file_option}"

main_class="com.lefu.normalrelay.NormalRelay"

cmdline="java -cp ${cp} ${jvm_arg_line} ${main_class} ${java_arg_line} "
echo $cmdline
$cmdline 2>&1 > ${relay_out_file} &
echo $! > ${relay_pid_file}

