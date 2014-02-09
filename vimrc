" vim:fdm=marker
" ------------------------------------------------------------------------------
" Smockey's vimrc
" Designed for dvorak-bepo keyboard
" ------------------------------------------------------------------------------
set shell=/bin/sh
let $PAGER=''
let mapleader="," " remapping leader
let g:ruby_path = system('rvm current')
" {{{ ------------------------------------------------------------------- Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Vundle
Bundle 'gmarik/vundle'
" Utils
Bundle 'Valloric/YouCompleteMe'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'wincent/Command-T'
Bundle 'godlygeek/tabular'
Bundle 'vim-scripts/tComment'
Bundle 'vim-scripts/tlib'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'
Bundle 'epmatsw/ag.vim'
Bundle 'kana/vim-textobj-user'
Bundle 'vim-scripts/Parameter-Text-Objects'
Bundle 'Townk/vim-autoclose'
Bundle 'chrisbra/NrrwRgn'
Bundle 'tsaleh/vim-matchit'
Bundle 'AndrewRadev/switch.vim'
Bundle 'jpalardy/vim-slime'
Bundle 'sjl/gundo.vim'
Bundle 'samsonw/vim-task'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'michaeljsmith/vim-indent-object'
" Ruby
Bundle 'tpope/vim-endwise'
Bundle 'ecomba/vim-ruby-refactoring'
" Bundle 'thoughtbot/vim-rspec'
Bundle 'duskhacker/sweet-rspec-vim'
Bundle 'vim-ruby/vim-ruby'
Bundle 'rhysd/vim-textobj-ruby'
" VCS
Bundle 'tpope/vim-fugitive'
Bundle 'phleet/vim-mercenary'
Bundle 'zeekay/vim-lawrencium'
" Languages support
Bundle 'othree/html5.vim'
Bundle 'vim-scripts/fish-syntax'
Bundle 'plasticboy/vim-markdown'
" Good looking
Bundle 'altercation/vim-colors-solarized'
Bundle 'bling/vim-airline'
Bundle 'kshenoy/vim-signature'
Bundle 'vim-scripts/AnsiEsc.vim'

filetype on
filetype plugin indent on
" }}}
" {{{ --------------------------------------------------------- Custom functions
" Toggle fold state between closed and opened.
" If there is no fold at current line, just moves forward.
" If it is present, reverse it's state.
" function! ToggleFold()
"   if foldlevel('.') == 0
"     normal! l
"   else
"     if foldclosed('.') < 0
"       . foldclose
"     else
"       . foldopen
"     endif
"   endif
"   echo
" endf

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
" }}}
" {{{ ------------------------------------------------------------- File Related
augroup vimrc_autocmd
  autocmd!
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  autocmd FileType gitcommit,hgcommit startinsert!
  autocmd FileType vim setlocal foldlevel=0
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldminlines=1
  autocmd BufReadPost *.md set ft=markdown
  autocmd BufReadPost *.md,*.markdown setlocal spell
  autocmd BufReadPost *.fish,*.load set ft=sh
  " Only current splits gets cursor line / column highlighted
  autocmd WinLeave * set nocursorline
  autocmd WinLeave * set nocursorcolumn
  autocmd WinEnter * set cursorline
  autocmd WinEnter * set cursorcolumn
  "Go to the cursor position before buffer was closed
  autocmd BufReadPost * silent normal g'"
  autocmd BufWritePost * call UpdateTags()
  " Don't add the comment prefix when I hit enter or o/O on a comment line.
  autocmd FileType * setlocal formatoptions-=o formatoptions-=r
  " Don't screw up folds when inserting text that might affect them, until
  " leaving insert mode. Foldmethod is local to the window.
  autocmd InsertEnter * let w:last_fdm=&foldmethod | setlocal foldmethod=manual
  autocmd InsertLeave * let &l:foldmethod=w:last_fdm
  autocmd FileType man setlocal foldlevel=10
  autocmd FileType gundo noremap <buffer> t 2gj
  autocmd FileType gundo noremap <buffer> s 2gk
