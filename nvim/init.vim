" vim:fdm=marker
" ------------------------------------------------------------------------------
" tlarrieu's nvimrc
" Designed for dvorak-bépo keyboard
" ------------------------------------------------------------------------------
set shell=/bin/bash
" {{{ ==| vim-plug |============================================================
call plug#begin()
" {{{ --| File Manipulation |--------------
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'rking/ag.vim'
Plug 'duggiefresh/vim-easydir'
Plug 'tlarrieu/vim-sniper'
" }}}
" {{{ --| Encryption |---------------------
Plug 'jamessan/vim-gnupg'
" }}}
" {{{ --| Functionnalities |---------------
Plug 'AndrewRadev/linediff.vim'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'kassio/neoterm'
Plug 'tpope/vim-vinegar'
Plug 'diepm/vim-rest-console'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'sunaku/vim-dasht'
" }}}
" {{{ --| Snippets |-----------------------
Plug 'SirVer/ultisnips'
" }}}
" {{{ --| Project config |-----------------
Plug 'tpope/vim-projectionist'
" }}}
" {{{ --| Text manipulation |--------------
Plug 'AndrewRadev/switch.vim'
Plug 'edsono/vim-matchit'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular', { 'on' : 'Tabular' }
Plug 'FooSoft/vim-argwrap'
" }}}
" {{{ --| Text objects |-------------------
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nelstrom/vim-textobj-rubyblock',
  \ { 'for' : [ 'ruby', 'eruby', 'rspec', 'rake', 'elixir' ] }
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
" {{{ --| Git |----------------------------
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
" }}}
" {{{ --| Syntax checking |----------------
Plug 'neomake/neomake'
" }}}
" }}}
" {{{ --| Task manager |-------------------
Plug 'samsonw/vim-task', { 'for' : [ 'task', 'tasks' ] }
" }}}
" {{{ --| List toggler |-------------------
Plug 'milkypostman/vim-togglelist'
" }}}
" {{{ --| Ruby |---------------------------
Plug 'tpope/vim-rails'
" }}}
" {{{ --| Elixir |-------------------------
Plug 'slashmili/alchemist.vim'
" }}}
" {{{ --| SQL |----------------------------
Plug 'krisajenkins/vim-postgresql-syntax'
" }}}
" {{{ --| Misc languages support |---------
Plug 'chrisbra/csv.vim', { 'for' : 'csv' }
Plug 'sheerun/vim-polyglot'
" }}}
" {{{ --| Good looking |-------------------
Plug 'itchyny/lightline.vim'
Plug 'blueyed/vim-diminactive'
Plug 'altercation/vim-colors-solarized'
Plug 'gcmt/taboo.vim'
Plug 'kshenoy/vim-signature'
" }}}
call plug#end()
" }}}
" {{{ ==| File Related |========================================================
augroup vimrc_autocmd
  autocmd!
  autocmd FileType html,eruby setlocal foldlevel=10
  autocmd FileType html setlocal foldmethod=syntax
  autocmd FileType html setlocal foldminlines=1
  autocmd BufReadPost *.diag setfiletype seqdiag
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
augroup END

augroup NoSimultaneousEdits
  autocmd!
  autocmd SwapExists * let v:swapchoice = 'o'
  autocmd SwapExists * echomsg 'Duplicate edit session (readonly)'
  autocmd SwapExists * echohl None
  autocmd SwapExists * sleep 1
