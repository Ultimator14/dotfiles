#
# Fixup aliases for plugins
#

# Git commands giving wrong syntax highlighting
# due to usage of options not mentioned in man page

# was git commit --all --message
alias gcam='git commit --all -m'

# was git commit --all --signoff --message
alias gcasm='git commit --all --signoff -m'

# was git commit --signoff --message
alias gcsm='git commit --signoff -m'

# was git commit --gpg-sign --signoff --message
alias gcssm='git commit --gpg-sign --signoff -m'

# was git commit --message
alias gcmsg="git commit -m"


# Python security related changes to prevent unexpected
# execution of files in the current directory (added -P)

alias ipython='python3 -Pc "import IPython, sys; sys.exit(IPython.start_ipython())"'
alias pyserver="python3 -Pm http.server"
