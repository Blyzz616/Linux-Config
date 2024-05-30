I guess I just got tired of re-configuring my linux distros each time I installed a new one from scratch. 
(copy and paste code below)

## .nanorc

> set constantshow

- Always display the cursor position at the bottom of the editor

> set linenumbers

- Show line numbers on the left side of the editor

> set numbercolor cyan,black

- Set the color of the line numbers to cyan text on a black background

## .screenrc

> hardstatus on

- Turn on the hardstatus line

> hardstatus alwaysfirstline

- Place the hardstatus line at the top of the screen

> hardstatus string '%{= wk}Screen: %S %= [%c]'

- Customize the hardstatus line format
- %{= wk}    - Set text to white on black background
- Screen: %S - Display "Screen: " followed by the session name (%S)
- %=         - Push everything after this to the far right
- [%c]       - Display current time in HH:MM format, surrounded by square brackets

> defscrollback 10000
- Set the scrollback buffer size to 10000 lines

> defutf8 on

- Enable UTF-8 support

> startup_message off

- Disable the startup message when screen starts

## .bashrc

### Interactive Shell Check

> case $- in  
>     *i*) ;;  
>       *) return;;  
> esac

- case $- in ... esac: This checks the current shell options.
- *i*) ;;: If the shell is interactive (i is present in $-), do nothing (;;).
- *) return;;: If the shell is not interactive, exit the script (return).

### History Control

> HISTCONTROL=ignoreboth

- HISTCONTROL=ignoreboth: Sets the shell history to ignore duplicate entries and commands that start with a space.

### Append to History

> shopt -s histappend

- shopt -s histappend: Enables appending to the history file, rather than overwriting it.

### History Size

> HISTSIZE=1000  
> HISTFILESIZE=2000

- HISTSIZE=1000: Sets the number of commands to remember in the command history.
- HISTFILESIZE=2000: Sets the maximum number of lines contained in the history file.

### Check Window Size

> shopt -s checkwinsize

- shopt -s checkwinsize: After each command, checks the window size and updates LINES and COLUMNS if necessary.

### Debian Chroot

> if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then  
>     debian_chroot=$(cat /etc/debian_chroot)  
> fi

- Checks if the debian_chroot variable is unset or empty and if /etc/debian_chroot is readable.
- If both conditions are met, it sets debian_chroot to the contents of /etc/debian_chroot.

### Terminal Color Check

> case "$TERM" in  
>     xterm-color|*-256color) color_prompt=yes;;  
> esac

- Checks if the terminal supports color (xterm-color or *-256color).
- If so, sets color_prompt=yes.

### Force Color Prompt

> force_color_prompt=yes

- Forces the color prompt to be enabled.

### Color Prompt Setup

> if [ -n "$force_color_prompt" ]; then  
>     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then  
>         color_prompt=yes  
>     else  
>         color_prompt=  
>     fi  
> fi

- Checks if force_color_prompt is set.
- If tput exists and can set terminal colors, it sets color_prompt=yes.
- Otherwise, it sets color_prompt to empty.

### PS1 Prompt Definition

> if [ "$color_prompt" = yes ]; then  
>     if [ "$(id -u)" -eq 0 ]; then  
>         PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w #\[\033[00m\] '  
>     else  
>         PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \\$\[\033[00m\] '  
>     fi  
> else  
>     if [ "$(id -u)" -eq 0 ]; then  
>         PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w # '  
>     else  
>         PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w \$ '  
>     fi  
> fi  
> unset color_prompt force_color_prompt  

- Sets the prompt (PS1) based on whether color_prompt is set.
- If the user is root (id -u equals 0), the prompt ends with #, otherwise with $.
- The colors are different for root (\033[01;31m for red) and non-root users (\033[01;32m for green).

### Xterm Title

> case "$TERM" in  
> xterm*|rxvt*)  
>     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"  
>     ;;  
> *)  
>     ;;  
> esac  

- If the terminal is xterm or rxvt, sets the terminal title to user@host: dir.

### Enable Color Support for ls and Define Aliases

> if [ -x /usr/bin/dircolors ]; then 
>     test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)" 
>     alias ls='ls --color=auto' 
>     alias grep='grep --color=auto' 
>     alias fgrep='fgrep --color=auto' 
>     alias egrep='egrep --color=auto' 
> fi 

- Checks if dircolors exists and is executable.
- If ~/.dircolors is readable, evaluates it for setting up color definitions.
- Sets up color aliases for ls, grep, fgrep, and egrep.

### Define diffy Function

> diffy() {  
>     diff -y -B <(grep -vE '^\s*#' "$1") <(grep -vE '^\s*#' "$2")  
> }  

- Defines the diffy function to compare two files, ignoring lines that start with a comment (#) or are empty.

### Define Aliases

> alias ll='ls -l'  
> alias la='ls -la'  
> alias lh='ls -lah'  
> alias cd..='cd ..'  

- Sets up aliases for common ls commands and a cd shortcut.

### Load Additional Aliases

> if [ -f ~/.bash_aliases ]; then  
>     . ~/.bash_aliases  
> fi  

- If ~/.bash_aliases exists, sources it to load additional aliases.

### Enable Programmable Completion

> if ! shopt -oq posix; then  
>   if [ -f /usr/share/bash-completion/bash_completion ]; then  
>     . /usr/share/bash-completion/bash_completion  
>   elif [ -f /etc/bash_completion ]; then  
>     . /etc/bash_completion  
>   fi  
> fi  

- If the shell is not in POSIX mode, checks for bash_completion files and sources them to enable programmable completion features.

## .bash_profile

[Link](https://github.com/Blyzz616/.bash_profile)

### COPY PASTA

```
echo -e"case $- in
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
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w #\[\033[00m\] '
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
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lah'
alias cd..='cd ..'
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi" > ~/.bashrc
echo -e"set constantshow
set linenumbers
set numbercolor cyan,black" > ~/.nanorc
[[ $(dpkg-query -l | grep screen | awk '{print $1}') -ne "ii" ]] && sudo apt install -y screen
echo -e"hardstatus on
hardstatus alwaysfirstline
hardstatus string '%{= wk}Screen: %S %= [%c]'
defscrollback 10000
defutf8 on
startup_message off" > ~/.screenrc
```
