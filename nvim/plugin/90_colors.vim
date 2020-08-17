augroup OverLength
  autocmd!
  autocmd BufReadPost,BufEnter,FileType,TermOpen * call s:overlength()
  autocmd OptionSet textwidth call s:overlength()
augroup END

augroup SETUP_COLORS
  autocmd!
  autocmd OptionSet background call s:setupcolors()
  autocmd SourceCmd $MYVIMRC call s:setup()
augroup END

function! s:overlength()
  let l:exclude = {
    \ 'filetype': [
    \   'qf',
    \   'man',
    \   'help',
    \   'netrw',
    \   'csv',
    \   'log',
    \   'postgresql',
    \   'mysql',
    \   'fugitiveblame',
    \   '',
    \ ],
    \ 'buftype': ['terminal']
    \ }

  let l:ft_exclude = index(l:exclude['filetype'], &filetype) != -1
  let l:bt_exclude = index(l:exclude['buftype'], &buftype) != -1

  if l:ft_exclude || l:bt_exclude
    execute 'match Folded //'
  else
    execute 'match Folded /\%' . (&textwidth + 1) . 'v.\+/'
  endif
endfunction

function! s:setupcolors()
  highlight! MatchParen cterm=bold ctermfg=1 ctermbg=7

  highlight! link SignColumn CursorColumn
  highlight! link SignatureMarkText Folded
  highlight! link HighlightedyankRegion Folded

  highlight! Folded cterm=bold

  highlight! link TabLine Normal
  highlight! link TabLineFill Normal
  highlight! TabLineSel ctermfg=5 ctermbg=none cterm=none

  highlight! link VertSplit CursorColumn

  highlight! link NormalNC CursorColumn

  highlight! link StatusLine Normal
  highlight! link StatusLineNC NormalNC

  highlight! link GitGutterAdd DiffAdd
  highlight! link GitGutterChange DiffChange
  highlight! link GitGutterDelete DiffDelete
  highlight! link GitGutterChangeDelete DiffDelete

  highlight! link QuickFixLine DiffChange

  highlight! link NeomakeVirtualtextError ErrorMsg
  highlight! link NeomakeVirtualtextWarning WarningMsg
  highlight! link NeomakeVirtualtextInfo WarningMsg
  highlight! link NeomakeVirtualtextMessage WarningMsg
endfunction

function! s:setuptheme()
  let l:query = system('xrdb -query')

  let l:res = matchlist(l:query, 'vim.theme:\s*\(.\{-}\)\n')
  if(len(l:res) > 1)
    execute 'colorscheme ' . l:res[1]
  else
    colorscheme default
  end

  let l:res = matchlist(l:query, 'vim.background:\s*\(.\{-}\)\n')
  if(len(l:res) > 1)
    execute 'set background=' . l:res[1]
  else
    set background=dark
  end
endfunction

function! s:setup()
  call s:setuptheme()
  call s:setupcolors()
endfunction

call s:setup()
