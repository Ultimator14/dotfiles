#!/bin/bash

declare -A dot_dirs
dot_dirs["${HOME}/.config/htop"]="/usr/local/dotfiles/htop"
dot_dirs["${HOME}/.config/nvim"]="/usr/local/dotfiles/nvim"
dot_dirs["${HOME}/.config/ranger"]="/usr/local/dotfiles/ranger"
dlen=${#dot_dirs[@]}

declare -A dot_files
dot_files["${HOME}/.bashrc"]="/usr/local/dotfiles/bash/bashrc"
dot_files["${HOME}/.zshrc"]="/usr/local/dotfiles/zsh/zshrc.zsh"
dot_files["${HOME}/.tmux.conf"]="/usr/local/dotfiles/tmux/tmux.conf"
dot_files["${HOME}/.ghci"]="/usr/local/dotfiles/ghci/ghci.conf"
dot_files["${HOME}/.rizinrc"]="/usr/local/dotfiles/rizin/rizinrc"
flen=${#dot_files[@]}

function print_info {
	echo -ne "\033[32;1m"
	echo -n $1
	echo -e "\033[0m"
}
function print_warn {
	echo -ne "\033[33;1m"
	echo -n $1
	echo -e "\033[0m"
}
function print_error {
	echo -ne "\033[31;1m"
	echo -n $1
	echo -e "\033[0m"
}
function ask_yes_no {
	while true; do
		read -p "(y/n) "
		case $REPLY in
			[Yy]* ) return 0;;
			[Nn]* ) return 1;;
			* ) echo -n "Please answer yes or no. ";;
		esac
	done
}

print_info "Linking dirs..."
for key in "${!dot_dirs[@]}"
do
	# Check for symlink
	if [[ -L $key ]]
	then
		print_info "Symlink ${key} exists. Skipping..."
		continue
	fi

	# Check for dir
	if [[ -d $key ]]
	then
		echo -n "Directory ${key} exists. Replace? "
		ask_yes_no
		if [[ $? -eq 0 ]]
		then
			# replace
			print_info "Removing ${key}..."
			rm -ri $key
		else
			# skip
			print_info "Skipping ${key}..."
			continue
		fi
	fi
	echo "Linking ${key} to ${dot_dirs[$key]}"
	ln -s ${dot_dirs[$key]} $key
done

print_info "Linking files..."
for key in "${!dot_files[@]}"
do
	# Check for symlink
	if [[ -L $key ]]
	then
		print_info "Symlink ${key} exists. Skipping..."
		continue
	fi

	# Check for dir
	if [[ -f $key ]]
	then
		echo -n "File ${key} exists. Replace? "
		ask_yes_no
		if [[ $? -eq 0 ]]
		then
			# replace
			print_info "Removing ${key}..."
			rm -i $key
		else
			# skip
			print_info "Skipping ${key}..."
			continue
		fi
	fi
	echo "Linking ${key} to ${dot_files[$key]}"
	ln -s ${dot_files[$key]} $key
done
