# OBS Streaming loopback tools

this repo contains configuration for a v4l2 loopback device and pulseaudio routing for streaming
OBS Video and Application audio to video chat.

## v4l2
To install a v4l2 Dummy Device at /dev/video9 being created at boot, run:
```bash
make install
```
It will be named OBSSource and can be used by OBS to stream its Output to:
[obs-v4l2sink](https://github.com/CatxFish/obs-v4l2sink)

Once OBS is set up, OBSSource can be selected in your video chat application.

## mkobssink
For audio sharing support, some additional modules for pulseaudio have to be loaded:
```bash
make start
```
this creates an `OBSCombineSink` and `OBSMicSource`.
Any application sending audio to OBSCombineSink will play both on your primary Output and Loopback to
`OBSMicSource`.

`OBSMicSource` will also loopback your primary audio input.

To send an application's audio to your video chat,
run `pavucontrol` ->` Playback` and set its output to `OBSCombineSource`.
Also make sure to select `OBSMicSource` at your Chat application's input settings.

The Schema below shows how audio routing is realized:

![Audio Schema](audio_routing.jpg?raw=true "Audio Schema")


re-running `make start` will unload all involved modules and reload them.
`make stop` will unload all involved modules.
