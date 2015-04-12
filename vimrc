" vim:fdm=marker
" ------------------------------------------------------------------------------
" tlarrieu's vimrc
" Designed for dvorak-bépo keyboard
" ------------------------------------------------------------------------------
set shell=/bin/bash
let $PAGER=''
let g:ruby_path = system('rvm current')
" {{{ == | vim-plug | ==========================================================
set nocompatible

call plug#begin('~/.vim/plugged')

" -- | File Manipulation | ------------
Plug 'kien/ctrlp.vim'
Plug 'rking/ag.vim'
Plug 'skwp/greplace.vim', { 'on' : [ 'Greplace', 'Gqfopen' ] }
Plug 'duggiefresh/vim-easydir'
" -- | Functionnalities | -------------
Plug 'tpope/vim-dispatch'
Plug 'beloglazov/vim-online-thesaurus'
" -- | Snippets | ---------------------
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" -- | Project config | ---------------
Plug 'tpope/vim-projectionist'
" -- | Text manipulation | ------------
Plug 'AndrewRadev/switch.vim'
Plug 'tpope/vim-commentary'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'edsono/vim-matchit'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular', { 'for' : 'markdown' }
" -- | Text objects | -----------------
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nelstrom/vim-textobj-rubyblock',
      \ { 'for' : [ 'ruby', 'eruby', 'rspec', 'rake' ] }
Plug 'wellle/targets.vim'
Plug 'tommcdo/vim-exchange'
Plug 'kana/vim-textobj-function'
" -- | Task manager | -----------------
Plug 'samsonw/vim-task', { 'for' : [ 'task', 'tasks' ] }
" -- | Undo tree explorer | -----------
" Plug 'sjl/gundo.vim'
" -- | List toggler | -----------------
Plug 'milkypostman/vim-togglelist'
" -- | Ruby | -------------------------
Plug 'janko-m/vim-test'
Plug 'vim-ruby/vim-ruby', { 'for' : 'ruby' }
Plug 'Keithbsmiley/rspec.vim', { 'for' : 'ruby' }
Plug 'jbgutierrez/vim-partial'
" Plug 'tpope/vim-rails'
" -- | HTML | -------------------------
Plug 'mattn/emmet-vim', { 'for' : [ 'html', 'eruby', 'sass', 'css'] }
" -- | Haskell | ----------------------
Plug 'twinside/vim-syntax-haskell-cabal', { 'for' : 'haskell' }
Plug 'bitc/vim-hdevtools', { 'for' : 'haskell' }
" -- | Go lang | ----------------------
Plug 'fatih/vim-go', { 'for' : 'go' }
" -- | SQL | --------------------------
Plug 'ivalkeen/vim-simpledb', { 'for' : 'sql' }
Plug 'exu/pgsql.vim', { 'for' : 'sql' }
" -- | Markdown | ---------------------
Plug 'gabrielelana/vim-markdown', { 'for' : 'markdown' }
Plug 'greyblake/vim-preview', { 'for' : 'markdown' }
" -- | Misc languages support | -------
Plug 'vim-scripts/fish-syntax', { 'for' : 'fish' }
Plug 'roalddevries/yaml.vim', { 'for' : 'yaml' }
Plug 'lmeijvogel/vim-yaml-helper', { 'for' : 'yaml' }
Plug 'jelera/vim-javascript-syntax', { 'for' : 'javascript' }
Plug 'kchmck/vim-coffee-script', { 'for' : 'coffee' }
Plug 'chrisbra/csv.vim', { 'for' : 'csv' }
" Plug 'tpope/vim-haml'
" -- | VCS | --------------------------
Plug 'tpope/vim-fugitive'
Plug 'phleet/vim-mercenary'
Plug 'zeekay/vim-lawrencium'
Plug 'mhinz/vim-signify'
" -- | Syntax checking | --------------
Plug 'scrooloose/syntastic'
" -- | Good looking | -----------------
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'gcmt/taboo.vim'
Plug 'kshenoy/vim-signature'
Plug 'sjl/vitality.vim'
" -- | Colors | -----------------------
Plug 'KabbAmine/vCoolor.vim'              " Picker
Plug 'chrisbra/Colorizer'                 " Highlighter

