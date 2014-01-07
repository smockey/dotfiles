#!/bin/zsh

[[ "$1" == "-f" ]] && FORCE=true

safelink()
{
  target=$1
  link=$2
  if [ $FORCE ]; then
    rm $link -rf
    ln -s -P $target $link
  else
    if [ -d $target ]; then
      echo -n "$link already exists, do you want to replace it? "
      read answer
      case $answer in
        "yes"|"y")
          rm $link -rf
          ;;
      esac
    fi
    ln -s -i $target $link
  fi
}

[[ -d ~/.config ]] || mkdir ~/.config
BASEDIR=$(cd "$(dirname "$0")"; pwd)

# .config directories
for file in `ls -d $BASEDIR/config/*`; do
  target=$BASEDIR/config/`basename $file`
  link=~/.config/`basename $file`
  safelink $target $link
done

# .vimrc
safelink $BASEDIR/vimrc $HOME/.vimrc

#.vim
safelink $BASEDIR/vim $HOME/.vim

# .zprezto
safelink $BASEDIR/zprezto $HOME/.zprezto

# zsh / zprezto dotfiles
for file in `ls $BASEDIR/zprezto/runcoms/z*`; do
  target=$BASEDIR/zprezto/runcoms/`basename $file`
  link=~/.`basename $file`
  safelink $target $link;
done

# .vimperatorrc
safelink $BASEDIR/vimperatorrc $HOME/.vimperatorrc

# .gitconfig & .gitignore
safelink $BASEDIR/gitconfig $HOME/.gitconfig
safelink $BASEDIR/gitignore $HOME/.gitignore

# .tmux.conf
safelink $BASEDIR/tmux.conf $HOME/.tmux.conf

# .zsh (utility functions for prezto theme
safelink $BASEDIR/zsh $HOME/.zsh

# fonts
[[ -d $HOME/.fonts ]] || mkdir $HOME/.fonts
cp $BASEDIR/Inconsolata\ for\ Powerline.otf $HOME/.fonts/
