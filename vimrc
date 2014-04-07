" vim:fdm=marker
" ------------------------------------------------------------------------------
" Smockey's vimrc
" Designed for dvorak-bepo keyboard
" ------------------------------------------------------------------------------
set shell=/bin/bash
let $PAGER=''
let mapleader=","
let g:ruby_path = system('rvm current')
" {{{ ------------------------------------------------------------------- Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Vundle
Bundle 'gmarik/vundle'
" File Manipulation
Bundle 'kien/ctrlp.vim'
Bundle 'rking/ag.vim'
Bundle 'skwp/greplace.vim'
" Text manipulation
Bundle 'Valloric/YouCompleteMe'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'
Bundle 'AndrewRadev/switch.vim'
Bundle 'godlygeek/tabular'
Bundle 'vim-scripts/tlib'
Bundle 'vim-scripts/tComment'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'kana/vim-textobj-user'
Bundle 'vim-scripts/Parameter-Text-Objects'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'Townk/vim-autoclose'
Bundle 'edsono/vim-matchit'
Bundle 'tpope/vim-abolish'
Bundle 'vim-scripts/CSSMinister'
" Task manager
Bundle 'samsonw/vim-task'
" Undo tree explorer
Bundle 'sjl/gundo.vim'
" Better motion
Bundle 'Lokaltog/vim-easymotion'
" Documentation browser
Bundle 'rizzatti/funcoo.vim'
Bundle 'rizzatti/dash.vim'
" List toggler
Bundle 'milkypostman/vim-togglelist'
" Ruby
Bundle 'tpope/vim-endwise'
Bundle 'ecomba/vim-ruby-refactoring'
Bundle 'duskhacker/sweet-rspec-vim'
Bundle 'vim-ruby/vim-ruby'
Bundle 'rhysd/vim-textobj-ruby'
" VCS
Bundle 'tpope/vim-fugitive'
Bundle 'phleet/vim-mercenary'
Bundle 'zeekay/vim-lawrencium'
" Languages support
Bundle 'othree/html5.vim'
Bundle 'kchmck/vim-coffee-script'
Bundle 'vim-scripts/fish-syntax'
Bundle 'plasticboy/vim-markdown'
Bundle 'scrooloose/syntastic'
" Good looking
Bundle 'altercation/vim-colors-solarized'
Bundle 'bling/vim-airline'
Bundle 'kshenoy/vim-signature'
Bundle 'vim-scripts/AnsiEsc.vim'

filetype on
filetype plugin indent on
" }}}
" {{{ --------------------------------------------------------- Custom functions
function! MarkSplitSwap()
  let g:markedWinNum = winnr()
endfunction

function! DoSplitSwap()
  "Mark destination
  let curNum = winnr()
  let curBuf = bufnr( "%" )
  exe g:markedWinNum . "wincmd w"
  "Switch to source and shuffle dest->source
  let markedBuf = bufnr( "%" )
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' curBuf
  "Switch to dest and shuffle source->dest
  exe curNum . "wincmd w"
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' markedBuf
endfunction

function! SplitSwap()
  if exists("g:markedWinNum")
    silent call DoSplitSwap()
    unlet g:markedWinNum
  else
    silent call MarkSplitSwap()
  end
endfunction

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

function! DelTagOfFile(file)
  let fullpath = a:file
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let f = substitute(fullpath, cwd . "/", "", "")
  let f = escape(f, './')
  let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
  let resp = system(cmd)
endfunction

function! UpdateTags()
  let f = expand("%:p")
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"

  if filereadable(tagfilename)
    let cmd = 'ctags -a -f ' . tagfilename . ' "' . f . '"'
    call DelTagOfFile(f)
    let resp = system(cmd)
  endif
endfunction

" Those 2 functions should be refactored into a single one
function! s:AgOperator(type)
  let saved_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  silent execute "Ag! " . shellescape(@@) . " ."
  copen

  let @@ = saved_register
endfunction

