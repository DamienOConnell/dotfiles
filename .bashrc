# vim:fdm=marker
# environmental                                             {{{1

# if not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# locale                                                    {{{1
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# bash specifics                                            {{{1
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
# Completion options                                        {{{2
#
# Uncomment to turn on programmable completion enhancements.
# completions added to ~/.bash_completion are sourced last.
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options                                           {{{2

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

TERM=xterm-256color; export TERM

set -o vi
bind '"jj":"\e"'


# functions                                                 {{{1
# settitle function                                         {{{2
settitle ()
{
  echo -ne "\e]2;$@\a\e]1;$@\a";
}

# ssh-agent for ssh kex
eval $(ssh-agent)


# aliases                                                   {{{1

alias cp='cp -i'
alias df='df -h'
alias du='du -h'
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
alias grep='grep --color'                     # show differences in colour
alias l1='ls -1'
alias l='ls -CF'                                  #
alias ldot="ls -ld .*"
alias less='less -r'                              # raw control characters
alias more='less'
alias mv='mv -i'
alias rm='rm -i'

# Some shortcuts for different directory listings

# Damienisms
alias p="ping -c 4"
alias pstree='pstree -Ga'
alias t='telnet'
alias whence='type -a'                        # where, of a sort
alias max='tmuxinator `hostname -s`'

case `uname` in
  Darwin)
    echo "Welcome to OSX"

    alias dir='ls -FG'
    alias egrep='egrep --color=auto'              # show differences in colour
    alias fgrep='fgrep --color=auto'              # show differences in colour
    alias grep='grep --color=auto'                # show differences in colour
    alias la='ls -laG'
    alias ll='ls -lG'
    alias ls='ls -hFG'                            # classify files in colour
    alias pstree='pstree -g 2'
    alias vdir='ls -lFG'

    export PATH=/Users/damien/Library/Python/3.7/bin:$PATH
    export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
    export PATH=/Users/damien/Dropbox/bin/mac:$PATH
    export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
    # my little scripts
    # export PYTHONPATH='/Library/Frameworks/Python.framework/Versions/3.6/bin/python3-config'
    ;;
  Linux)
    echo "Welcome to ... Linux"

    alias dir='ls --color=auto --format=vertical'
    alias egrep='egrep --color=auto'              # show differences in colour
    alias fgrep='fgrep --color=auto'              # show differences in colour
    alias grep='grep --color'                     # show differences in colour
    alias la='ls -la --color=auto'
    alias l='ls -CF'                              # alias ll='ls -l --color=auto'
    alias ls='ls -hF --color=tty'                 # classify files in colour
    alias pstree='pstree -a -u -U'                # unicode, show users, args
    alias vdir='ls --color=auto --format=long'
  ;;
  *)
    # Specific to something else, could be cygwin, etc
    #
    echo "Welcome to something else"
esac

# unix settings                                             {{{1

umask 077

if [[ -o login ]]; then
  neofetch
fi

# export PATH=$PATH:/usr/bin:/sbin

# python {{{1

# if [[ -r "/Users/damien/Dropbox/repositories/python/source_py3_osx_env" ]]; then
#   source /Users/damien/Dropbox/repositories/python/source_py3_osx_env
# fi
export PYTHONSTARTUP="$(python -m jedi repl)"

# modified 1557312439  8-May-2019 08:47:19 PM
