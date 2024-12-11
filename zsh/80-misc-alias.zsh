#
# Misc Alias definitions
#

# ls
alias l='ls -lAh'
alias la='ls -la'
alias ll='ls -l'
alias lg='ls -la | grep -i'
alias lr=' ls -lR'
alias lss='ls -lAhZ'

# eza
if [[ ! -z $commands[eza] ]]
then
	alias ls='eza --color-scale=size --group-directories-first -g --git'
	alias l='ls -la --icons=auto'
	alias la='ls -laHS --icons=auto'
	alias ll='ls -l'
	alias lg='ls -laa | grep -i'
	alias lr='ls -lR'
	alias lar='ls -laR'
	alias lz='ls -lZ'
	alias laz='ls -laZ'
	alias lt='eza --tree'
fi

# lolcat
if [[ ! -z $commands[lolcat] ]]
then
	alias lcat='lolcat'
fi

# difftastic
if [[ ! -z $commands[difft] ]]
then
	alias dgs='GIT_EXTERNAL_DIFF=difft git show --ext-diff'
	alias dgd='GIT_EXTERNAL_DIFF=difft git diff'
	alias dgl='GIT_EXTERNAL_DIFF=difft git log -p --ext-diff'
fi


# miscellaneous
alias fml='sudo poweroff'
alias c='clear'
alias clhist='history -c && history -w'
alias chi='ping -c 5 8.8.8.8'
alias e='exit'
alias b='ranger'
alias v='vi'
alias si='du -sh'
alias x="echo $XDG_SESSION_TYPE"
alias sl="ls"
alias restart-gnome-from-terminal='DISPLAY=:0 gnome-shell -r &'
alias rmbr='sudo mount -o remount,ro /boot'
alias rmbw='sudo mount -o remount,rw /boot'
alias ip='ip --color=auto'
alias gshs='git --no-pager show -s'

# Pwn Docker
alias pwn-docker='docker run --tty --interactive --rm -v "$PWD":/workdir -w /workdir ultimator14/pwn-docker'

# ASLR
alias aslr-off='sysctl kernel.randomize_va_space=0'
alias aslr-on='sysctl kernel.randomize_va_space=2'

# share android screen (https://stackoverflow.com/questions/31472962/use-adb-screenrecord-command-to-mirror-android-screen-to-pc-via-usb/)
alias adbscreen='adb exec-out screenrecord --output-format=h264 - | ffplay -framerate 60 -framedrop -bufsize 16M -'

# umount disks
alias pumountd='sudo udisksctl power-off -b'
alias pumountm='sudo udisksctl power-off -p'

# show ssh key as it's shown in github/gitlab
alias ssh-fingerprint-git='ssh-keygen -l -E md5 -f'

# combine all pdfs in directory
alias combinepdfs='qpdf --empty --pages *pdf -- out.pdf'

# Terminator alias for wayland
#alias terminator='GDK_BACKEND=x11 DBUS_SESSION_BUS_ADDRESS='' terminator'

# Gef/Peda
alias gdb-gef="gdb-gef -x ~/.gdbinit-gef"
alias gdb-peda="gdb-peda -x ~/.gdbinit-peda"

# Clear caches
alias clcache='sync && echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a'

# convert arbitrary files to mp3 (good quality)
convtomp3() {
	ffmpeg -i ${@} -vn -ab 320k -ar 44100 ${@}.mp3
}

# show temperature
temp() {
	watch -n 1 'grep "°C" <<< $(sensors)'
}

# download mpd as mp4
downloadmpd() {
	ffmpeg -i manifest.mpd -c copy mpdvideo.mp4
}

set-default-perms-on-dirs() {
	if [ -d "$1" ]; then
		find $1 -type d -print0 | xargs -0 chmod 0755
	else
		echo "Only directories are supported"
	fi
}

set-default-perms-on-files() {
	if [ -d "$1" ]; then
		find $1 -type f -print0 | xargs -0 chmod 0644
	else
		echo "Only directories are supported"
	fi
}

pip_update_everything() {
	pip list --outdated --format=json | jq -r '.[] | .name + "==" + .latest_version' | cut -d = -f 1  | xargs -n1 pip install -U --user
}

color_ls_term() {
	# Display all colors
	for x in {0..8}
	do
		# bold, ...
		for i in {30..37}
		do
			# foregrounds
			for a in {40..47}
			do
				# backgrounds
				echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
			done
			echo
		done
	done
}

color_ls_prompt() {
	for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}
