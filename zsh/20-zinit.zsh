#
# Zinit config
#

# Initialize zinit
typeset -A ZINIT

ZINIT_DIR="${HOME}/.local/share/zsh/zinit"
ZINIT[HOME_DIR]="${ZINIT_DIR}"

ZINIT_HOME="${ZINIT_DIR}/bin"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

unset ZINIT_DIR
unset ZINIT_HOME

# Only required if compinit is executed before this file
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit

# oh-my-zsh default lib
zinit snippet OMZL::correction.zsh                       # nocorrect options
zinit snippet OMZL::directories.zsh 	                 # directory shortcuts (d)
zinit snippet OMZL::theme-and-appearance.zsh	         # necessary for colors in ls command

# git alias
zinit snippet OMZP::git                                  # git commands

# oh-my-zsh plugins
zinit snippet OMZP::python                               # python commands
zinit snippet OMZP::colored-man-pages                    # nice man pages
zinit snippet OMZP::alias-finder                         # find alias for command

# zsh-user stuff (load in background)
zinit ice wait lucid nocd \
	atinit"zicompinit; zicdreplay" \
	atload"source /usr/local/dotfiles/zsh/fsh/set-theme.zsh"
zinit light zdharma-continuum/fast-syntax-highlighting   # syntax highlighting in commandline

zinit ice wait lucid nocd atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions                # history suggestions (after FSyH to prevent error on path completion)
