#
# Default zsh config
#

# History
HISTFILE=${HOME}/.histfile
HISTSIZE=10000
SAVEHIST=100000

# Key bindings
bindkey -v
# Strg+R Reverse search
bindkey '^R' history-incremental-search-backward
# Backspace Remove
bindkey "^?" backward-delete-char
# Entf 
bindkey '^[[3~' delete-char
# Pfeiltasten
bindkey '^[[D' backward-char
bindkey '^[[C' forward-char

bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history

# Disable F1-F12
bindkey -s '\eOP' ''
bindkey -s '\eOQ' ''
bindkey -s '\eOR' ''
bindkey -s '\eOS' ''
bindkey -s '\e[15~' ''
bindkey -s '\e[17~' ''
bindkey -s '\e[18~' ''
bindkey -s '\e[19~' ''
bindkey -s '\e[20~' ''
bindkey -s '\e[21~' ''
bindkey -s '\e[24~' ''

# Options
setopt appendhistory
setopt autocd
#setopt correctall
setopt extendedglob

unsetopt beep
unsetopt nomatch
unsetopt notify

# Completion
# Completers
zstyle ':completion:*' completer _expand _complete _ignored _approximate
# Flags
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
# ignore ../. on completion
zstyle ':completion:*' ignore-parents parent pwd .. directory
# separator list for f-b -> foo-bar (._-) 
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
# may approximation errors
zstyle ':completion:*' max-errors 3 numeric
# highlight on tab
zstyle ':completion:*' menu select
# Set dir colors (previously defined in OMZL theme and appearance but removed at 07.03.2023)
[[ -z "$LS_COLORS" ]] && eval "$(dircolors)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# filename for config wizard
zstyle :compinstall filename "${HOME}/.zshrc"

# Prompt
# autoload -U promptinit
# promptinit
# prompt gentoo
#
# # Custom terminal title
precmd() { print -Pn -- '\e]0;%n@%m: %~\a' }
