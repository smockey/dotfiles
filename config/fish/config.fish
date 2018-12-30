stty -ixon

# FZF
set -x FZF_DEFAULT_COMMAND "ag -g '' --hidden --ignore .git"
set -x FZF_DEFAULT_OPTS '--reverse'

set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_CTRL_T_OPTS $FZF_DEFAULT_OPTS

# rbenv
if type rbenv > /dev/null
  source (rbenv init - | psub)
end

# Postgres
set PGHOST localhost

# EDITOR
set -g -x EDITOR nvim
set -g -x BROWSER luakit

# PATH
set -x PATH $PATH $HOME/scripts
set -x PATH $PATH $HOME/bin
set -x PATH $PATH $HOME/.ghcup/bin

set -x PATH $HOME/.yarn/bin $PATH
set -x PATH $HOME/.ghcup/bin $PATH

# TERM
set -gx TERM xterm-256color

set fish_greeting ""

fundle plugin 'tuvistavie/fish-ssh-agent'
fundle plugin 'oh-my-fish/plugin-foreign-env'
fundle plugin 'derekstavis/plugin-nvm'
fundle init