function! s:DefinitionOperator(type)
  let saved_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  silent execute "Ag! " . shellescape('(def (self.)?|class )' . @@) . " ."
  copen

  let @@ = saved_register
endfunction

" }}}
" {{{ ------------------------------------------------------------- File Related
augroup vimrc_autocmd
  autocmd!
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  autocmd FileType ruby set makeprg=ruby\ %
  autocmd FileType gitcommit,hgcommit startinsert!
  autocmd FileType gitconfig set noexpandtab
  autocmd FileType vim setlocal foldlevel=0
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldminlines=1
  autocmd BufReadPost *.arb set ft=ruby
  autocmd BufReadPost *.md set ft=markdown
  autocmd BufReadPost *.md,*.markdown setlocal spell
  autocmd BufReadPost *.yml set ft=yaml
  autocmd FileType hgcommit,gitcommit setlocal spell
  " Only current splits gets cursor line / column highlighted
  autocmd WinLeave * set nocursorline
  autocmd WinLeave * set nocursorcolumn
  autocmd WinEnter * set cursorline
  autocmd WinEnter * set cursorcolumn
  "Go to the cursor position before buffer was closed
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif"`""'")
  autocmd BufWritePost * call UpdateTags()
  " Don't add the comment prefix when I hit enter or o/O on a comment line.
  autocmd FileType * setlocal formatoptions-=o formatoptions-=r
  " Don't screw up folds when inserting text that might affect them, until
  " leaving insert mode. Foldmethod is local to the window.
  autocmd InsertEnter * let w:last_fdm=&foldmethod | setlocal foldmethod=manual
  autocmd InsertLeave * let &l:foldmethod=w:last_fdm
  autocmd FileType man setlocal foldlevel=10
augroup END
syntax on
" }}}
" {{{ ---------------------------------------------------------- General options
" Color / background theme
set background=light
colorscheme solarized
if has('gui_running')
  set guifont=Inconsolata\ For\ Powerline:h17.6
  set guioptions-=l
  set guioptions-=r
  set guioptions-=b
  set guicursor+=n-v-c-i:ver11-iCursor
  hi! iCursor guifg=white guibg=#667B83
endif
" Set proper color for gutter line
hi! link SignColumn CursorColumn
" Line numbering (relative and current)
set rnu
set nu
" Line length warning (disabled for now)
" highlight OverLength ctermbg=red ctermfg=black
" match OverLength /\%81v.\+/
" Virtual editing
set virtualedit=all
" Blank character
set lcs=tab:\›\ ,trail:·,nbsp:¤,extends:>,precedes:<
set list
" Show matching braces
set showmatch
" Show command
set showcmd
" Encoding and filetype
set encoding=utf8
set ffs=unix,dos,mac
" Backup and swap files
set backupdir=~/.tmp
set directory=~/.tmp
" Ignore those files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,tags
" Case insensitive matching
set wildignorecase
" ctags
set tags=.tags,./.tags,./tags,tags
" current line / column highlight
set cursorline
set cursorcolumn
" Command completion style
set wildmode=list:longest,list:full
set wildmode=list:full,full
" Only complete to the GCD part of file name
set wildmenu
set complete=slf
" Disable any kind of annoying bell
set visualbell
set noerrorbells
" Allow a modified buffer to be sent to background without saving it
set nohidden
" Set title when in console
set title
" Activate undofile, that holds undo history
set undofile
" Give backspace a reasonable behavior
set backspace=indent,eol,start
" Disable line wrap
set nowrap
" }}}
" {{{ ------------------------------------------------------------------- Splits
hi VertSplit ctermfg=11 ctermbg=0
set splitright
set splitbelow
" }}}
" {{{ ---------------------------------------------------------------- Scrolling
set scrolloff=8
let &scrolloff=999-&scrolloff
set sidescrolloff=15
set sidescroll=1
" }}}
" {{{ ------------------------------------------------------------------- Indent
set ai "autoindent
set si "smart indent
set tabstop=2
set shiftwidth=2
set expandtab
set shiftround
" }}}
" {{{ ------------------------------------------------------------------ Folding
" hi Folded term=bold cterm=bold ctermfg=12 ctermbg=0
set foldcolumn=0
set foldclose=
set foldmethod=indent
set foldnestmax=1
set foldlevel=10
set fillchars+=fold: 
set foldminlines=1
" }}}
" {{{ ---------------------------------------------------------------- Searching
" case behavior regarding searching
set ignorecase
set smartcase
" some more search related stuff
set hlsearch  " highlight search
set incsearch " start search while typing
" }}}
" {{{ ------------------------------------------------------------ Spellchecking
set spelllang=en,fr
" }}}
" {{{ ------------------------------------------------------------------ Plugins
" {{{ ------------------------------------ Greplace
set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'
" }}}
" {{{ ----------------------------------- Syntastic
let g:syntastic_javascript_checkers = ['jsl']
let g:syntastic_javascript_jsl_conf = "~/.jsl.conf"
" }}}
" {{{ ---------------------------------------- Dash
let g:dash_map = {
      \ 'ruby': ['rails', 'ruby', 'gemsets']
      \ }
" }}}
" {{{ -------------------------------------- Switch
augroup switch
  autocmd!
  autocmd FileType ruby let b:switch_custom_definitions =
        \[
        \ {
        \   'lambda { |\(.*\)| \(.*\) }': '->(\1) { \2 }',
        \   'lambda { \(.*\) }': '-> { \1 }',
        \ },
        \]
augroup END
" }}}
" {{{ ------------------------------------------ Ag
let g:ag_apply_qmappings = 0
let g:ag_apply_lmappings = 0
" }}}
" {{{ ---------------------------------- Easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
let g:EasyMotion_cursor_highlight = 1
let g:EasyMotion_prompt = get(g:, 'EasyMotion_prompt', 'EasyMotion : ')
let g:EasyMotion_keys = get(g:, 'EasyMotion_keys', 'auie,ctsrn.qbpovdljyxkghAUIECTSRNQBPOVDLJYXKGH;')
let g:EasyMotion_incsearch = 1
hi EasyMotionShade     ctermfg=12 guifg=#93A1A1
hi EasyMotionTarget    ctermfg=5 guifg=#D13A82
hi EasyMotionIncSearch ctermfg=2 guifg=#85981C
hi Search              ctermbg=none ctermfg=2 guibg=#FDF6E4 guifg=#85981C
hi IncSearch           ctermbg=none ctermfg=2 guibg=#FDF6E4 guifg=#85981C
" }}}
" {{{ ------------------------------- YouCompleteMe
" I want tab for Snipmate so I deactivate it for YCM
let g:ycm_key_list_select_completion = []
" }}}
" {{{ ------------------------------------- Airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
let g:airline_symbols.paste = 'ρ'

set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
let g:airline_theme = 'solarized'
let g:airline_powerline_fonts = 1
let g:airline_inactive_collapse=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2
" }}}
" {{{ --------------------------------------- Slime
let g:slime_target = "tmux"
let g:slime_no_mapping=1
" }}}
" {{{ ------------------------------------ Surround
" I want to rebind some (one in fact) bindings and since I cant unbind
" any at this point, I'll go for the brutal way.
let g:surround_no_mappings=1
" }}}
" {{{ --------------------------------------- RSpec
let g:RspecKeymap=0
" }}}
" {{{ ----------------------------------- Command-T

" let g:CommandTMaxHeight = "15"
" let g:CommandTMatchWindowReverse = 1
" }}}
" {{{ --------------------------------------- CtrlP
let g:ctrlp_map = ' '
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 1
" }}}
" {{{ ---------------------------- Ruby Refactoring
let g:ruby_refactoring_map_keys=0
" }}}
" }}}
" {{{ --------------------------------------------------------- Keyboard mapping
" {{{ ------------------------------------ Greplace
noremap <leader>S :Gsearch 
noremap <leader>R :Greplace<cr>
" }}}
" {{{ --------------------------------------- Gundo
augroup Gundo
  autocmd!
  autocmd FileType gundo noremap <buffer> t 2gj
  autocmd FileType gundo noremap <buffer> s 2gk
