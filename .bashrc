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
alias remove='sudo pacman -R'
alias purge='sudo pacman -Rcns'

#Sudoers
alias sudo='sudo '

##Terminal##

PS1='[\u@\h \W]\$ '
