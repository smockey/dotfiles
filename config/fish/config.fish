set PATH $HOME/.rvm/bin $PATH
# set PATH $PATH /usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
set PATH /usr/local/bin $PATH
set PATH $PATH /usr/local/heroku/bin
set PATH /Library/PostgreSQL/9.2/bin $PATH

set PGHOST localhost

set PAGER /bin/sh\ -c\ \"unset\ PAGER\;col\ -b\ -x\ \|\ vim\ -c\ \'set\ ft=man\ nomod\ nolist\'\ -\"

set GTK_IM_MODULE=xim
set GEDITOR=gvim
set -g -x EDITOR=vim
set TERM="xterm-256color"
stty -ixon

alias python2="python2.7"
alias vi="vim"
alias vimrc="vim ~/.vimrc"
alias zshrc="vim ~/.zshrc"
alias preztorc="vim ~/.zpreztorc"
alias vitodo="vi ~/todo.md"
alias vir="vi -R"

alias ccat="pygmentize -g"
alias tree="tree -C"
alias less="less -r"
alias wee="weechat-curses"
alias a="atool"
alias atx="atool -x"
alias g="git"
alias vip="vim -MR -"

alias shops="cd ~/mercurial/shopmium/shops"
alias server="cd ~/mercurial/shopmium/server"

# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Theme
set fish_theme smockey
set -g theme_display_user yes
set -g default_user thomaslarrieu

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler

# Path to your custom folder (default path is $FISH/custom)
#set fish_custom $HOME/dotfiles/oh-my-fish

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish
