function fish_user_key_bindings
  fzf_key_bindings

  function fkill
    echo '' > /tmp/fzf.kill
    ps ux | sed 1d | fzf -m -e | awk '{print $2}' > /tmp/fzf.kill

    kill -9 (cat /tmp/fzf.kill) 2> /dev/null
  end

  function fzf-gitbranch
    set -q FZF_CTRL_B_COMMAND; or set -l FZF_CTRL_B_COMMAND "git branch -a"
    eval "$FZF_CTRL_B_COMMAND | fzf --extended --nth=2.. -d ' ' -m -e > /tmp/fzf.result"
    and commandline -i (
      cat /tmp/fzf.result | \
      cut -c3- | \
      sed 's#remotes/origin/##' | \
      tr '\n' ' ' | \
      sed 's# +##'
    )
    commandline -f repaint
    rm -f /tmp/fzf.result
  end

  function fzf-gitfiles
    set -q FZF_CTRL_X_COMMAND
    or  set -l FZF_CTRL_X_COMMAND "git -c color.status=always status --short"
    set -l fzf_command "fzf --extended --ansi --nth=2.. -d ' ' -m -e"
    eval "$FZF_CTRL_X_COMMAND | $fzf_command > /tmp/fzf.result"
    and commandline -i (cat /tmp/fzf.result | awk '{ print $2 }' | paste -d' ' -s -)
    commandline -f repaint
    rm -f /tmp/fzf.result
  end

  function fzf-gitsha
    set -q FZF_GIT_LOG_COMMAND; or set -l FZF_GIT_LOG_COMMAND "git llga"
    eval "$FZF_GIT_LOG_COMMAND |\
      fzf --ansi --no-sort --reverse --tiebreak=index -e\
      --preview '~/scripts/fzf-git.sh {}'\
      > /tmp/fzf.result"
    and commandline -i (cat /tmp/fzf.result | grep -o '[a-f0-9]\{7\}' | head -1)
    commandline -f repaint
    rm -f /tmp/fzf.result
  end

  bind \et 'fkill'
  bind þ 'fkill'

  bind \ea 'fzf-gitsha'
  bind æ 'fzf-gitsha'
  bind \cb 'fzf-gitbranch'
  bind \cx 'fzf-gitfiles'

  if bind -M insert > /dev/null 2>&1
    bind -M insert \et 'fkill'
    bind -M insert þ 'fkill'
    bind -M insert \ea 'sh ~/scripts/fshow.sh'
    bind -M insert æ 'sh ~/scripts/fshow.sh'
    bind -M insert \cb 'fzf-gitbranch'
    bind -M insert \ex 'fzf-gitfiles'
  end
end