augroup END
" }}}
" {{{ ==| General options |=====================================================
" Pipe shaped cursor in insert mode
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
" True colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" Leader
let g:mapleader="\<space>"
" Avoiding moving cursor when hitting <space> followed by nothing
map <space> <nop>
" Timeout
set nottimeout
" Always display tabline
set showtabline=2
" Do not display mode
set noshowmode
" Color / background theme
set background=light
colorscheme solarized
" Line numbering (relative and current)
set relativenumber
set number
" Blank character
set listchars=tab:\›\ ,trail:·,nbsp:¬,extends:»,precedes:«
" Display blank characters
set list
" Show incomplete key sequence in bottom corner
set showcmd
" Encoding and filetype
set fileformats=unix,dos,mac
" Undo, backup and swap files
set undodir=~/.tmp//
set backupdir=~/.tmp//
set directory=~/.tmp//
" Activate undofile, that holds undo history
set undofile
" Ignore those files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,tags
" Case insensitive matching
set wildignorecase
" ctags
set tags=.tags,./.tags,./tags,tags
" mouse
set mouse=a
" Command completion style
set wildmode=list:full,full
set complete=.,w,b,u,t,i
" Bells
set novisualbell
set noerrorbells
" Allow a modified buffer to be sent to background without saving it
set hidden
" Set title when in console
set title
" Disable line wrap
set nowrap
" Line wrap at word boundaries
set linebreak
" Indent soft-wrapped lines
set breakindent
" Define character indicating line wrap
set showbreak=↪\ 
" Do not insert spaces after '.', '?' and '!' when joining lines
set nojoinspaces
" Do not redraw screen while running macros
set lazyredraw
" Update time
set updatetime=250
" Change netrw list style
let g:netrw_liststyle=1
" }}}
" {{{ ==| Splits |==============================================================
set splitright
set splitbelow
set fillchars+=vert:\ 
" }}}
" {{{ ==| Scrolling |===========================================================
set scrolloff=8
let &scrolloff=999-&scrolloff
set sidescrolloff=15
set sidescroll=1
" }}}
" {{{ ==| Indent |==============================================================
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set shiftround
" }}}
" {{{ ==| Folding |=============================================================
set foldcolumn=0
set foldclose=
set foldmethod=indent
set foldnestmax=3
set foldlevelstart=10
set fillchars+=fold: 
set foldminlines=1
set foldtext=FoldText()
nmap <leader>z zMzv
nnoremap <leader>Z zR
nnoremap zO zczO
" }}}
" {{{ ==| Searching |===========================================================
" case behavior regarding searching
set ignorecase
set smartcase
" }}}
" {{{ ==| Spellchecking |=======================================================
set spelllang=en,fr
" }}}
" {{{ ==| Plugins |=============================================================
" {{{ --| Neoterm |-----------------------------------------
nmap <silent> <leader><tab> :call neoterm#toggle()<cr>
" }}}
" {{{ --| Deoplete |----------------------------------------
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#tag#cache_limit_size = 600000
let g:deoplete#auto_complete_start_length = 1
call deoplete#custom#set('_', 'matchers', ['matcher_fuzzy'])
inoremap <silent> <cr> <C-r>=<SID>deoplete_cr()<cr>
function! s:deoplete_cr() abort
  return deoplete#close_popup() . "\<cr>"
endfunction
" }}}
" {{{ --| Rails |-------------------------------------------
vmap <leader>x :Rextract<space>
" }}}
" {{{ --| GitGutter |---------------------------------------
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_column_always = 1
nmap <expr> ß &diff ? '[c' : '<Plug>GitGutterPrevHunk'
nmap <expr> þ &diff ? ']c' : '<Plug>GitGutterNextHunk'
" }}}
" {{{ --| Dasht |-------------------------------------------
nnoremap <leader>K :Dasht<space>
nnoremap <silent> K :call Dasht(expand('<cword>'))<cr>
vnoremap <silent> K y:<c-u>call Dasht(getreg(0))<cr>
" }}}
" {{{ --| VimRestClient |-----------------------------------
let g:vrc_max_time = 5
let g:vrc_set_default_mapping = 0
augroup VimRestClient
  autocmd!
  autocmd FileType rest nmap <buffer> <return> :call VrcQuery()<cr>
augroup END
" }}}
" {{{ --| Diminactive |-------------------------------------
let g:diminactive_buftype_blacklist = []
let g:diminactive_use_colorcolumn = 1
let g:diminactive_use_syntax = 0
" }}}
" {{{ --| Sniper |------------------------------------------
vmap <cr> :<c-u>call Snipe('vnew')<cr>
" }}}
" {{{ --| ArgWrap |-----------------------------------------
nnoremap <silent> <leader>; :ArgWrap<CR>
" }}}
" {{{ --| FZF |---------------------------------------------
let $FZF_DEFAULT_COMMAND = "ag -g '' --hidden --ignore .git"

