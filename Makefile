
ETC_DIR ?= /etc
MODULES_LOAD_DIR ?= ${ETC_DIR}/modules-load.d
MODPROBE_DIR ?= ${ETC_DIR}/modprobe.d

help:
	ls

obssink:
	./obssink.sh

install:
	install -m 644 obs_video_sink_load.conf ${MODULES_LOAD_DIR}/obsloopback.conf
	install -m 644 obs_video_sink_options.conf ${MODPROBE_DIR}/obsloopback.conf
	systemctl restart systemd-modules-load.service
