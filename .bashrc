# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return
set -o vi

TERM=xterm-color; export TERM
# Don't wait for job termination notification
set -o notify
# Use case-insensitive filename globbing
shopt -s nocaseglob
# Make bash append rather than overwrite the history on disk
shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell
#
# Completion options
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
export PROMPT_COMMAND="history -a"

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions:
#
# a) function settitle
settitle ()
{
  echo -ne "\e]2;$@\a\e]1;$@\a";
}

umask 077

# ssh-agent for ssh kex
eval $(ssh-agent)

# vim stuff
#
alias evimrc='mvim ~/Dropbox/conf/vim/.vimrc'
# needed for OSX:
alias vim='nvim'
alias vi='nvim'


# Aliases
alias cp='cp -i'
alias df='df -h'
alias df='df -h'
alias du='du -h'
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
alias grep='grep --color'                     # show differences in colour
alias less='less -r'                          # raw control characters
alias more='less'
alias mv='mv -i'
alias rm='rm -i'

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias l1='ls -l'
alias l='ls -CF'                              #
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias vdir='ls --color=auto --format=long'

# Damienisms 
alias 'fenchurch'='ssh -l root fenchurch'
alias p="ping -c 4"
alias pstree='pstree -Ga'
alias t='telnet'
alias whence='type -a'                        # where, of a sort

#
# OSX - GNU Command Line Tools
# Commands are prefixed with  'g'.  
# To use with normal names, add "gnubin" directory to PATH
# 
PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
#
# Access their man pages with normal names by adding "gnuman" to MANPATH
#
MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH

export PATH=$PATH:/Users/damien/Dropbox/bin/mac
# export PYTHONPATH='/Library/Frameworks/Python.framework/Versions/3.6/bin/python3-config'

export PATH=$PATH:/sbin/
