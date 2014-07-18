# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# include home bin
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH" 
fi

 #include google chrome depot tools
#if [ -d "/data/sources/depot_tools" ]; then
    #PATH="/data/sources/depot_tools:$PATH" 
#fi

export EDITOR=vim
export BROWSER=chromium

# for faster navigation
alias u='cd ..'
alias uu='u && u'
alias s='sudo'
alias e='exit'
alias v='vim'
alias c='cd'

# color enabled
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias pacman='pacman --color=auto'
alias dmesg='dmesg --color=auto'
alias tree='tree -C'
alias less='less -R'

# color for man!
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

# installs man for all gems
gen_missing_ridocs(){
    gem rdoc --all --ri --no-rdoc
}

# open gvim files in same instance
alias gvim='gvim --remote-silent'

# serve current working directory
alias servethis='ruby -run -e httpd . -p 9090'

# preset options for tools
alias nm='nm --demangle'

# spawn new shell in current directory
# ds = duplicate shell
alias ds='urxvt -cd $(pwd) &'

# misc
alias murder='kill -9'
alias pms='pacman -Ss'
alias pmi='s pacman -S'
alias tl='tree | less'
alias hman='man --html'

# searching orphaned packages
alias lsorhpans='pacman -Qdt'

# mounting & unmouting media
alias udmnt='udevil mount'
alias udumnt='udevil umount'
alias udclr='udevil clean'

# shortcuts for svn
alias svna='svn add'
alias svnu='svn up'
alias svnc='svn commit'
alias svnch='svn checkout'
alias svns='svn status'
alias svnr='svn revert'

# only manage aurpackages with packer
alias packer='packer --auronly'

# list pidgin smileys
alias smpidgin='cat .purple/smileys/AdvSmileys/theme'

# appearence of input line
#PS1='\u \W \$ '
PS1='\[\033[0;32m\]\W\[\033[0m\] \$ '

# load hostname specific option file
if [ -f ~/.config/host_specific/$HOSTNAME ]; then
    source ~/.config/host_specific/$HOSTNAME
fi

# postgres if exists
if [ -d "/usr/local/pgsql" ]; then
    PATH="/usr/local/pgsql/bin:$PATH"
    MANPATH="/usr/local/pgsql/man:$MANPATH"
fi

# add ruby gems to path
RB_GEMS=$(ruby -rubygems -e "puts Gem.user_dir")
PATH="$RB_GEMS/bin:$PATH" 

source ~/.profile
