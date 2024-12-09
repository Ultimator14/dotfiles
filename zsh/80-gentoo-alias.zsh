#
# Gentoo Alias definitions
#

# equery shortcuts
alias eqf='equery f'
alias equ='equery u'
alias eqh='equery h'
alias eqa='equery a'
alias eqb='equery b'
alias eql='equery l'
alias eqd='equery d'
alias eqg='equery g'
alias eqc='equery c'
alias eqk='equery k'
alias eqm='equery m'
alias eqy='equery y'
alias eqs='equery s'
alias eqw='equery w'

# gemato
alias gematoc='gemato create -p ebuild -s -t -H "BLAKE2B SHA512" .'
alias gematou='gemato update -p ebuild -s -t -H "BLAKE2B SHA512" .'

# cross emerge (arch=arm64, configroot for profile selection, root for eselect news)
alias armprofile='sudo ARCH=arm64 PORTAGE_CONFIGROOT=/usr/aarch64-unknown-linux-gnu eselect profile'
alias armnews='sudo ROOT=/usr/aarch64-unknown-linux-gnu eselect news'
alias armon='sudo eselect profile set default/linux/amd64/17.1/hardened/selinux'
alias armoff='sudo eselect profile set jb-overlay:jb-overlay/linux/amd64/17.1/gnome+hardened+selinux/3.32'
alias armmake='ARCH=arm64 CROSS_COMPILE=aarch64-unknown-linux-gnu- make'