" Standard mode (file list)
nmap <silent> <c-t> :FZF -m -e<cr>
" Custom modes (home made funcctions)
nnoremap <silent> <c-b> :FZFbuf<cr>
nnoremap <c-e> :FZFsearch<space>
nnoremap <silent> <c-c> :FZFtags tag<cr>
nnoremap <silent> <c-l> :FZFtags tag<cr>
nnoremap <silent> <c-y> :FZFGitFiles<cr>
" }}}
" {{{ --| Neomake |-----------------------------------------
augroup Neomake
  autocmd!
  autocmd BufWritePost * Neomake
augroup END
let g:neomake_warning_sign = {
  \ 'text': '×',
  \ 'texthl': 'DiffChange',
  \ }
let g:neomake_error_sign = {
  \ 'text': '✖',
  \ 'texthl': 'DiffDelete',
  \ }
let g:neomake_vint_maker = {
  \ 'exe': 'vint',
  \ 'args': ['%:p'],
  \ }
" }}}
" {{{ --| Surround |----------------------------------------
let g:surround_no_insert_mappings = 1
let g:surround_35 = "<%# \r %>"
let g:surround_37 = "<% \r %>"
let g:surround_61 = "<%= \r %>"
" }}}
" {{{ --| Tabular |-----------------------------------------
vmap <leader>t :Tabular /
" }}}
" {{{ --| Thesaurus |---------------------------------------
nnoremap gh :OnlineThesaurusCurrentWord<CR>
nnoremap gH :Thesaurus<space>
" }}}
" {{{ --| Signature |---------------------------------------
let g:SignatureMap = {
  \ 'Leader'            : 'm',
  \ 'PlaceNextMark'     : '',
  \ 'ToggleMarkAtLine'  : '',
  \ 'PurgeMarksAtLine'  : '',
  \ 'PurgeMarks'        : '',
  \ 'PurgeMarkers'      : '',
  \ 'GotoNextLineAlpha' : '',
  \ 'GotoPrevLineAlpha' : '',
  \ 'GotoNextSpotAlpha' : '',
  \ 'GotoPrevSpotAlpha' : '',
  \ 'GotoNextLineByPos' : '',
  \ 'GotoPrevLineByPos' : '',
  \ 'GotoNextSpotByPos' : '',
  \ 'GotoPrevSpotByPos' : '',
  \ 'GotoNextMarker'    : '',
  \ 'GotoPrevMarker'    : '',
  \ 'GotoNextMarkerAny' : '',
  \ 'GotoPrevMarkerAny' : '',
  \ 'ListLocalMarks'    : ''
  \ }
" }}}
" {{{ --| Targets |-----------------------------------------
let g:targets_pairs = '()b {}é []d <>É'
let g:targets_argTrigger = 'c'
" By default, we want to delete only the ACTUAL parameter
" Not the whitespaces around it
omap ic Ic
let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
" }}}
" {{{ --| Ag |----------------------------------------------
let g:ag_apply_qmappings = 0
let g:ag_apply_lmappings = 0
let g:ag_prg = 'ag --vimgrep'
set grepformat=%f:%l:%c:%m
" }}}
" {{{ --| UltiSnips |---------------------------------------
let g:UltiSnipsRemoveSelectModeMappings = 1
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsSnippetsDir='~/.config/nvim/UltiSnips'
" }}}
" {{{ --| Taboo |-------------------------------------------
let g:taboo_tab_format = '%N %f%m'
let g:taboo_renamed_tab_format = '%N (%l)%m'
let g:taboo_modified_tab_flag = ' ∙'
let g:taboo_unnamed_tab_label = '…'
" deactivate tabline generation (we want to let lightline do it)
let g:taboo_tabline = 0
nmap <leader>tl :TabooRename<space>
nmap <leader>tr :TabooReset<cr>
" }}}
" {{{ --| Fugitive |----------------------------------------
nmap <leader>a :Gcommit --amend<cr>
nmap <leader>b :Gblame<cr>
nmap <leader>c :Gcommit<cr>
nmap <leader>d :Gvdiff<cr>
nmap <leader>D :Gvdiff develop<cr>
nmap <leader>r :Gread<cr>
nmap <leader>s :Gstatus<cr>
nmap <leader>S :GV<cr>
nmap <leader>f :Gfetch<space>
nmap <leader>w :Gwrite<cr>
" }}}
" {{{ --| Linediff |----------------------------------------
vmap <leader>d :Linediff<cr>
" }}}
" }}}
" {{{ ==| Various keyboard mapping |============================================
" {{{ --| Splits / Tabs |-----------------------------------
nnoremap co :tabo<cr>
nnoremap cO :tabo<cr><c-w>o
" Hack to make <c-w><c-c> mapping work
noremap <c-w><c-c> <c-w>H
noremap <c-w><c-t> <c-w>J
noremap <c-w><c-s> <c-w>K
noremap <c-w><c-r> <c-w>L
" Horizontal Split
nmap <leader>nn :new<cr>
nmap <leader>ne :new <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
" Vertical split
nmap <leader>vv :vnew<cr>
nmap <leader>ve :vnew <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
" Dimensions
nmap <leader>= <c-w>=
nmap <leader>% :res<cr>:vertical res<cr>
nnoremap <c-right> <c-w>>
nnoremap <c-left> <c-w><
nnoremap <c-up> <c-w>-
nnoremap <c-down> <c-w>+
" Moving around
nmap <tab> <c-w>w
nmap <s-tab> <c-w>W
nmap <c-n> gt
nmap <c-p> gT
" New tab
nmap <leader>tt :tabe<cr>
nmap <leader>te :tabe <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
" Move current tab
nmap <leader>tm :tabm<space>
" Direct tab access
nnoremap <leader>" 1gt
nnoremap <leader>« 2gt
nnoremap <leader>» 3gt
nnoremap <leader>( 4gt
nnoremap <leader>) 5gt
nnoremap <leader>@ 6gt
nnoremap <leader>+ 7gt
nnoremap <leader>- 8gt
nnoremap <leader>/ 9gt

