I guess I just got tired of re-configuring my linux distros each time I installed a new one from scratch.   
[(copy and paste code below)](https://github.com/Blyzz616/Linux-Config/blob/main/README.md#bash_profile)


# What this code block does:

## create .nanorc

```bash
set constantshow
```

- Always display the cursor position at the bottom of the editor

```bash
set linenumbers
```

- Show line numbers on the left side of the editor

```bash
set numbercolor cyan,black
```

- Set the color of the line numbers to cyan text on a black background

## create .screenrc

```bash
hardstatus on
```

- Turn on the hardstatus line

```bash
hardstatus alwaysfirstline
```

- Place the hardstatus line at the top of the screen

```bash
hardstatus string '%{= wk}Screen: %S %= [%c]'
```

- Customize the hardstatus line format
- %{= wk}    - Set text to white on black background
- Screen: %S - Display "Screen: " followed by the session name (%S)
- %=         - Push everything after this to the far right
- [%c]       - Display current time in HH:MM format, surrounded by square brackets

```bash
defscrollback 10000
```

- Set the scrollback buffer size to 10000 lines

```bash
defutf8 on
```

- Enable UTF-8 support

```bash
startup_message off
```

- Disable the startup message when screen starts

## create .bashrc

### Interactive Shell Check

```bash
case $- in  
    *i*) ;;  
      *) return;;  
esac
```

- case $- in ... esac: This checks the current shell options.
- *i*) ;;: If the shell is interactive (i is present in $-), do nothing (;;).
- *) return;;: If the shell is not interactive, exit the script (return).

### History Control

```bash
HISTCONTROL=ignoreboth
```

- HISTCONTROL=ignoreboth: Sets the shell history to ignore duplicate entries and commands that start with a space.

### Append to History

```bash
shopt -s histappend
```

- shopt -s histappend: Enables appending to the history file, rather than overwriting it.

### History Size

```bash
HISTSIZE=1000  
HISTFILESIZE=2000
```

- HISTSIZE=1000: Sets the number of commands to remember in the command history.
- HISTFILESIZE=2000: Sets the maximum number of lines contained in the history file.

### Check Window Size

```bash
shopt -s checkwinsize
```

- shopt -s checkwinsize: After each command, checks the window size and updates LINES and COLUMNS if necessary.

### Debian Chroot

```bash
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then  
    debian_chroot=$(cat /etc/debian_chroot)  
fi
```

- Checks if the debian_chroot variable is unset or empty and if /etc/debian_chroot is readable.
- If both conditions are met, it sets debian_chroot to the contents of /etc/debian_chroot.

### Terminal Color Check

```bash
case "$TERM" in  
    xterm-color|*-256color) color_prompt=yes;;  
esac
```

- Checks if the terminal supports color (xterm-color or *-256color).
- If so, sets color_prompt=yes.

### Color Prompt Setup

```bash
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then  
    color_prompt=yes  
else  
    color_prompt=  
fi  
```

