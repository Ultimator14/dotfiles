# Prevent Wine from adding menu entries and desktop links.
export WINEDLLOVERRIDES="winemenubuilder.exe=d"

# variables
EIX_LIMIT=0
export EIX_LIMIT
EIX_LIMIT_COMPACT=0
export EIX_LIMIT_COMPACT

# directory shortcuts
export rps=/var/db/repos
export log=/var/log
export ptg=/etc/portage
export pus=/etc/portage/package.use
export pkw=/etc/portage/package.accept_keywords
export lsh=${HOME}/.local/share
export krn=/usr/src/linux

# fix zsh autosuggestion highlighting in tmux session
# tmux sets TERM to screen, where colors don't work
# see https://github.com/zsh-users/zsh-autosuggestions/issues/229
export TERM=xterm-256color

# fix gpg not recognizing current terminal for key passphrase
export GPG_TTY=$(tty)

# set (global) cache dir for mypy to prevent the creation of folders
export MYPY_CACHE_DIR=${HOME}/.cache/mypy