augroup END
noremap gu :GundoToggle<cr>
" }}}
" {{{ -----------------------------------------Dash
nmap <leader>s <plug>DashSearch
" }}}
" {{{ ------------------------------------------ Ag
augroup Ag
  autocmd!
  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <C-t> <C-W><CR><C-W>T
  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <C-v> <C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t
augroup END

nmap <leader>a :Ag! ""<left>
nmap <leader>u :set operatorfunc=<SID>AgOperator<cr>g@
vmap <leader>u :<c-u>call <SID>AgOperator(visualmode())<cr>
nmap <leader>d :set operatorfunc=<SID>DefinitionOperator<cr>g@
vmap <leader>d :<c-u>call <SID>DefinitionOperator(visualmode())<cr>
" }}}
" {{{ ---------------------------------- Easymotion
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map e <Plug>(easymotion-lineforward)
map b <Plug>(easymotion-linebackward)
map f <Plug>(easymotion-s)
map F <Plug>(easymotion-s2)
map è <Plug>(easymotion-t)
map È <Plug>(easymotion-t2)
map <leader>t <Plug>(easymotion-j)
map <leader>s <Plug>(easymotion-k)
" }}}
" {{{ ------------------------------------ Vim-Task
augroup task
  autocmd!
  autocmd FileType task noremap <silent> <buffer> zt :call Toggle_task_status()<cr>