- Checks directly whether tput exists and can set terminal colors.
- If so, sets color_prompt=yes, otherwise sets it empty.
- (Dropped the old force_color_prompt variable — it was just an unconditional yes immediately followed by this same check, so it wasn't doing anything useful.)

### PS1 Prompt Definition

```bash
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
```

- Sets the prompt (PS1) based on whether color_prompt is set.
- If the user is root (id -u equals 0), the prompt ends with #, otherwise with $.
- The colors are different for root (red) and non-root users (green).
- Sets the prompt (PS1) based on whether color_prompt is set.
- If the user is root (id -u equals 0), the prompt ends with #, otherwise with $.
- The colors are different for root (red) and non-root users (green).

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

### Define catta Function

```
catta() {  
    local target="${1:-./*}"  
    while IFS= read -r texts; do  
        echo -e "\n\n    \e[4m\e[93m${texts}\e[0m\n"  
        cat "${texts}"  
    done < <(file -- ${target}* 2>/dev/null | grep text | sed 's/:.*//')  
}
```

- Defines the catta function to display contents of text files.
- If a file pattern is provided, it processes files matching the pattern; otherwise it processes everything in the current directory.
- Each file's name is highlighted and separated for readability.
- Rewritten to use a `while read` loop to prevent globbing

### Define Aliases

> alias ll='ls -l'  
> alias la='ls -la'  
> alias lh='ls -lah'  
> alias cd..='cd ..'  
> alias update='apt update -y && apt upgrade -y && apt full-upgrade -y'

- Sets up aliases for common ls commands and a cd shortcut for a common typo I make.
- `update` runs everything apt needs in one go. (Dropped the separate `dist-upgrade` call — on modern apt it's just an alias for `full-upgrade`, so running both back to back was redundant. Also renamed from `go` to `update` since it's clearer at a glance what it does.)

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

## Outside of .bashrc

### Static IP Assignment (currently disabled)

- This whole block is commented out for now — I'm relying on DHCP reservations at the router instead of setting static IPs on the host itself.
- Left the functions in place (commented) in case I want to switch back to static addressing later: `GETINTERFACE` detects DHCP interfaces in `/etc/network/interfaces` (and asks you to pick if there's more than one), `GETIP`/`GETMASK`/`GETGATE` prompt for and validate IPv4 addresses, and `SETSTATIC` backs up `/etc/network/interfaces` before rewriting the relevant interface to static.

### Show MAC Address(es) for DHCP Reservation

> echo -e "\n  MAC address(es) for DHCP reservation:\n"  
> ip -o link show | awk -F': ' '{print $2}' | while read -r iface; do  
>   [[ "$iface" == "lo" ]] && continue  
>   mac=$(cat "/sys/class/net/$iface/address" 2>/dev/null)  
>   [[ -n "$mac" ]] && echo "    $iface: $mac"  
> done

- Lists every network interface (skipping loopback) and prints its MAC address straight from `/sys/class/net/*/address`.
- Since I'm doing reservations instead of static config now, this gives me what I actually need to copy into the router/DHCP server.

### Add Curl and Sudo

Checks if we can resolve names; if not, adds Cloudflare and Quad9 nameservers (backing up the original file first). If we're root, installs curl and sudo.

```
if ! getent hosts www.google.com &>/dev/null; then  
  if [[ $(grep -vcE '^$|^#' /etc/resolv.conf) -eq 0 ]]; then  
    cp /etc/resolv.conf /etc/resolv.conf.bak.$(date +%s) 2>/dev/null  
    echo -e "\nnameserver 1.1.1.2\nnameserver 9.9.9.9" >> /etc/resolv.conf  
    sleep 3  
    if ! getent hosts www.google.com &>/dev/null; then  
      echo -e "    ALERT!\nAdded Cloudflare and Quad9 nameservers, but still not resolving domain names!"  
    else  
      [[ $(id -u) -eq "0" ]] && apt update -y && apt upgrade -y && apt install -y curl sudo  
    fi  
  fi  
fi
```

- Switched the reachability check from `ping` to `getent hosts`, since it tests actual DNS resolution rather than ICMP reachability (some networks block ping but resolve fine, which was giving false alarms before).
- Also fixed the regex that checks whether `/etc/resolv.conf` is effectively empty — it was `'^$^#'` (broken) and is now `'^$|^#'` (blank lines or comments).
- Now backs up `/etc/resolv.conf` with a timestamp before appending nameservers, just in case.

## .bash_profile

[Link](https://github.com/Blyzz616/.bash_profile)

### COPY PASTA

```
cat <<"EOF" > ~/.bashrc
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
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
else
    color_prompt=
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
    local target="${1:-./*}"
    while IFS= read -r texts; do
        echo -e "\n\n    \e[4m\e[93m${texts}\e[0m\n"
        cat "${texts}"
    done < <(file -- ${target}* 2>/dev/null | grep text | sed 's/:.*//')
}
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lah'
alias cd..='cd ..'
alias update='apt update -y && apt upgrade -y && apt full-upgrade -y'
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
EOF

cat <<"EOF" > ~/.nanorc
set constantshow
set linenumbers
set numbercolor cyan,black
EOF

# --- Static IP assignment (disabled — using DHCP reservations instead) ---
#
# INTERFACE=""
# IPADD=""
# IPMASK=""
# IPGATE=""
#
# OCTET='(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])'
# IPV4_RE="^${OCTET}\.${OCTET}\.${OCTET}\.${OCTET}\$"
#
# GETINTERFACE() {
#   mapfile -t IFACES < <(grep -E '^iface.*inet dhcp$' /etc/network/interfaces | awk '{print $2}')
#   if [[ ${#IFACES[@]} -eq 0 ]]; then
#     echo "No DHCP interfaces found in /etc/network/interfaces. Skipping static IP setup."
#     return 1
#   elif [[ ${#IFACES[@]} -gt 1 ]]; then
#     echo "Multiple DHCP interfaces found: ${IFACES[*]}"
#     read -rp "  Which interface do you want to make static? " INTERFACE
#     if [[ ! " ${IFACES[*]} " =~ " ${INTERFACE} " ]]; then
#       echo "Invalid selection."
#       return 1
#     fi
#   else
#     INTERFACE="${IFACES[0]}"
#   fi
#   return 0
# }
#
# GETMASK() {
#   read -rp "
#   What should the netmask be (IP address, not CIDR)?
# " IPMASK
#   if [[ ! $IPMASK =~ $IPV4_RE ]]; then
#     echo "Please use a valid x.x.x.x netmask."
#     GETMASK
#   fi
# }
#
# GETGATE() {
#   read -rp "
#   What should the Gateway be?
# " IPGATE
#   if [[ ! $IPGATE =~ $IPV4_RE ]]; then
#     echo "Please use a valid x.x.x.x gateway address."
#     GETGATE
#   fi
# }
#
# GETIP() {
#   echo -e "  Current IP is: $(ip a | grep inet | grep -vE 'host lo|inet6' | awk '{print $2}')"
#   read -rp "
#   What should the IP be for this host?
# " IPADD
#   if [[ ! $IPADD =~ $IPV4_RE ]]; then
#     echo "Please give a valid IPv4 address (no netmask)."
#     GETIP
#   fi
# }
#
# SETSTATIC() {
#   cp /etc/network/interfaces /etc/network/interfaces.bak.$(date +%s)
#   sed -i "s/iface $INTERFACE inet dhcp/iface $INTERFACE inet static/" /etc/network/interfaces
#   echo -e "    address $IPADD\n    netmask $IPMASK\n    gateway $IPGATE" >> /etc/network/interfaces
# }
#
# if [[ $(id -u) -eq 0 ]]; then
#   if grep -q dhcp /etc/network/interfaces; then
#     if GETINTERFACE; then
#       GETIP
#       GETMASK
#       GETGATE
#       SETSTATIC
#     fi
#   fi
# fi

# --- Show MAC address(es) for DHCP reservation ---
echo -e "\n  MAC address(es) for DHCP reservation:\n"
ip -o link show | awk -F': ' '{print $2}' | while read -r iface; do
  [[ "$iface" == "lo" ]] && continue
  mac=$(cat "/sys/class/net/$iface/address" 2>/dev/null)
  [[ -n "$mac" ]] && echo "    $iface: $mac"
done
echo ""

if ! getent hosts www.google.com &>/dev/null; then
  if [[ $(grep -vcE '^$|^#' /etc/resolv.conf) -eq 0 ]]; then
    cp /etc/resolv.conf /etc/resolv.conf.bak.$(date +%s) 2>/dev/null
    echo -e "\nnameserver 1.1.1.2\nnameserver 9.9.9.9" >> /etc/resolv.conf
    sleep 3
    if ! getent hosts www.google.com &>/dev/null; then
      echo -e "    ALERT!
Added Cloudflare and Quad9 nameservers, but still not resolving domain names!"
    else
      [[ $(id -u) -eq 0 ]] && apt update -y && apt upgrade -y && apt install -y curl sudo
    fi
  fi
fi

source ~/.bashrc
```
