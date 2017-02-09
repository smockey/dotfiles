augroup GIT
  autocmd!

  autocmd BufEnter COMMIT_EDITMSG startinsert!
  autocmd BufEnter COMMIT_EDITMSG nnoremap <buffer> <cr> :x<cr>
  autocmd BufEnter COMMIT_EDITMSG nnoremap <buffer> <c-s> :x<cr>
  autocmd BufEnter COMMIT_EDITMSG inoremap <buffer> <c-s> <esc>:x<cr>

  autocmd InsertCharPre COMMIT_EDITMSG if search('\v(%^|[.!?\]]\_s|\n\n)\_s*%#', 'bcnw') != 0 | let v:char = toupper(v:char) | endif

  autocmd BufEnter index nnoremap <buffer> <c-s> :Gcommit<cr>
  autocmd BufEnter index nnoremap <buffer> <c-a> :Gcommit --amend<cr>
augroup END

call setpos('.', [0, 1, 1, 0])

setlocal spell
setlocal nonumber
setlocal norelativenumber