augroup END
syntax on
" }}}
" {{{ ---------------------------------------------------------- General options
" Color / background theme
set background=dark
colorscheme solarized
" Set proper color for gutter line
hi! SignColumn ctermbg=8
" Line numbering (relative to current line)
set rnu
" Current line
set nu
" Line length warning
highlight OverLength ctermbg=red ctermfg=black
match OverLength /\%81v.\+/
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
set novisualbell
set noerrorbells
" Allow a modified buffer to be sent to background without saving it
set hidden
" Set title when in console
set title
" Activate undofile, that holds undo history
set undofile
" Give backspace a reasonable behavior
set backspace=indent,eol,start
set splitright
set splitbelow
" Scrolling
set scrolloff=8
let &scrolloff=999-&scrolloff
set sidescrolloff=15
set sidescroll=1
" Disable line wrap
set nowrap
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
hi FoldColumn guibg=grey78 gui=Bold guifg=DarkBlue
set foldcolumn=0
set foldclose=
set foldmethod=indent
set foldnestmax=1
set foldlevel=10
set fillchars=vert:\|,fold:\ 
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
" {{{ ---------------------------------- Easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
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

set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
let g:airline_theme = 'solarized'
let g:airline_powerline_fonts = 1
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
let g:CommandTMaxHeight = "15"
let g:CommandTMatchWindowReverse = 1
" }}}
" {{{ ---------------------------- Ruby Refactoring
let g:ruby_refactoring_map_keys=0
" }}}
" }}}
" {{{ --------------------------------------------------------- Keyboard mapping
" {{{ ---------------------------------- Easymotion
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map <Leader>er <Plug>(easymotion-lineforward)
map <Leader>et <Plug>(easymotion-j)
map <Leader>es <Plug>(easymotion-k)
map <Leader>ec <Plug>(easymotion-linebackward)
map f <Plug>(easymotion-s2)
map è <Plug>(easymotion-t2)
" }}}
" {{{ ------------------------------------ Vim-Task
noremap <leader>m :call Toggle_task_status()<CR>
" }}}
" {{{ --------------------------------------- Gundo
noremap gu :GundoToggle<CR>
" }}}
" {{{ --------------------------------------- Slime
xmap <leader>ll <Plug>SlimeRegionSend
nmap <leader>ll <Plug>SlimeParagraphSend
nmap <leader>lv <Plug>SlimeConfig
" }}}
" {{{ ------------------------------------- NrrwRgn
noremap  <Leader>n :NarrowRegion<cr>
vnoremap <Leader>n :NarrowRegion<cr>
noremap  <Leader>N :NarrowRegion!<cr>
vnoremap <Leader>N :NarrowRegion!<cr>
" }}}
" {{{ ---------------------------- Ruby Refactoring
nnoremap <leader>rap  :RAddParameter<cr>
nnoremap <leader>rcpc :RConvertPostConditional<cr>
nnoremap <leader>rel  :RExtractLet<cr>
vnoremap <leader>rec  :RExtractConstant<cr>
vnoremap <leader>relv :RExtractLocalVariable<cr>
nnoremap <leader>rit  :RInlineTemp<cr>
vnoremap <leader>rrlv :RRenameLocalVariable<cr>
vnoremap <leader>rriv :RRenameInstanceVariable<cr>
vnoremap <leader>rem  :RExtractMethod<cr>
" }}}
" {{{ -------------------------------------- Switch
noremap -  :Switch<CR>
" }}}
" {{{ ------------------------------------------ Ag
noremap <Leader>a  :Ag! 
" }}}
" {{{ ----------------------------------- Command-T
noremap <Leader><Leader> :CommandT<CR>
" }}}
" {{{ ------------------------------------- Tabular
noremap  <Leader>t :Tabularize /
vnoremap <Leader>t :Tabularize /
" }}}
" {{{ ------------------------------------ Fugitive
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gdiff<CR>
noremap <Leader>gw :Gwrite<CR>
noremap <Leader>gr :Gread<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gs :Gstatus<CR>
" }}}
" {{{ ---------------------- Mercenary / Lawrencium
noremap <Leader>hb :HGblame<CR>
noremap <Leader>hd :HGdiff<CR>
noremap <leader>hh :Hg! 
noremap <Leader>hc :Hgcommit<CR>
noremap <Leader>hs :Hgstatus<CR>
noremap <Leader>hrr :Hg resolve -m %:p<CR>
noremap <Leader>hrl :Hg! resolve -l<CR>
" }}}
" {{{ ------------------------------------- Calcium
noremap <Leader>hl :Calcium<CR>
" }}}
" {{{ --------------------------------------- RSpec
" I'll care about that when the proper time comes
" map <Leader>rs :call RunCurrentSpecFile()<CR>
" map <Leader>rS :call RunLastSpec()<CR>
map <Leader>rs :SweetVimRspecRunFile<CR>
map <Leader>rS :SweetVimRspecRunPrevious<CR>
map <Leader>rl :SweetVimRspecRunFocused<CR>
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
" {{{ -------------------------------------- Splits
" Navigating between splits
noremap <S-s>  <C-w>k
noremap <S-t>  <C-w>j
noremap <S-c>  <C-w>h
noremap <S-r>  <C-w>l
" Creating new splits
noremap <Leader>v :vnew<Space>
noremap <Leader>V <C-w>v
noremap <Leader>s :new<Space>
noremap <Leader>S <C-w>s
" Resize splits
map <Up>    <C-w>+
map <Down>  <C-w>-
map <Left>  <C-w><
map <Right> <C-w>>
map <Leader>= <C-w>=
map <Leader>% :res<CR>:vertical res<CR>$
" }}}
" {{{ ---------------------------------------- Tabs
" noremap <silent> <Leader>n :tabnew<CR>
" }}}
" {{{ ------------------------------------ Movement
" Beginning / end of the line
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
imap <C-a> <C-o>^
imap <C-e> <C-o>$
nmap ç ^
vmap ç ^
" left / right / down (visual line) / up (visual line)
noremap c h
noremap r l
noremap t gj
noremap s gk
" move current line up or down
noremap <C-up>   :m-2<CR>
noremap <C-down> :m+<CR>
" Gathering selected lines (or current one if none selected) in one line
noremap <C-j> J
" Till (in place of t)
" noremap  è  t
" vnoremap è  t
" noremap  È  T
" vnoremap È  T
" Switching w for é (much saner spot)
noremap é w
noremap É W
onoremap aé aw
onoremap aÉ aW
onoremap ié iw
onoremap iÉ iW
vnoremap aé aw
vnoremap aÉ aW
vnoremap ié iw
vnoremap iÉ iW
" Mapping w to C-w
noremap  w <C-w>
vnoremap w <C-w>
onoremap w <C-w>
" Navigating tabs
noremap <C-d> gT
noremap <C-l> gt
" visual shifting (builtin-repeat)
nmap » >>_
nmap « <<_
vmap » >gv
vmap « <gv
" Don't make a # force column zero.
inoremap # X<BS>#
" Ctags
" noremap <C-w> :silent tab split<CR>:exec("tag ".expand("<cword>"))<CR>
noremap <C-t> <C-]>
noremap <C-r> <C-t>
" Center screen when scrolling search results
noremap n nzz
noremap N Nzz
noremap * *zz
noremap # #zz
" New line
inoremap <C-CR> <C-o>o
inoremap <S-CR> <C-o>O
" }}}
" {{{ ------------------------------ Mode Switching
" Save
noremap  <C-s> :w<CR>
vnoremap <C-s> <ESC>:w<CR>
inoremap <C-s> <ESC>:w<CR>
" Normal mode
noremap  <Space> :
vnoremap <C-c> <ESC>
inoremap <C-c> <ESC>
snoremap <C-c> <ESC>
" Change mode
noremap l c
" Exit
noremap  à :q<CR>
noremap  À :qa<CR>
" }}}
" {{{ ------------------------------------ Togglers
" Only
noremap <Leader>o :on<CR>
" Code folding toggle
" noremap <Space> :call ToggleFold()<CR>
" noremap <Leader>c :call ToggleFold()<CR>
" Swap 2 splits (only works within the same tab)
" noremap <Leader>e :call SplitSwap()<CR>
" Clear search
noremap <silent> h :let @/ = ""<CR>
" Search within visual selection
map <C-f> <Esc>/\%V
" Replace in visual selection
map <C-g> <ESC>:%s/\%V
" Spell checking
noremap <silent> <C-h> :set spell!<CR>
inoremap <silent> <C-h> <ESC>:set spell!<CR>
vnoremap <silent> <C-h> <ESC>:set spell!<CR>
" Toggle line wrap
noremap <Leader>w :set wrap!<CR>
noremap U :redo<CR>
" }}}
" }}}