call plug#end()

" Force loading of solarized before everything else so we can override
" a few things without using BufPostRead / BufEnter shenanigans
runtime! ~/.vim/plugged/vim-colors-solarized/colors/solarized.vim

filetype on
syntax on
filetype plugin indent on
" }}}
" {{{ == | File Related | ======================================================
augroup vimrc_autocmd
  autocmd!
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  autocmd FileType ruby set makeprg=ruby\ %
  autocmd BufReadPost *.arb setf ruby
  autocmd BufReadPost COMMIT_EDITMSG startinsert!
  autocmd FileType vim setlocal foldlevel=10
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldminlines=1
  autocmd FileType html,eruby setlocal foldlevel=10
  autocmd FileType html setlocal foldmethod=syntax
  autocmd FileType html setlocal foldminlines=1
  autocmd BufReadPost *.yml set ft=yaml
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

augroup NoSimultaneousEdits
  autocmd!
  autocmd SwapExists * let v:swapchoice = 'o'
  autocmd SwapExists * echomsg 'Duplicate edit session (readonly)'
  autocmd SwapExists * echohl None
  autocmd SwapExists * sleep 1
augroup END
" }}}
" {{{ == | General options | ===================================================
let mapleader="\<space>"
" Avoiding moving cursor when hitting <space> followod by nothing
map <space> <nop>
" Timeout
set ttimeout
set ttimeoutlen=100
" History
set history=500
" Color / background theme
set background=light
colorscheme solarized
if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h16
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r
  set guioptions-=R
  set guioptions-=b
  set guioptions-=T
  set guioptions-=m

  " mode aware cursors
  set gcr+=o:hor50-Cursor
  set gcr-=n:NormalCursor
  set gcr+=i-ci-sm:InsertCursor
  set gcr+=r-cr:ReplaceCursor-hor20
  set gcr+=c:CommandCursor
  set gcr+=v-ve:VisualCursor
  set gcr+=a:blinkon0

  hi! NormalCursor  term=reverse cterm=reverse
        \ gui=reverse guifg=#93a1a1 guibg=#fdf6e3
  hi! InsertCursor  ctermfg=15 guifg=#fdf6e3 ctermbg=37  guibg=#2aa198
  hi! VisualCursor  term=reverse gui=reverse guifg=#268bd2
  hi! ReplaceCursor ctermfg=15 guifg=#fdf6e3 ctermbg=65  guibg=#d33682
  hi! CommandCursor term=standout cterm=reverse ctermfg=5 ctermbg=7
        \ gui=standout guifg=#d33682
elseif &term =~ "xterm\\|rxvt"
  let &t_SI = "\<Esc>]12;#2aa198\x7" " Insert mode
  let &t_EI = "\<Esc>]12;#839496\x7" " Normal mode
endif

hi! Visual ctermfg=7 ctermbg=14
      \ gui=bold guifg=#93a1a1 guibg=#eee8d5 guisp=#268bd2

hi! link SignColumn LineNr
" Line numbering (relative and current)
set rnu
set nu
" Line length warning (disabled for now)
highlight OverLength ctermbg=red ctermfg=black guibg=red guifg=black
augroup overlength
  au!
  autocmd FileType man hi! link OverLength Normal
