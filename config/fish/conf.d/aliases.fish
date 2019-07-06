# reset terminal
abbr cls " echo -ne \\033c"

# xdg-open
abbr . "open"

# systemctl
abbr ctl "systemctl"

# nmcli
abbr nmcli "nmcli --color yes"

# NVIM
alias ep "nvim -R -"
abbr e "nvim"
abbr se "sudo nvim"
function scr
  set -l file "$HOME/git/dotfiles/scripts/$argv"

  test -e $file
  and nvim $file
  or echo -e 'i#!/bin/sh\n' | nvim -c 'setf sh' -s - -- $file

  chmod 700 $file ^ /dev/null
end

function app
  set -l file "$HOME/git/dotfiles/apps/$argv"

  test -e $file
  and nvim $file
  or echo -ne 'i#!/bin/sh\n\nchromium --app="https://"i' \
    | nvim -c 'setf sh' -s - -- $file

  chmod 700 $file ^ /dev/null
end

# xsel
abbr xo "xsel --clipboard -o"
abbr xi "xsel --clipboard -i"

# aria2c
abbr dl "aria2c --dir=$HOME/Downloads"

# curl
abbr c "curl"
abbr co "curl -O"
abbr cc "curl (xsel --clipboard -o)"
abbr cco "curl -O (xsel --clipboard -o)"

# youtube-dl
abbr yv "youtube-dl -fbest (xsel --clipboard -o)"
abbr ym "youtube-dl -fbestaudio (xsel --clipboard -o)"

# Zathura
abbr z "zathura"

# Various CLI utils
abbr tree "tree -C"
abbr less "less -R"

# atool
abbr atx "aunpack"
abbr atp "apack"

# YAY
abbr y "yay"
abbr yqs "yay -Qs --color always"
abbr ys "yay -S"
abbr yss "yay -Ss --color always"
abbr ysuy "yay -Suy"
abbr ysc "yay -Sc"
abbr yr "yay -Rs"
abbr yrc "yay -Rsc"
alias lspkg "awk 'BEGIN{while ((\"pacman -Qi\" |getline) > 0){ if (\$0 ~ /Name/) {name=\$3};{if (\$0 ~ /Size/) {size=\$4/1024;print name\": \",size,\"Mb\"|\"sort -k2 -n|column -t\"}}}}'"

# cd
abbr ,a "cd ~/apps"
abbr ,b "cd ~/sandbox"
abbr ,c "cd ~/git/dotfiles"
abbr ,d "cd ~/Documents"
abbr ,o "cd ~/Downloads"
abbr ,m "cd ~/Music"
abbr ,e "cd ~/Documents/management"
abbr ,i "cd ~/Documents/management/individual"
abbr ,p "cd ~/Pictures"
abbr ,s "cd ~/scripts"
abbr ,v "cd ~/Videos"
abbr ,w "cd ~/Pictures/wallpapers"

# SSH
abbr ssh-wtf "cat ~/.ssh/config | grep Host | grep -v Hostname | sort | sed 's/Host //'"

# Git
abbr g "git"
abbr gcd "cd (git rev-parse --show-toplevel)"
abbr ga "git add"
abbr ga. "git add ."
abbr gb "git branch"
abbr gd "git d"
abbr gds "git ds"
abbr gcl "git clone"
abbr gci "git commit"
abbr gco "git checkout"
abbr gl "git log"
abbr glg "git lg"
abbr gllg "git llg"
abbr gpl "git pull"
abbr gpr "git pull --rebase"
abbr gps "git push"
abbr gr "git rebase"
abbr grc "git rebase --continue"
abbr gs "git status -s -b"

# Rails / Rake / Bundler
abbr r "rails"
abbr rc "rails console"
abbr rs "bundle exec rails server"
abbr be "bundle exec"
abbr rdm "bundle exec rake db:migrate db:test:prepare"
abbr rds "bundle exec rake db:migrate:status | tail"
abbr rpp "bundle exec rake parallel:prepare"
function rdd; bundle exec rake db:migrate:down VERSION=$argv; end
function rdu; bundle exec rake db:migrate:up VERSION=$argv; end

# Various languages
abbr py "python"
abbr rb "ruby"

# Docker
abbr dc "sudo docker-compose"
abbr dcu "sudo docker-compose up -d"
abbr dcd "sudo docker-compose down"
abbr d "sudo docker"

# Kubernetes
abbr k "kubectl"
function ksh; kubectl exec -it $argv /bin/bash; end

# stack (haskell)
abbr s "stack"

# fonts
abbr font "fc-list | grep -i"

# exercism
abbr ed "cd (echo (xsel --clipboard -o) | xargs -I{} /bin/sh -c '{}')"
