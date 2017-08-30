#!/bin/sh

[[ "$1" == "-f" ]] && FORCE=true
SKIP=false

safelink()
{
  $SKIP && return

  target=$1
  link=$2

  if [ $FORCE ]; then
    DO_LINK=true
  else
    if [ -d $link -o -f $link ]; then
      DO_LINK=false

      echo -n "$(tput setaf 3)'$link' already exists, do you want to replace it? ([y]es/[N]o/[a]ll/[s]kip) $(tput sgr0)"

      read answer
      case $answer in
        "yes"|"y")
          DO_LINK=true
          ;;
        "all"|"a")
          FORCE=true
          DO_LINK=true
          ;;
        "skip"|"s")
          SKIP=true
          return
          ;;
        *)
          DO_LINK=false
          ;;
      esac
    else
      DO_LINK=true
    fi
  fi

  $DO_LINK && ln -sfFT $target $link
}

safeinstall() {
  package=$1

  if type yaourt > /dev/null; then
    yaourt -S --needed $package
  else
    sudo pacman -S --needed $package
  fi
}

BASEDIR=$(cd "$(dirname "$0")"; pwd)

git submodule init
git submodule update

# -- [[ Linking ]] -------------------------------------------------------------
echo "Linking configuration files..."
# .config directories
[[ -d ~/.config ]] || mkdir ~/.config
for file in `ls -d $BASEDIR/config/*`; do
  target=$BASEDIR/config/`basename $file`
  link=~/.config/`basename $file`
  safelink $target $link
done

# nvim
safelink $BASEDIR/nvim $HOME/.config/nvim

# Gnuplot
safelink $BASEDIR/gnuplot $HOME/gnuplot

# Bash
safelink $BASEDIR/bashrc $HOME/.bashrc

# moc
safelink $BASEDIR/moc $HOME/.moc

# weechat
safelink $BASEDIR/weechat $HOME/.weechat

# .gitconfig & .gitignore
safelink $BASEDIR/gitconfig $HOME/.gitconfig
safelink $BASEDIR/gitignore $HOME/.gitignore
git config --global core.excludesFile ~/.gitignore

# tmux.conf
safelink $BASEDIR/tmux.conf $HOME/.tmux.conf

# agignore
safelink $BASEDIR/agignore $HOME/.agignore

# irbrc
safelink $BASEDIR/irbrc $HOME/.irbrc

# rubocop
safelink $BASEDIR/rubocop.yml $HOME/.rubocop.yml

# scripts
mkdir -p $HOME/scripts
for file in `ls -d $BASEDIR/scripts/*`; do
  target=$BASEDIR/scripts/`basename $file`
  link=~/scripts/`basename $file`
  safelink $target $link
done

# asoundrc
safelink $BASEDIR/asoundrc $HOME/.asoundrc

# xprofile
safelink $BASEDIR/xprofile $HOME/.xprofile

# xresources
safelink $BASEDIR/xresources $HOME/.Xresources
mkdir -p $HOME/.Xresources.d
for file in `ls -d $BASEDIR/xresources.d/*`; do
  target=$BASEDIR/xresources.d/`basename $file`
  link=~/.Xresources.d/`basename $file`
  safelink $target $link
done
[ -f ~/.Xresources.d/local ] || \
  cp ~/.Xresources.d/local.sample ~/.Xresources.d/local

# Xmodmap
safelink $BASEDIR/xmodmap.lavie-hz750c $HOME/.Xmodmap

# dircolors
safelink $BASEDIR/dir_colors $HOME/.dir_colors

# linopen
safelink $BASEDIR/linopenrc $HOME/.linopenrc

if [ ! $SKIP ]; then
  echo "$(tput setaf 2)Done.$(tput sgr0)"
fi

# -- [[ Package / plugins installation ]] --------------------------------------
# Core pacakages (maybe we should make a meta package or something)
echo
echo -n "Do you want to check packages? ([y]es/[N]o) "

read answer
case $answer in
  "yes"|"y")
    safeinstall yaourt
    safeinstall awesome-git
    safeinstall qutebrowser-git
    safeinstall neovim
    safeinstall ranger
    safeinstall w3m

    safeinstall linopen

    safeinstall rofi
    safeinstall maim
    safeinstall feh

    safeinstall zathura
    safeinstall zathura-djvu
    safeinstall zathura-pdf-mupdf
    safeinstall zathura-ps

    safeinstall mpc
    safeinstall mpd
    safeinstall mpv

    safeinstall fish
    safeinstall fundle-git

    safeinstall rxvt-unicode
    safeinstall urxvt-resize-font-git
    safeinstall urxvt-clipboard
    safeinstall urxvt-config-reload-git

    safeinstall nerd-fonts-complete
    echo "$(tput setaf 2)All dependencies are up to date$(tput sgr0)"
    ;;
  *)
    echo "$(tput setaf 3)Packages update skipped$(tput sgr0)"
    ;;
esac

echo

echo "Configuring fish..."
fish -c 'fundle install' > /dev/null
echo "$(tput setaf 2)Fish is fully configured. Don't forget to set it as your shell$(tput sgr0)"

echo

echo "Configuring neovim..."
# vim-plug
if [[ -f ~/.config/nvim/autoload/plug.vim ]]; then
  echo "$(tput setaf 2)vim-plug already installed. Nothing to do!$(tput sgr0)"
else
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim +PlugInstall +qall
fi
echo "$(tput setaf 2)Neovim is fully configured.$(tput sgr0)"
