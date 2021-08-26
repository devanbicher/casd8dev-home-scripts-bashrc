# Include Drush prompt customizations.
. /home/dlb213/.drush/drush.prompt.sh

# Include Drush completion.
. /home/dlb213/.drush/drush.complete.sh

# Include Drush bash customizations.
. /home/dlb213/.drush/drush.bashrc

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


## my early stuff organize later

alias ll='ls -l'
alias ebash='emacs ~/.bashrc && source ~/.bashrc'
alias rmemacsbu='rm ./*.*~'
alias sourcebash='source ~/.bashrc'
alias python='python3'
alias curdir='pwd | rev | cut -d '/' -f1 | rev'
alias now="date +'%H%M-%m%d%y'"

# general stuff (not drupal specific)
cbash () {
    code ~/.bashrc;
    while true; do
    read -p "Source your bash? [y/n]
" yn
    case $yn in
        [Yy]* ) source ~/.bashrc; echo 'Successfully Sourced your bashrc'; break;;
        [Nn]* ) echo "Okay, bashrc not sourced."; break;;
        * ) echo "Please answer yes or no.";;
    esac 
    done
    echo 'goodbye'
}

#playing nicely with eachother
setgroup () {
    chmod -R g+wrs $*
    chgrp -R drupaladm $*
}

#drupal specific stuff
alias drush-old='drush -l $(pwd | rev | cut -d "/" -f1 | rev)'
#alias bam-backup='drush -l $(pwd | rev | cut -d "/" -f1 | rev) ev "backup_migrate_cron()"'

export drupal8='/var/www/drupal8/web/sites/'
export drupal9='/var/www/drupal9/web/sites/'
export casdev='/var/www/casdev/web/sites/'
export emulsify='/var/www/emulsify/web/sites/'
export test_profile='/var/www/casdev/web/profiles/test_profile/'
export test_profile_config='/var/www/casdev/web/profiles/test_profile/config/install/'
export cas_dept='/var/www/casdev/web/profiles/cas_department/'
export cas_dept_config='/var/www/casdev/web/profiles/cas_department/config/install/'

profile_test_install () {
drush @casdev."$1" site-install test_profile --account-name="$1"_cas_admin --account-mail=incasweb@lehigh.edu --site-mail=incasweb@lehigh.edu --account-pass=$(pwgen 16) --site-name="CASDEV $1 Site (casd8devserver)"
}

alias cas_department_install="sh /var/www/casdev/web/scripts/bash-scripts/cas_department_install.sh"

#drupal config tools
cleanmvconfig (){
    for config in "$@"
    do
	echo "Copying $config ... "
	pcregrep -vM '_core:(.*\n)[[:space:]]+default_config_hash:' $config | grep -v "uuid" > /var/www/casdev/web/profiles/cas_department/config/install/"$config"
    done
}

cleanmvconfigdev (){
    for config in "$@"
    do
	echo "Copying $config ... "
	pcregrep -vM '_core:(.*\n)[[:space:]]+default_config_hash:' $config | grep -v "uuid" > /var/www/casdev/web/sites/newprofileinstall/profiles/cas_department/config/install/"$config"
    done
}

diff2profile () {
    diff $1 /var/www/casdev/web/profiles/cas_department/config/install/"$1"
}

diff2base () {
    diff $1 /var/www/casdev/web/sites/cas_department_base/files/config/"$1"
}

drushl () {
    docroot=$(pwd | cut -d'/' -f4)

    if [ "$docroot" = "casdev" ]; then
        sitesdir=$(pwd | cut -d'/' -f6)

        if [ "$sitesdir" = "sites" ]; then
            site=$(pwd | cut -d'/' -f7)    
            if [ "$site" != "" ]; then
                drush -l $site $*
            fi
        else
            echo "You aren't in the sites dir, you can just use drush, not this alias"
        fi
    else
        echo "You aren't in casdev docroot (/var/www/casdev/), you should use drush aliases or drush -l to specify a site in this docroot"
    fi
}

alias drushall="sh /var/www/casdev/web/scripts/bash-scripts/drushall.sh"
alias all_sites_backup="sh /var/www/casdev/web/scripts/bash-scripts/backupallsites.sh"

site_backup () {
    site=$(pwd | cut -d'/' -f7)
    drushl sql:dump --result-file=files/"$site"/private/backup_migrate/"$site"-sh-$(date +'%H%M-%m%d%y').sql --gzip --structure-tables-list=cache_bootstrap,cache_config,cache_container,cache_data,cache_default,cache_discovery,cache_entity,cache_menu,cache_page,cache_toolbar,sessions
}

export compare2sites="/var/www/casdev/web/scripts/bash-scripts/compare2sites.sh"

alias comparebase="sh /var/www/casdev/web/scripts/bash-scripts/compare2sites.sh cas_department_base "