augroup END
match OverLength /\%81v.\+/
" Virtual editing
set virtualedit=all
" Blank character
set lcs=tab:\›\ ,trail:·,nbsp:¬,extends:»,precedes:«
set showbreak=↪\ 
set list
" Show matching braces
set showmatch
" Show command
set showcmd
" Encoding and filetype
set encoding=utf8
set ffs=unix,dos,mac
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
" current line / column highlight
set cursorline
set cursorcolumn
" mouse
set mouse=c
" Command completion style
set wildmode=list:full,full
" Only complete to the GCD part of file name
set wildmenu
" set complete=slf
set complete=.,w,b,u,t,i
" Bells
set novisualbell
set noerrorbells
" Allow a modified buffer to be sent to background without saving it
set hidden
" Set title when in console
set title
" Give backspace a reasonable behavior
set backspace=indent,eol,start
" Disable line wrap
set nowrap
" Do not redraw screen while running macros
set lazyredraw
" Improve redrawing
set ttyfast
" }}}
" {{{ == | Splits | ============================================================
hi! link VertSplit CursorColumn
set splitright
set splitbelow
" }}}
" {{{ == | Scrolling | =========================================================
set scrolloff=8
let &scrolloff=999-&scrolloff
set sidescrolloff=15
set sidescroll=1
" }}}
" {{{ == | Indent | ============================================================
set ai "autoindent
set si "smart indent
set tabstop=2
set shiftwidth=2
set expandtab
set shiftround
" }}}
" {{{ == | Folding | ===========================================================
set foldcolumn=0
set foldclose=
set foldmethod=indent
set foldnestmax=3
set foldlevelstart=10
set fillchars+=fold: 
set foldminlines=1
set foldtext=FoldText()
nnoremap <leader>z zMzv
nnoremap zO zczO
" }}}
" {{{ == | Searching | =========================================================
" case behavior regarding searching
set ignorecase
set smartcase
" some more search related stuff
set hlsearch  " highlight search
set incsearch " start search while typing
hi! Search ctermbg=7 ctermfg=2 guifg=#719e07
hi! IncSearch ctermbg=7 ctermfg=5 guifg=#d33682
hi! IncSearchMatch ctermbg=7 ctermfg=5 cterm=reverse guibg=#d33682 guifg=#ffffff

command! NONASCII /[^\x00-\x7F]
command! B bufdo bd
" }}}
" {{{ == | Spellchecking | =====================================================
set spelllang=en,fr
" }}}
" {{{ == | Plugins | ===========================================================
" {{{ -- | Thesaurus | -------------------------------------
nnoremap gh :OnlineThesaurusCurrentWord<CR>
nnoremap gH :Thesaurus<space>
" }}}
" {{{ -- | Emmet | -----------------------------------------
let g:user_emmet_leader_key=','
let g:use_emmet_complete_tag = 1
let g:user_emmet_settings = {
  \   'indentation' : '  '
  \ }
" }}}
" {{{ -- | SimpleDB | --------------------------------------
let g:sql_type_default = 'mysql'
let g:omni_sql_no_default_maps = 1
augroup SQL
  autocmd!
  autocmd BufRead vim-simpledb-result.txt setf sql
augroup end
" }}}
" {{{ -- | Signature | -------------------------------------
let g:SignatureMap = {
  \ 'Leader'             :  "m",
  \ 'PlaceNextMark'      :  "m,",
  \ 'ToggleMarkAtLine'   :  "m.",
  \ 'PurgeMarksAtLine'   :  "m-",
  \ 'PurgeMarks'         :  "m<Space>",
  \ 'PurgeMarkers'       :  "m<BS>",
  \ 'GotoNextLineAlpha'  :  "",
  \ 'GotoPrevLineAlpha'  :  "",
  \ 'GotoNextSpotAlpha'  :  "",
  \ 'GotoPrevSpotAlpha'  :  "",
  \ 'GotoNextLineByPos'  :  "",
  \ 'GotoPrevLineByPos'  :  "",
  \ 'GotoNextSpotByPos'  :  "",
  \ 'GotoPrevSpotByPos'  :  "",
  \ 'GotoNextMarker'     :  "",
  \ 'GotoPrevMarker'     :  "",
  \ 'GotoNextMarkerAny'  :  "",
  \ 'GotoPrevMarkerAny'  :  "",
  \ 'ListLocalMarks'     :  ""
  \ }
" }}}
" {{{ -- | vCoolor | ---------------------------------------
noremap <leader>C :<c-u>VCoolor<cr>
noremap <leader>c :ColorToggle<cr>
" }}}
" {{{ -- | endwise | ---------------------------------------
autocmd FileType elixir
  \ let b:endwise_addition = 'end' |
  \ let b:endwise_words = 'do' |
  \ let b:endwise_pattern = '\<do\ze\s*$' |
  \ let b:endwise_syngroups = 'elixirKeyword'
