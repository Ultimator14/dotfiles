# Show fans
fans() {
	watch -n 1 'grep "RPM" <<< $(sensors)'
}

# set fanspeed for pwm5 fan (table fan)
setfan() {
	local fanspeed=$1

	if [[ $fanspeed =~ '^[0-9]+$' ]]; then
		# fan speed is actual fan speed - set fan speed
		if [ $fanspeed -gt 255 ]; then
			fanspeed=255
		fi

		if [ $fanspeed -lt 0 ]; then
			fanspeed=0
		fi

		echo 1 > /sys/class/hwmon/hwmon3/pwm5_enable
		echo $fanspeed > /sys/class/hwmon/hwmon3/pwm5
		echo "Set fan speed to $fanspeed"

	else
		# fan speed is invalid, reset to auto
		echo 5 > /sys/class/hwmon/hwmon3/pwm5_enable
		echo "Reset fanspeed to auto"
	fi
}

# print current fanspeed
getfan() {
	local autocontrolled=$(cat /sys/class/hwmon/hwmon3/pwm5_enable)
	local fanspeed=$(cat /sys/class/hwmon/hwmon3/pwm5)

	if [ $autocontrolled -eq 5 ]; then
		echo "Fan is auto controlled"
	else
		echo "Fan speed is $fanspeed"
	fi
}


# Monitor
splitmon_start_dual() {
	top_monitor=${"$(xrandr --listmonitors | grep "+0+1080" | cut -d " " -f 3)":1}
	left_monitor=${"$(xrandr --listmonitors | grep "+1920+0" | cut -d " " -f 3)":1}
	center_monitor=${"$(xrandr --listmonitors | grep "+1920+1080" | cut -d " " -f 3)":1}
	right_monitor=${"$(xrandr --listmonitors | grep "+3840+1080" | cut -d " " -f 3)":1}

	xrandr --setmonitor ComboScreen 3840/530x1080/300+1920+1080 ${center_monitor},${right_monitor}
}

splitmon_start_triple() {
	top_monitor=${"$(xrandr --listmonitors | grep "+0+1080" | cut -d " " -f 3)":1}
	left_monitor=${"$(xrandr --listmonitors | grep "+1920+0" | cut -d " " -f 3)":1}
	center_monitor=${"$(xrandr --listmonitors | grep "+1920+1080" | cut -d " " -f 3)":1}
	right_monitor=${"$(xrandr --listmonitors | grep "+3840+1080" | cut -d " " -f 3)":1}

	xrandr --setmonitor ComboScreen 5760/530x1080/300+0+1080 ${left_monitor},${center_monitor},${right_monitor}
}

splitmon_stop() {
	xrandr --delmonitor ComboScreen
}


# Decompress camera signal to view full hd image in discord, skype, etc.
convert-webcam-signal() {
	if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
		return 1
	fi

	modprobe v4l2loopback video_nr=9 exclusive_caps=1
	ffmpeg -f v4l2 -input_format mjpeg -framerate 30 -video_size 1920x1080 -i /dev/video0 -pix_fmt yuyv422 -f v4l2 /dev/video9
}

# Camera fun
convert-webcam-signal-rotation() {
	if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
		return 1
	fi

	modprobe v4l2loopback video_nr=9 exclusive_caps=1
	ffmpeg -f v4l2 -input_format mjpeg -framerate 30 -video_size 1920x1080 -i /dev/video0 -pix_fmt yuyv422 -f v4l2 -filter_complex "rotate=a=-3*t:c=black" /dev/video9
}


# Update git repos
git-update() {
	currdir=$(pwd)

	repos=(
		${HOME}/Dokumente/blaeserjugend
		${HOME}/Dokumente/blocklist
		${HOME}/Dokumente/gentoo-overlay
		${HOME}/Dokumente/lab-assistant
		${HOME}/Dokumente/linux
		${HOME}/Dokumente/passwords
		${HOME}/Dokumente/personal
		${HOME}/Dokumente/studies
	)
	for i in "${repos[@]}"; do
		echo "---------------------"
		echo $i | rev | cut -d "/" -f 1 | rev
		echo "---------------------"
		cd "$i"
		git pull --rebase
		git submodule update --recursive
		echo ""
	done

	cd "$currdir"
}
