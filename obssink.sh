#!/usr/bin/env sh

pactl load-module module-null-sink sink_name=OBSSink
pacmd update-sink-proplist OBSSink device.description=OBSSink
pactl load-module module-virtual-source source_name=OBSSource master=OBSSink.monitor
pacmd update-source-proplist OBSSource device.description=OBSSource
