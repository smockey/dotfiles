function man
  command man $argv 1>/dev/null
  and command man $argv | nvim -c 'setf man'
end