nmap <leader>U <c-w>T
nmap <leader>u :call MergeTabs()<cr>
" }}}
" {{{ --| Terminal |----------------------------------------
tnoremap <c-s> <c-\><c-n>

nmap <silent> <leader>ti :tabnew<bar>terminal<cr>
nmap <silent> <leader>tr :tabnew<bar>terminal rails c<cr>
nmap <silent> <leader>vi :vertical new<bar>terminal<cr>
nmap <silent> <leader>vr :vertical new<bar>terminal rails c<cr>
nmap <silent> <leader>ni :new<bar>terminal<cr>
nmap <silent> <leader>nr :new<bar>terminal rails c<cr>
nmap <leader>tu :tabnew<bar>terminal<space>
nmap <leader>vu :vsplit<bar>terminal<space>
" }}}
" {{{ --| Movement |----------------------------------------
" Marks
noremap ' `
noremap ` '
noremap <silent> <leader>m :delmarks!<cr>
" Command line / Search
cmap <c-t> <down>
cmap <c-s> <up>
" Beginning / end of the line
inoremap <c-a> <c-o>^
cnoremap <c-a> <home>
inoremap <c-e> <c-o>$
cnoremap <c-e> <end>
map ç ^
" Split lines
noremap <c-j> i<cr><esc>
" Don't make a # force column zero.
inoremap # X<bs>#
" Fuck you, help.
nnoremap <F1> <nop>
inoremap <F1> <nop>
" Clever paste from system buffer
nmap <leader>p m`:set paste<cr>o<c-r>+<esc>:set nopaste<cr>``
nmap <leader>P m`:set paste<cr>O<c-r>+<esc>:set nopaste<cr>``
noremap <leader>y "+y
nnoremap yf :<c-u>let @+ = expand("%")<cr>:echo 'File name yanked.'<cr>
" Give a more logical behavior to Y
nnoremap Y y$
" Visual yank
vnoremap y ygv<esc>
vnoremap Y Ygv<esc>
" select the whole line
nnoremap vv ^v$h
" Command line
map è :
map È :!
" Find character
noremap , ;
noremap ; ,
" }}}
" {{{ --| Mode Switching |----------------------------------
" Close current buffer
map Q :bdelete!<cr>
" Normal mode
set noesckeys
cmap <esc> <c-c>
" Exit
nnoremap à :confirm quit<cr>
nnoremap À :confirm quitall<cr>
" Save
nmap <c-s> :update<cr>
imap <c-s> <esc>:update<cr>
" Reselect pasted lines
nnoremap gV `[v`]
" Command line
map è :
map È :!
" }}}
" {{{ --| Togglers |----------------------------------------
" Rename file
command! RenameFile :call RenameFile()
command! RF :call RenameFile()
" Toggle highlight current word
nmap <leader>' :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
" Uppercase current word
nmap <c-g> gUiw
imap <c-g> <esc>lgUiwea
" Clear trailing spaces (but not the escaped ones)
function! ClearTrailingSpaces()
  let l:_s=@/
  %s/\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)//e
  let @/=l:_s
  nohl
endfunction
nmap <silent> <leader>k m`:call ClearTrailingSpaces()<cr>g``
" Fix indent
nmap <silent> ga m`gg=G:call ClearTrailingSpaces()<cr>g``
" Cursorline / Cursorcolumn
let g:virtualedit=''
function! AlignMode()
  if g:virtualedit
    let g:virtualedit=0
    set virtualedit=""
  else
    let g:virtualedit=1
    set virtualedit=all
  endif
  set cursorcolumn!
  set cursorline!
endfunction
nmap <leader>g :call AlignMode()<cr>
" Quickfix / Location list
nmap <silent> <leader>q :call ToggleQuickfixList()<cr>
nmap <silent> <leader>l :call ToggleLocationList()<cr>
" }}}
" {{{ --| Swap number line |--------------------------------
" It is more convenient to access numbers directly when in normal mode
noremap " 1
noremap 1 "
noremap « 2
noremap 2 <<_
vnoremap 2 <gv
noremap » 3
noremap 3 >>_
vnoremap 3 >gv
noremap ( 4
noremap 4 (
noremap ) 5
noremap 5 )
noremap @ 6
noremap <leader>, @q
noremap 6 @
noremap + 7
noremap 7 :GitGutterStageHunk<cr>
noremap - 8
noremap 8 :GitGutterUndoHunk<cr>
noremap / 9
noremap 9 /
noremap * 0
noremap 0 *
" }}}
" {{{ --| Search & Replace |--------------------------------
noremap é /
noremap <silent> É :nohlsearch<cr><c-l>

nmap <silent> <leader>é :set operatorfunc=UsageOperator<cr>g@iw
vmap <silent> <leader>é :<c-u>call UsageOperator(visualmode())<cr>
nmap <silent> <leader>É :set operatorfunc=DefinitionOperator<cr>g@iw

nmap s :s/
nmap S :%s/
vmap s <esc>:%s/\%V/g<left><left>

nmap <A-n> :cnext<cr>
nmap <A-p> :cprev<cr>

command! NONASCII /[^\x00-\x7F]
" }}}
" {{{ --| Quick Editing |-----------------------------------
function! OpenSchemaFile()
  if filereadable('db/structure.sql')
    tabe db/structure.sql
  else
    tabe db/schema.rb
  endif
endfunction

nmap <leader>es :call OpenSchemaFile()<cr>

nmap <leader>ea :tabedit ~/httpclient.rest<cr>
nmap <leader>ee :tabedit ~/email.md<cr>
nmap <leader>ef :tabedit ~/.config/fish/config.fish<cr>
nmap <leader>eg :tabedit ~/.gitconfig<cr>
nmap <leader>eh :tabedit ~/.hgrc<cr>
nmap <leader>em :tabedit ~/.tmux.conf<cr>
nmap <leader>eo :tabedit ~/poi.md<cr>
nmap <leader>ep :tabedit ~/postgres.sql<cr>
nmap <leader>eq :tabedit ~/sqlite.sql<cr>
nmap <leader>er :tabedit ~/release.tasks<cr>
nmap <leader>et :tabedit ~/todo.tasks<cr>
nmap <leader>ev :tabedit ~/.config/nvim/init.vim<cr>
nmap <leader>eu :UltiSnipsEdit

nmap <leader>. :Lexplore .<cr>

nmap <leader># :e #<cr>

" Source init.vim and reload ftplugins
nmap <silent> <leader>$ :source ~/.config/nvim/init.vim<bar>let &filetype=&filetype<cr>
" }}}
" {{{ --| Convenience Mapping |-----------------------------
vmap <leader>s :sort<cr>

noremap <silent> <leader><leader> @q
" }}}
" }}}