" }}}
" {{{ -- | YAML | ------------------------------------------
augroup yaml
  au!
  autocmd FileType yaml nnoremap <buffer> 6 :YamlGoToKey<space>
  autocmd FileType yaml nnoremap <buffer> 7 :YamlGoToParent<cr>
  autocmd FileType yaml nnoremap <buffer> 8 :YamlGetFullPath<cr>
augroup end
" }}}
" {{{ -- | ToggleList | ------------------------------------
 let g:toggle_list_copen_command="copen"
" }}}
" {{{ -- | Disptach | --------------------------------------
nnoremap <leader>f :Dispatch<cr>
nnoremap <leader>F :<c-u>Focus  %<left><left>
" }}}
" {{{ -- | vim-test | --------------------------------------
let g:test#strategy = 'dispatch'
" }}}
" {{{ -- | Targets | ---------------------------------------
let g:targets_pairs = '()b {}é []d <>É'
let g:targets_argTrigger = 'c'
" By default, we want to delete only the ACTUAL parameter
" Not the whitespaces around it
omap ic Ic
let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
" }}}
" {{{ -- | Syntastic | -------------------------------------
let g:syntastic_javascript_checkers = ['jsl']
let g:syntastic_ruby_checkers = ['mri']
let g:syntastic_javascript_ruboconf_conf = "~/.rubocop.yml"
let g:syntastic_ruby_rubocop_args = '-D'
let g:syntastic_haskell_checkers = ['hdevtools', 'hlint']
augroup lint
  au!
  au FileType ruby noremap <buffer> <leader>L :SyntasticCheck rubocop<cr>
  au FileType scss noremap <buffer> <leader>L :SyntasticCheck scss_lint<cr>
augroup end
" }}}
" {{{ -- | Greplace | --------------------------------------
set grepprg=ag\ --line-numbers\ --noheading
nnoremap <leader>A :Gqfopen<cr>
nnoremap <leader>R :Greplace<cr>
" }}}
" {{{ -- | Ag | --------------------------------------------
let g:ag_apply_qmappings = 0
let g:ag_apply_lmappings = 0
let g:ag_prg = "ag --column --line-numbers --noheading --smart-case"

augroup Ag
  autocmd!
  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <nl> <C-W><CR><C-W>T
  autocmd BufReadPost quickfix nnoremap <silent> <buffer>   <C-W><CR><C-W>T
  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <c-cr> <C-W><CR><C-W>T
  autocmd BufReadPost quickfix
        \ nnoremap <silent> <buffer> <C-v> <C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t
  autocmd BufReadPost quickfix
        \ nnoremap <silent> <buffer> <C-x> <C-W><CR><C-w>K

  autocmd BufReadPost quickfix setlocal nonu
augroup END

nnoremap <leader>a :Ag! ""<left>
nnoremap yu :set operatorfunc=UsageOperator<cr>g@iw
vnoremap yu :<c-u>call UsageOperator(visualmode())<cr>
nnoremap yd :set operatorfunc=DefinitionOperator<cr>g@iw

augroup quickfix
  au!
  au FileType qf call AdjustWindowHeight(3, 20)
augroup END
" }}}
" {{{ -- | UltiSnips | -------------------------------------
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsJumpForwardTrigger="<c-t>"
let g:UltiSnipsJumpBackwardTrigger="<c-s>"
" }}}
" {{{ -- | Taboo | -----------------------------------------
nmap <leader>tl :TabooRename<space>
nmap <leader>tr :TabooReset<cr>
let g:taboo_tab_format =  "%f%m"
let g:taboo_renamed_tab_format =  "(%l)%m"
let g:taboo_modified_tab_flag = "+"
let g:taboo_unnamed_tab_label = "…"
let g:taboo_tabline = 0
" }}}
" {{{ -- | Airline | ---------------------------------------
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
set noshowmode " Hide mode text (e.g. -- INSERT -- below the statusline)

let g:airline_theme = 'zenburn'
let g:airline_powerline_fonts = 1
let g:airline_inactive_collapse=0

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#fnamemod = ':t:.'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_close_button = 0

