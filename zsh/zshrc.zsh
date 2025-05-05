# This directory
ZSH_HOME="/usr/local/dotfiles/zsh"

# Default config
source ${ZSH_HOME}/00-zsh-config.zsh

# Package manager and command highlighting
source ${ZSH_HOME}/20-zinit.zsh

# Themes
source ${ZSH_HOME}/30-theme.zsh

# Alias definitions
source ${ZSH_HOME}/80-gentoo-alias.zsh
source ${ZSH_HOME}/80-misc-alias.zsh
source ${ZSH_HOME}/80-fixup-alias.zsh
source ${ZSH_HOME}/85-desktop-alias.zsh
source ${ZSH_HOME}/85-docker-shell-alias.zsh

# Variables export
source ${ZSH_HOME}/90-variables.zsh
