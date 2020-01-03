#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

##Exports##

#Export Color
export Color='--color=auto'

##Aliases##

#Listing Files
alias ls='ls $Color'
alias ll='ls $Color -ltr'
alias l='ls $Color -ltrA'

#Grep
alias grep='grep $Color'
alias egrep='egrep $Color'
alias fgrep='fgrep $Color'

#Manipulating Files
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias rm='rm -i'

#Edit
alias vi='vim'

#Pacman
alias update='sudo pacman -Syy'
alias upgrade='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='sudo pacman -Ss'
alias package='sudo pacman -Qe'
alias cleancache='sudo pacman -Sc'
alias cleanorphans='sudo pacman -Rns $(pacman -Qtdq)'

#Sudoers
alias sudo='sudo '

#Others
alias pman="man -k . | dmenu -l 30 | awk '{print \$1}' | xargs -r man -Tpdf | zathura --mode=fullscreen -"

#ENV
export EDITOR=/usr/bin/vim

##Prompt##

PS1='[\u@\h \W]\$ '
