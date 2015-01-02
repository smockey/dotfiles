set PGHOST localhost
set -g -x GEDITOR gvim
set -g -x EDITOR vim
set -g -x TERM xterm-256color
stty -ixon

alias python2="python2.7"
alias v="vim"
alias vi="vim"
alias vimrc="vi ~/.vimrc"
alias vir="vi -R"
alias vip="vi -c AnsiEsc -c 'syn on' -c 'set nomod' -"
alias r="ranger"

alias e="exercism"

alias ccat="pygmentize -g"
alias tree="tree -C"
alias less="less -r"
alias wee="weechat-curses"
alias a="atool"
alias atx="atool -x"
alias g="git"

alias y="yaourt"
alias ys="yaourt -S"
alias yss="yaourt -Ss"
alias ysuy="yaourt -Suy"
alias yr="yaourt -R"

alias rc="rails console"
alias rs="rails server"
alias rrs="rescue rails server"
alias rud="rvm use default"
alias rus="rvm use system"
alias be="bundle exec"
alias bi="bundle install"
alias bu="bundle update"
alias bspec="bundle exec rspec"
alias bguard="bundle exec guard"

alias zc="zeus console"
alias zg="zeus generate"
alias zs="zeus server"
alias zst="zeus start"

alias gcd="cd (git rev-parse --show-toplevel)"
alias ga="git add"
alias gb="git branch"
alias gbs="git branches"
alias gd="git difftool"
alias gcl="git clone"
alias gci="git commit"
alias gcia="git commit --amend"
alias gco="git checkout"
alias gf="git fetch"
alias gl="git log"
alias glg="git lg"
alias glgs="git lgs"
alias gpl="git pull"
alias gps="git push"
alias gs="git status"
alias gspr="git diff --name-status master..HEAD"
alias gdpr="git difftool master..HEAD"

alias hcd="cd (hg root)"
alias hb="hg branch"
alias hbs="hg branches"
alias hci="hg commit"
alias hcia="hg commit --amend"
alias hcl="hg clone"
alias hd="hg diff"
alias hdpr="hg diff -r \"ancestor(default,.)\""
alias hspr="hg status --rev \"::. - ::default\""
function hdprc
  hg diff -r "ancestor($argv,.)"
end
function hsprc
  hg status --rev "::. - ::$argv"
end
alias hlb="hg log --graph -b"
alias hm="hg merge"
alias hpl="hg pull"
alias hplb="hg pull -b ."
alias hps="hg push"
alias hr="hg revert -C"
alias hrlu="hg resolve -l | grep U"
alias hrm="hg resolve -m"
alias hs="hg status (hg root)"
alias hsh="hg shelve"
alias hsl="hg shelve -l"
alias hu="hg update"
alias hus="hg unshelve"
alias rstruct="hg revert -C db/structure.sql"
alias hout="hg outgoing"
alias hin="hg incoming"

alias pg="psql --username postgres --dbname=pg_development"

function hrc
  heroku run console -a $argv
end

alias ddump="curl (heroku pgbackups:url -a shopmium) > ~/Downloads/last.dump"

alias k="kill -9"
alias kbg="kill (jobs -p)"

alias epry="pry -r ./config/environment"
alias pspec="bundle exec rake parallel:spec"
alias raklette="bundle exec rake parallel:spec"
alias be="bundle exec"
alias bspec="bundle exec rspec"
alias rdm="bundle exec rake db:migrate"
alias rds="bundle exec rake db:migrate:status"
alias rpp="bundle exec rake parallel:prepare"
alias rdtp="bundle exec rake db:test:prepare"
alias rdr="rake db:migrate:redo"
function rdd
  rake db:migrate:down VERSION=$argv
end
function rdu
  rake db:migrate:up VERSION=$argv
end

alias shops="cd ~/mercurial/shopmium/shops"
alias serv="cd ~/mercurial/shopmium/server"
alias mob="cd ~/mercurial/shopmium/mobile"
alias dot="cd ~/git/dotfiles"
alias blog="cd ~/git/blog"
alias budget="cd ~/git/budget"
alias dand="cd ~/git/dand.io"

alias mep="vi ~/mep.tasks"

# Theme
set -g fish_theme clearance2
set -g theme_display_user yes
set -g default_user thomaslarrieu

# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish
# Oh-my-fish plugins
set fish_plugins rvm rails rake brew bundler autojump tmux
# Gopath
set -x GOPATH ~/go
# PATH
set -x PATH $PATH $HOME/scripts
set -x PATH $PATH /Library/PostgreSQL/9.3/bin
set -x PATH $PATH /usr/local/heroku/bin
set -x PATH $PATH ~/bin/
set -x PATH $PATH ~/.cabal/bin
# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

# SSH agent
keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa
