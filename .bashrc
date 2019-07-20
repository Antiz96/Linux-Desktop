#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#Export Color
export Color='--color=auto'

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
#alias rm='rm -i'

#Edit
alias vi='vim'

#Root
alias sudo='sudo '
PS1='[\u@\h \W]\$ '
