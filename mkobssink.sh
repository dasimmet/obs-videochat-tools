#!/usr/bin/env bash

set -e
# Get the index of the selected sink:
getsink() {
    pacmd list-sinks   |grep "* index:"|sed "s/.*index: //"
}
getsource(){
    pacmd list-sources |grep "* index:"|sed "s/.*index: //"
}

findModByName(){
    pactl list|grep -A 5 "Name: $1"|grep "Owner Module:" |sed "s/.*Owner Module: //"|sort|uniq
}

removeModByName(){
for mod in $(pactl list|grep -C1 "Name: module-loopback"|grep -B2 "sink=$1"|grep "Module #"|sed "s/.*Module #//")
do
    if ! [ -n "$mod" ];then continue;fi

    echo "Removing Loopback $mod For Name $1"
    pactl unload-module "$mod"
done
for mod in $(findModByName $1)
do
    if ! [ -n "$mod" ];then continue;fi

    echo "Removing $mod For Name $1"
    pactl unload-module "$mod"

done
}
removeModByName OBSMicSource
removeModByName OBSCombineSink
removeModByName OBSMicSink


[ "$1" == "stop" ] && exit 0

SINK="$(getsink)"
SOURCE="$(getsource)"
echo "Active Sink: $SINK"
echo "Active Source: $SOURCE"

pactl load-module module-null-sink \
    sink_name=OBSMicSink \
    sink_properties=device.description=OBSMicSink

pactl load-module module-loopback \
    sink=OBSMicSink \
    latency_msec=20
#     "source=$SOURCE" \

pactl load-module module-combine-sink \
    sink_name=OBSCombineSink \
    "slaves=OBSMicSink,$SINK" \
    sink_properties=device.description=OBSCombineSink

pactl load-module module-virtual-source \
    source_name=OBSMicSource \
    master=OBSMicSink.monitor \
    source_properties=device.description=OBSMicSource