let g:airline_mode_map = {
  \ '__' : '-',
  \ 'n'  : 'NOR',
  \ 'i'  : 'INS',
  \ 'R'  : 'REP',
  \ 'c'  : 'CHA',
  \ 'v'  : 'VIS',
  \ 'V'  : 'L-VIS',
  \ '' : 'B-VIS',
  \ 's'  : 'SEL',
  \ 'S'  : 'L-SEL',
  \ '' : 'B-SEL',
  \ }
" }}}
" {{{ -- | CtrlP | -----------------------------------------
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'ET'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:40'
let g:ctrlp_open_new_file = 't'
if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
map <leader><leader> :CtrlPBufTag<cr>
map <leader>; :CtrlPTag<cr>
nmap <backspace> :<c-u>CtrlPClearCache<cr>
let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")':   ['<c-t>', '<down>'],
  \ 'PrtSelectMove("k")':   ['<c-s>', '<up>'],
  \ 'AcceptSelection("h")': ['<c-x>'],
  \ 'AcceptSelection("t")': ['<c-cr>', '<nl>', '<c-j>', ' '],
  \ }
hi! CtrlPMatch ctermfg=5 guifg=#d33682
" }}}
" {{{ -- | Signify | ---------------------------------------
let g:signify_vcs_list = [ 'hg', 'git' ]
let g:signify_update_on_focusgained = 1
" }}}
" {{{ -- | Fugitive / Mercenary / Lawrencium | -------------
function! HgBranchStatus()
  silent tabnew /dev/null
  normal ggdG
  0read !hg status --rev "::. - ::default" -n
  silent :w
endfunction

function! SwitchVCS()
  if g:next_vcs ==# 'mercurial'
    noremap <leader>S :call HgBranchStatus()<cr>
    noremap <leader>s :Hgstatus<cr>
    noremap <leader>D :HGdiff ancestor(default,.)<cr>
    noremap <leader>b :HGblame<cr>
    noremap <leader>d :HGdiff<cr>
    noremap <leader>r :Hgrevert!<cr>:e<cr>
    let g:next_vcs = 'git'
  else
    noremap <leader>b :Gblame<cr>
    noremap <leader>d :Gvdiff<cr>
    noremap <leader>r :Gread<cr>
    noremap <leader>s :Gstatus<cr>
    let g:next_vcs = 'mercurial'
  endif
endfunction

let g:next_vcs = 'mercurial'
call SwitchVCS()
nnoremap <leader><tab> :call SwitchVCS()<cr>
" {{{ == | Various keyboard mapping | ==========================================
" {{{ -- | Exercism.io | -----------------------------------
nnoremap <silent> <leader>xf :Dispatch exercism f<cr>
nnoremap <silent> <leader>xs :Dispatch exercism s %<cr>
" }}}
" {{{ -- | Buffers | ---------------------------------------
set switchbuf=usetab
" Empty buffers
command! B bufdo bd
noremap <leader>. :call DeleteHiddenBuffers()<cr>
" }}}
" {{{ -- | Splits / Tabs | ---------------------------------
noremap <leader>o :tabo<cr>
noremap <leader>O :tabo<cr><c-w>o
noremap <c-w><c-c> <c-w>H
noremap <c-w><c-t> <c-w>J
noremap <c-w><c-s> <c-w>K
noremap <c-w><c-r> <c-w>L
" Vertical split
noremap <leader>v :vnew <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
map <leader>M <c-w>=
map <leader>m :res<cr>:vertical res<cr>$
" New tab
noremap <leader>tt :tabe<cr>
noremap <leader>te :tabe <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
" Close current tab
noremap <leader>tc :tabclose<cr>
" Close all tabs but current
noremap <leader>to :tabo<cr>
" Move current tab
noremap <leader>tm :tabm<space>
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

