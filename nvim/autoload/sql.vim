function! sql#execute() range abort
  let l:query = ''
  let l:lines = getline(a:firstline, a:lastline)
  for l:line in l:lines
    if l:line !~# '--.*'
      let l:query .= l:line . "\\n"
    endif
  endfor

  call sql#run(l:query)
endfunction

function! sql#identify(entity) abort
  call sql#run('\d ' . a:entity)
endfunction

function! s:result() dict abort
  execute 'bdelete! ' . l:self.bufnr
  execute 'new ' . l:self.filename
  setf postgresql
endfunction

function! sql#run(query) abort
  let l:arguments = matchstr(getline(1), '--\s*\zs.*')

  let l:tempfile = tempname()

  let l:query = shellescape('\\timing on\n ' . a:query)
  let l:query = escape(l:query, '%')
  let l:cmdline =
    \ 'echo -e ' . l:query .
    \ '| psql ' . l:arguments .
    \ ' >& ' . l:tempfile

  new

  call termopen(
    \ l:cmdline,
    \ {
    \   'name' : 'postgres',
    \   'on_exit' : function('<sid>result'),
    \   'filename' : l:tempfile,
    \   'bufnr' : bufnr('%')
    \ })
endfunction

function! sql#upper(sql) abort
  let l:syntax_id = synID(line('.'), col('.') - 1, 0)
  let l:syntax_element = synIDattr(synIDtrans(l:syntax_id), 'name')

  " Do not uppercase word if within a comment or string
  if l:syntax_element =~# 'Comment\|String'
    return a:sql
  endif

  return toupper(a:sql)
endfunction