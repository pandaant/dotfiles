# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# include home bin
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH" 
fi

export EDITOR=vim
export BROWSER=chromium

alias ssh-cserver='ssh -p 22333 batman@127.0.0.1'

# for faster navigation
alias u='cd ..'
alias uu='u && u'
alias s='sudo'
alias e='exit'
alias v='vim'
alias c='cd'
alias cdext='cd /media/Data'

# color enabled
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias pacman='pacman --color=auto'
alias dmesg='dmesg --color=auto'
alias tree='tree -C'
alias less='less -R'

# make mv ask before overwriting a file by default
alias mv="mv -i"

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

# run and pipe to /dev/null
sc(){
    $@ &
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

# spawn new shell and execute cmd
dse() {
    urxvt -cd $(pwd) -e $@ &
}

# misc
alias du='du -h'
alias murder='kill -9'
alias pms='pacman -Ss'
alias pmi='s pacman --noconfirm -S'
alias tl='tree | less'
alias hman='man --html'
alias runjar='java -jar'

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

if [ -d "/data/sources/midifile/bin" ]; then
    PATH="/data/sources/midifile/bin:$PATH"
fi

if [ -d "/usr/local/freedom" ]; then
    PATH="/usr/local/freedom/bin:$PATH" 
fi

# add ruby gems to path
RB_GEMS=$(ruby -rubygems -e "puts Gem.user_dir")
PATH="$RB_GEMS/bin:$PATH" 

imgur() {
    for i in "$@"; do
    curl -# -F "image"=@"$i" -F "key"="4907fcd89e761c6b07eeb8292d5a9b2a" imgur.com/api/upload.xml|\
            grep -Eo '<[a-z_]+>http[^<]+'|sed 's/^<.\|_./\U&/g;s/_/ /;s/<\(.*\)>/\x1B[0;34m\1:\x1B[0m /'
    done
}

#pdfgrep(){
    #echo find . -name '*.pdf' -exec sh -c 'pdftotext "{}" - | grep --with-filename --label="{}" --color "\$1"' \;
#}

# load hostname specific option file
if [ -f ~/.profile ]; then
    source ~/.profile
fi

LUA_PATH="/usr/share/lua/5.3/?.lua;/usr/share/lua/5.3/?/init.lua"
LUA_CPATH="/lib/lua/5.3/?.so"

activate_torch(){
. /home/batman/torch/install/bin/torch-activate
}