noremap <leader>U <c-w>T
noremap <leader>u :call MergeTabs()<cr>
" }}}
" {{{ -- | Movement | --------------------------------------
" Diffs
map þ ]c
map ß [c
" Command line / Search
cmap <c-t> <down>
cmap <c-s> <up>
" Beginning / end of the line
inoremap <c-a> <c-o>^
cnoremap <c-a> <home>
inoremap <c-e> <c-o>$
cnoremap <c-e> <end>
map ç ^
" left / right / down (visual line) / up (visual line)
map <c-t> j
map <c-s> k
" Split lines
noremap <c-j> i<cr><esc>
" Don't make a # force column zero.
inoremap # X<bs>#
" Fuck you, help.
nnoremap <F1> <c-g>
inoremap <F1> <c-g>
" Paste from system buffer
noremap <leader>p :set paste<cr>o<esc>"+p:set nopaste<cr>
noremap <leader>P :set paste<cr>O<esc>"+p:set nopaste<cr>
noremap <leader>y "+y
nnoremap yf :<c-u>let @+ = expand("%")<cr>:echo 'File name yanked.'<cr>
" Give a more logical behavior to Y
nnoremap Y y$
" Command line
map è :
" }}}
" {{{ -- | Mode Switching | --------------------------------
" Yank (necessary because of some custom bindings for ag)
vnoremap yy y
" Normal mode
set noek
cmap <esc> <c-c>
" Exit
nnoremap à :q<cr>
nnoremap À :qa<cr>
nnoremap ê :bd<cr>
" Disable annoying mapping
map Q <nop>
" Reselected pasted lines
nnoremap gV `[v`]
" Select current line charwise
nnoremap vv ^v$h
smap <backspace> <backspace>i
" }}}
" {{{ -- | Togglers | --------------------------------------
" Rename file
command! RenameFile :call RenameFile()
command! RF :call RenameFile()
" Quickfix / Location togglers
noremap <silent> <leader>q :call ToggleQuickfixList()<cr>
noremap <silent> <leader>l :call ToggleLocationList()<cr>
" Toggle highlight current word
noremap <leader>' :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
" Toggle line wrap
nnoremap <leader>w :set wrap!<cr>
" Uppercase current word
nnoremap <c-g> gUiw
imap <c-g> <c-c>gUiwea
" Clear trailing spaces
nnoremap <silent> <leader>k
      \ :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" Fix indent
nnoremap <silent> <leader>i m'gg=Gg`'
" }}}
" {{{ -- | Swap number line | ------------------------------
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
noremap 6 @
noremap + 7
noremap 7 +
noremap - 8
noremap 8 -
noremap / 9
noremap 9 /
noremap * 0
noremap 0 *
" }}}
" {{{ -- | Search & Replace | ------------------------------
noremap é /
map <silent> É :nohlsearch<cr><c-l>

noremap <leader>é :%s/
noremap <leader>É :s/
vnoremap <leader>é <esc>:%s/\%V/g<left><left>
" }}}
" {{{ -- | Quick Editing | ---------------------------------
function! OpenSchemaFile()
  if filereadable('db/structure.sql')
    tabe db/structure.sql
  else
    tabe db/schema.rb
  endif
endfunction

" nnoremap <leader>es :tabe db/structure.sql<cr>
nnoremap <leader>es :call OpenSchemaFile()<cr>

nnoremap <leader>ee :tabe ~/email.md<cr>
nnoremap <leader>ef :tabe ~/.config/fish/config.fish<cr>
nnoremap <leader>eg :tabe ~/.gitconfig<cr>
nnoremap <leader>eh :tabe ~/.hgrc<cr>
nnoremap <leader>em :tabe ~/.tmux.conf<cr>
nnoremap <leader>eo :tabe ~/poi.md<cr>
nnoremap <leader>ep :tabe ~/postgres.sql<cr>
nnoremap <leader>eq :tabe ~/sqlite.sql<cr>
nnoremap <leader>er :tabe ~/release.tasks<cr>
nnoremap <leader>et :tabe ~/todo.tasks<cr>
nnoremap <leader>ev :tabe $MYVIMRC<cr>

nnoremap <leader>$ :so $MYVIMRC<cr>

nnoremap <leader># :e #<cr>
" }}}
" {{{ -- | Ranger File Chooser | ---------------------------
nnoremap <leader>h :<c-u>RangerChooser<CR>
nnoremap <leader>H :<c-u>RangerChooserRoot<CR>
" }}}
" {{{ -- | Convenience Mapping | ---------------------------
vnoremap <leader>s :sort<cr>
cnoremap %% <C-R>=expand('%')<cr>
" }}}
" {{{ == | Abbreviations | =====================================================
" }}}