augroup END
" }}}
" {{{ --------------------------------------- Slime
xmap <leader>ll <Plug>SlimeRegionSend
nmap <leader>ll <Plug>SlimeParagraphSend
nmap <leader>lv <Plug>SlimeConfig
" }}}
" {{{ ---------------------------- Ruby Refactoring
nmap <leader>rap :RAddParameter<cr>
nmap <leader>rel :RExtractLet<cr>
vmap <leader>rlv :RRenameLocalVariable<cr>
vmap <leader>riv :RRenameInstanceVariable<cr>
vmap <leader>rem :RExtractMethod<cr>
" }}}
" {{{ --------------------------------------- RSpec
map <leader>rs :SweetVimRspecRunFile<cr>
map <leader>rr :SweetVimRspecRunPrevious<cr>
map <leader>rl :SweetVimRspecRunFocused<cr>
" }}}
" {{{ -------------------------------------- Switch
nmap -  :Switch<cr>
" }}}
" {{{ ----------------------------------- Command-T
" map   :<c-u>CommandT<cr>
" map <leader>f :<c-u>CommandTFlush<cr>
" }}}
" {{{ --------------------------------------- CtrlP
map <leader>f :<c-u>CtrlPClearCache<cr>
" }}}
" {{{ ------------------------------------- Tabular
map  <leader><leader> :Tabularize /
vmap <leader><leader> :Tabularize /
" }}}
" {{{ ------------------------------------ Fugitive
map <leader>gb :Gblame<cr>
map <leader>gd :Gdiff<cr>
map <leader>gw :Gwrite<cr>
map <leader>gr :Gread<cr>
map <leader>gc :Gcommit<cr>
map <leader>gs :Gstatus<cr>
" }}}
" {{{ ---------------------- Mercenary / Lawrencium
map <leader>hb :HGblame<cr>
map <leader>hd :HGdiff<cr>
map <leader>hh :Hg! 
map <leader>hc :Hgcommit<cr>
map <leader>hs :Hgstatus<cr>
map <leader>hrr :<c-u>let @+ = expand("%")<cr>:Hg resolve -m <c-r>+<cr>
map <leader>hrl :Hg! resolve -l<cr>
" }}}
" {{{ ------------------------------------- Calcium
map <leader>hl :Calcium<cr>
" }}}
" {{{ ------------------------------------ Surround
nmap du  <Plug>Dsurround
nmap lu  <Plug>Csurround
nmap yu  <Plug>Ysurround
nmap yU  <Plug>YSurround
nmap yuu <Plug>Yssurround
nmap yUu <Plug>YSsurround
nmap yUU <Plug>YSsurround
vmap u   <Plug>VSurround
vmap U   <Plug>VgSurround
" }}}
" {{{ --------------------------------------- Marks
noremap ' `
noremap ` '
" }}}
" {{{ ------------------------------- Splits / Tabs
" Navigating between splits
noremap <s-s>  <c-w>W
noremap <s-t>  <c-w>w
noremap <s-c>  gT
noremap <s-r>  gt
" Resize splits
map <Up>    <c-w>+
map <Down>  <c-w>-
map <Left>  <c-w><
map <Right> <c-w>>
map <leader>= <c-w>=
map <leader>% :res<cr>:vertical res<cr>$
" }}}
" {{{ ------------------------------------ Movement
" Beginning / end of the line
cnoremap <c-a> <home>
cnoremap <c-e> <end>
imap <c-a> <c-o>^
imap <c-e> <c-o>$
nmap ç ^
vmap ç ^
" left / right / down (visual line) / up (visual line)
noremap c h
noremap r l
noremap t gj
noremap s gk
" Gathering selected lines (or current one if none selected) in one line
noremap <c-l> J
noremap <return> i<CR><ESC>
" Switching w for é (much saner spot)
nnoremap é w
nnoremap É W
onoremap aé aw
onoremap aÉ aW
onoremap ié iw
onoremap iÉ iW
vnoremap aé aw
vnoremap aÉ aW
vnoremap ié iw
vnoremap iÉ iW
" Mapping w to C-w
noremap  w <c-w>
" visual shifting (builtin-repeat)
nmap » >>_
nmap « <<_
vmap » >gv
vmap « <gv
" Don't make a # force column zero.
inoremap # X<bs>#
" Ctags
noremap <c-t> <c-]>
noremap <c-r> <c-t>
" Center screen when scrolling search results
noremap n nzz
noremap N Nzz
noremap * *zz
noremap # #zz
" Paste from system buffer
map <leader>p :set paste<cr>o<esc>"*]p:set nopaste<cr>
map <leader>P :set paste<cr>O<esc>"*]p:set nopaste<cr>
map <leader>y :<c-u>let @+ = expand("%")<cr>:echo 'File name yanked.'<cr>
" Method move
map <leader>m ]m
map <leader>M [m
" }}}
" {{{ ------------------------------ Mode Switching
" Save
nnoremap <c-s> :w<cr>
vnoremap <c-s> <esc>:w<cr>
inoremap <c-s> <esc>:w<cr>
" Normal mode
noremap  <Space> :
vnoremap <c-c> <esc>
inoremap <c-c> <esc>
snoremap <c-c> <esc>
" Change mode
noremap l c
noremap L C
" Exit
noremap à :q<cr>
noremap À :qa<cr>
noremap Q :bd<cr>
noremap ê :bd<cr>
" }}}
" {{{ ------------------------------------ Togglers
" Rename file
map <leader>n :call RenameFile()<cr>
" Quifix togglers
nmap <silent> <leader>q :call ToggleQuickfixList()<cr>
nmap <silent> <leader>l :call ToggleLocationList()<cr>
" Clear search
noremap <silent> h :let @/ = ""<cr>
" Search within visual selection
map <c-f> <Esc>/\%V
" Replace in visual selection
map <c-g> <esc>:%s/\%V
" Toggle line wrap
map <leader>w :set wrap!<cr>
noremap U :redo<cr>
" Split swap
map <leader>e :call SplitSwap()<cr>
" }}}
" }}}
smapclear
