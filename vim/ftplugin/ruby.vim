setlocal conceallevel=2
setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

setlocal iskeyword+=?
setlocal iskeyword+=!

nnoremap <buffer> <leader><return> :call neoterm#test#run('file')<cr>
nnoremap <buffer> <return> :call neoterm#test#run('current')<cr>

let g:neomake_ruby_rubocop_maker = {
      \ 'args': ['-D'],
      \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
      \ }

let g:neomake_ruby_enabled_makers = ['mri', 'rubocop']

let b:switch_custom_definitions =
  \[
  \  ['&&', '||'],
  \  {
  \    '\Ctrue':  'false',
  \    '\Cfalse': 'true',
  \  },
  \  {
  \     'if true or (\(.*\))':          'if false and (\1)',
  \     'if false and (\(.*\))':        'if \1',
  \     'if \%(true\|false\)\@!\(.*\)': 'if true or (\1)',
  \  },
  \  {
  \    ':\(\k\+\)\s*=>\s*': '\1: ',
  \    '\<\(\k\+\): ':      ':\1 => ',
  \  },
  \  {
  \    '"\(\k\+\)"':                '''\1''',
  \    '''\(\k\+\)''':              ':\1',
  \    ':\(\k\+\)\@>\%(\s*=>\)\@!': '"\1"\2',
  \  },
  \  {
  \    '"\(.\+\)"':                '''\1''',
  \    '''\(.\+\)''':              '"\1"',
  \  },
  \  {
  \    'lambda { |\(.*\)| \(.*\) }': '->(\1) { \2 }',
  \    'lambda {|\(.*\)| \(.*\)}': '->(\1) { \2 }',
  \    'lambda { \(.*\) }': '-> { \1 }',
  \    'lambda {\(.*\)}': '-> { \1 }',
  \  },
  \  {
  \    '\(expect.*\.\)\(to\) ':     '\1not_\2 ',
  \    '\(expect.*\.\)\(not_\)\(to\) ': '\1\3 ',
  \  },
  \  ['be_truthy', 'be_falsey']
  \]

" Methods list
function! s:deflines()
  if !bufexists(expand('%'))
    return []
  endif
  let grep = 'grep -n "^\s*def"'
  let awk = "awk '{print $1 $3}'"
  let column = "column -t -s ':'"
  let lines = system(grep . ' ' . expand('%:p') . '|' . awk . '|' . column)
  return split(lines, '\n')
endfunction

function! s:defjump(l)
  let keys = split(a:l)
  exec keys[0]
  normal! ^zz
endfunction

nnoremap <c-l> :call fzf#run({
  \   'source':  <sid>deflines(),
  \   'sink':    function('<sid>defjump'),
  \   'options': '--extended --nth=2.. +s',
  \   'down':    '30%'
  \ })<cr>
