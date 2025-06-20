case $- in
    *i*) ;;
      *) return;;
esac
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi
if [ "$color_prompt" = yes ]; then
    if [ "$(id -u)" -eq 0 ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[5;31m\]\u\[\e[25m\]@\h\[\033[00m\]:\[\033[01;34m\]\w #\[\033[00m\] '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
    fi
else
    if [ "$(id -u)" -eq 0 ]; then
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w # '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w \$ '
    fi
fi
unset color_prompt force_color_prompt
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
diffy() {
    diff -y -B <(grep -vE '^\s*#' "$1") <(grep -vE '^\s*#' "$2")
}
catta() {
    if [[ -n "$1" ]]; then
        for texts in $(file "$1"* | grep text | awk '{print $1}' | sed 's/.$//'); do
            echo -e "

    \e[4m\e[93m${texts}\e[0m
"
            cat "${texts}"
       done
    else
        for texts in $(file ./* | grep text | awk '{print $1}' | sed 's/.$//'); do
            echo -e "

    \e[4m\e[93m${texts}\e[0m
"
           cat "$texts"
       done
    fi
}
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lah'
alias cd..='cd ..'
alias status="/usr/local/bin/status/init.sh"
alias domain="/usr/local/bin/domain/init.sh"
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [[ -t 1 ]]; then  # Only if interactive shell
    /usr/local/bin/status/init.sh
fi
