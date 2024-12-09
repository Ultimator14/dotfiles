# FSyH color scheme
FSH_CURRENT_THEME="${HOME}/.cache/fsh/current_theme.zsh"
FSH_MY_THEME="/usr/local/dotfiles/zsh/fsh/main-theme.ini"

[ ! -f $FSH_CURRENT_THEME ] && fast-theme -q ${FSH_MY_THEME}

unset FSH_CURRENT_THEME
unset FSH_MY_THEME
