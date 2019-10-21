" [ spelling ]                                              {{{1
"
set nocompatible

" no vim splash screen
set shortmess+=I

" Spelling language and spell file
set spellfile=$HOME/Dropbox/cfg/vimspell/en.utf-8.add
set spelllang=en_au
set spellcapcheck=.  "don't complain about uncapitalised start of line, etc
set nospell
hi clear SpellBad
hi SpellBad cterm=undercurl gui=undercurl guisp=Red

" [ os selection & python ]                                 {{{1
"
" let g:os = "Windows"
" let g:os = "Linux"
let g:os = "Darwin"

" [ set python  avoid surprises ]                           {{{2

if g:os == "Linux"
  let g:python_host_prog = "/usr/bin/python2"
  let g:python3_host_prog = "/usr/bin/python3"
endif

if g:os == "Darwin"
  let g:python_host_prog = "/usr/local/bin/python2"
  let g:python3_host_prog = "/usr/local/bin/python3"
endif

if g:os == "Windows"
  let g:python_host_prog = "C:/Python27/python.exe"
  let g:python3_host_prog = "C:/Program Files/Python37/python.exe"
endif

" [ python - run current file, or a selection ]             {{{2

iab pydef def function():

iab utf # -*- coding: utf-8 -*-

" Multi-line iab MUST have a space after the name of the alias:
iab py3  
\#!/usr/bin/env python3
\<CR>#
\<CR> -*- coding: utf-8 -*-
\<CR>
\<CR>

iab pymain  
\<CR>if __name__ == "__main__":
\<CR>main()

" [ plugins ]                                               {{{1
"  [ plugin loading bay: vim-plug ]     {{{2
"
" neovim has a different base
if has('nvim')
  call plug#begin('~/.config/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

if has('python3')
  Plug 'vim-vdebug/vdebug'                      " does not affect startup time
  Plug 'zhou13/vim-easyescape'
  let g:easyescape_chars = { "j": 2 }
  let g:easyescape_timeout = 400
else
  inoremap jj <Esc>`^
endif

Plug 'jacoborus/tender.vim'

" provides command :XTermColorTable to view all term colours and codes
Plug 'guns/xterm-color-table.vim'               " does not affect startup time
" Plug 'Yggdroot/indentLine', {'for': 'python' }

" let g:indentLine_char_list = ['┊']
" let g:indentLine_color_term = 238 " Vim
" let g:indentLine_color_gui = '#444444' " GVim

if has('python') || has ('python3')
    Plug 'psf/black', {'for': 'python'}
    Plug 'davidhalter/jedi-vim', {'for': 'python'}
    let g:jedi#force_py_version = '3.7'
    let g:jedi#show_call_signatures = 1
endif

Plug 'flazz/vim-colorschemes'
Plug 'itspriddle/vim-marked', {'for': 'markdown'}
let g:marked_filetypes = ["markdown", "md", "vimwiki"]

Plug 'ntpeters/vim-better-whitespace'
Plug 'rizzatti/dash.vim'
Plug 'haya14busa/incsearch.vim' " search highlighting
" set shortcut for inc-search
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

Plug 'scrooloose/syntastic',{'for': 'python'}
Plug 'tmhedberg/SimpylFold', {'for': 'python'}
Plug 'tpope/vim-commentary'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'ervandew/supertab'

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc','&completefunc']
let g:SuperTabRetainCompletionType=2

inoremap <expr><Enter>  pumvisible() ? "\<C-Y>" : "\<Enter>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

call plug#end()

" syntax enable retains current color settings.
syntax enable
filetype plugin indent on

"  [ plugins: syntastic ]---{{{2
"
" syntastic recommened for beginners' settings:
" Refer: https://github.com/vim-syntastic/syntastic#introduction
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_python_checkers = ['flake8']

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"

" for flake8 not to complain about long docstrings (E501)
let g:syntastic_python_flake8_post_args="--max-line-length=88"
" let g:syntastic_python_flake8_post_args='--ignore=E501,E128,E225'
let g:syntastic_python_flake8_post_args='--ignore=E501'

" [ plugins: black settings ]---                            {{{2

autocmd BufWritePost *.py silent! execute ':Black'
cnoreabbrev B Black

let g:black_fast=0                          " default 0
let g:black_linelength=90                   " default 88
let g:black_skip_string_normalization=0     " default 0

" [ plugins: simplyfold (python only) ]                     {{{2

" preview docstring in fold text - default 0
let g:simpylfold_docstring_preview = 0
" fold docstrings - default 1
let g:simpylfold_fold_docstring = 0
" fold docstrings (buffer local) - default 1
let g:simpylfold_fold_docstring = 0
" fold imports - default 1
let g:simpylfold_fold_import = 0
" fold imports (buffer local) - default 1
let b:simpylfold_fold_import = 0

" [ markdown ]                                              {{{1

" [ Auto lists: continue/end lists by adding markers        {{{2
" automatically,  if the previous line is a list item, removing them when they are empty
" https://gist.github.com/sedm0784/dffda43bcfb4728f8e90
"
" {{{ list switch_status, stolen from gabrielelana/vim-markdown
"
" Use <F2> to toggle list from listitem, listitem unchecked, listitem checked

function SwitchStatus()
  let current_line = getline('.')
  if match(current_line, '^\s*[*\-+] \[ \]') >= 0
    call setline('.', substitute(current_line, '^\(\s*[*\-+]\) \[ \]', '\1 [x]', ''))
    return
  endif
  if match(current_line, '^\s*[*\-+] \[x\]') >= 0
    call setline('.', substitute(current_line, '^\(\s*[*\-+]\) \[x\]', '\1', ''))
    return
  endif
  if match(current_line, '^\s*[*\-+] \(\[[x ]\]\)\@!') >= 0
    call setline('.', substitute(current_line, '^\(\s*[*\-+]\)', '\1 [ ]', ''))
    return
  endif
  if match(current_line, '^\s*#\{1,5}\s') >= 0
    call setline('.', substitute(current_line, '^\(\s*#\{1,5}\) \(.*$\)', '\1# \2', ''))
    return
  endif
  if match(current_line, '^\s*#\{6}\s') >= 0
    call setline('.', substitute(current_line, '^\(\s*\)#\{6} \(.*$\)', '\1# \2', ''))
    return
  endif
endfunction

noremap <F2> :call SwitchStatus()<CR>

" [ markdown preview ]                                      {{{2

" F4+c  Chrome - refreshes on save  https://chrome.google.com/webstore/detail/markdown-preview/
" F4+f  Firefox markdown-preview Thit https://github.com/Thiht/markdown-viewer

if g:os == "Windows"
  autocmd filetype markdown exe 'noremap <F4>c :!start "c:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "%:p"<CR><CR>'
  autocmd filetype markdown exe 'noremap <F4>f :!start "c:\Program Files\Mozilla Firefox\firefox.exe" "%:p"<CR><CR>'
  autocmd filetype markdown exe 'noremap <F4>c :!start "c:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "%:p"<CR><CR>'
endif

if g:os == "Darwin"
  cnoreabbrev D Dash
  cnoreabbrev m MarkedOpen

  autocmd filetype markdown exe 'nnoremap <F4>s :!open -a Safari "%"<CR><CR>'
  autocmd filetype markdown exe 'nnoremap <F4>f :!open -a /Applications/Firefox.app "%"<CR><CR>'
  autocmd filetype markdown exe 'nnoremap <F4>c :!open -a /Applications/Google\ Chrome.app "%"<CR><CR>'
endif

" [ options ]                                               {{{1
"
"  [ options - general & unsorted ]                         {{{2

set autochdir         " set current directory to that of the file being edited.
set backspace=indent,eol,start  " make backspace like most other programs
set nojoinspaces                " Use one space, not two, after punctuation.
set cursorline                  " the line with cursor is highlighted
set encoding=utf-8
set fileencodings=utf-8
set history=1000
set hlsearch
set ignorecase
set incsearch
set listchars=tab:▸\ ,eol:¬,nbsp:+
set mouse=a
set number relativenumber
set ruler
set showcmd
set showmode
set smartcase
set visualbell t_vb=".
set wildmode=list:longest,list:full
set formatoptions+=r " automatically continue comments

" navigation
set scrolloff=5     " # lines above & below cursor, 99 for cursor mid-screen
nnoremap n nzz      " land in the middle of the screen when jumping
nnoremap } }zz      " land in the middle of the screen when jumping

set hidden          " abandoned buffers become hidden

" enhanced command-line completion.
" Press 'wildchar' (usually <Tab>) to invoke completion,
" possible matches are shown just above the command line, with the
" first match highlighted (overwriting the status line, if there is
" one).  Keys that show the previous/next match, such as <Tab> or
" CTRL-P/CTRL-N, cause the highlight to move to the appropriate match.
set wildmenu

" use Ctrl+space to bring up completer (this uses jedi)
"
set completeopt=longest,menuone

" easier access to command mode
noremap ; :

" [ options by file-type ]                                 {{{1
"  [ generic / non-specific file types ]                    {{{2

set ttyfast         " faster redraw, assumes a fast connection
set laststatus=2
set linebreak
set textwidth=0             " OK for code but not for plain text files
set display=lastline
set tabstop=4
set softtabstop=4
set nosmarttab              " prevent unrequested 8-char tabs
set shiftwidth=2
set expandtab
set fileformat=unix
set autoindent
set smartindent
set breakindentopt=shift:2    " maintain indent, and another 4 spaces
set breakindent               " smart wrapping for indented lines
set wrap
set wrapmargin=0

" only applies if nowrap is set
set nowrap sidescroll=1 listchars=extends:>,precedes:<
" PEP8 for .py, Black looks after wrap etc. (multiple 'set' statements require  "|")

"  [ specific file types ]                                  {{{2

autocmd FileType python
  \  setlocal nosmartindent |
  \  setlocal tabstop=4     |
  \  setlocal autoindent    |
  \  setlocal expandtab     |
  \  setlocal nolinebreak   |
  \  setlocal nowrap        |
  \  setlocal shiftround    |
  \  setlocal shiftwidth=4  |
  \  setlocal softtabstop=4 |
  \  setlocal textwidth=0   |
  \  setlocal nocindent     |
  \  setlocal nobreakindent

autocmd FileType yaml
  \  setlocal nosmartindent |
  \  setlocal tabstop=2     |
  \  setlocal autoindent    |
  \  setlocal expandtab     |
  \  setlocal nolinebreak   |
  \  setlocal wrap        |
  \  setlocal shiftround    |
  \  setlocal shiftwidth=2  |
  \  setlocal softtabstop=2 |
  \  setlocal textwidth=0   |
  \  setlocal nocindent     |
  \  setlocal nobreakindent

autocmd filetype text,markdown,pandoc
  \ set tabstop=2       |
  \ set softtabstop=2   |
  \ set shiftwidth=2    |
  \ set textwidth=80    |
  \ set wrap            |
  \ set nospell

" [ gui settings ]                                          {{{1

if has("gui_running")
    set guioptions-=T
    set guioptions-=r
    set guioptions-=R
    set guioptions-=m
    set guioptions-=l
    set guioptions-=L
    set guitablabel=%t
    " if Mac
    if g:os == "Darwin"
        set guifont=Hack:h13
        nnoremap gz :set fullscreen! columns=1000 transparency=0<cr>
    elseif g:os == "Windows"
        set guifont=Hack:h12:cANSI:qDRAFT
    endif
endif

" [ backup, swap, undo ]                                    {{{1

" Try to create preferred locations if they don't exist:
function! InitBackupDir()
  let l:separator = '.'
  let l:parent = $HOME . '/' . l:separator . 'vim/'
  let l:backup = l:parent . 'backup_files/'
  let l:swap = l:parent . 'swap_files/'
  let l:undo= l:parent . 'undo_files/'

  if exists('*mkdir')
    if !isdirectory(l:parent)
      call mkdir(l:parent)
    endif
    if !isdirectory(l:backup)
      call mkdir(l:backup)
    endif
    if !isdirectory(l:swap)
      call mkdir(l:swap)
    endif
    if !isdirectory(l:undo)
      call mkdir(l:undo)
    endif
  endif
endfunction

call InitBackupDir()

" We will use /tmp if the first is not available
set backupdir=$HOME/.vim/backup_files/,/tmp
set directory=$HOME/.vim/swap_files/,/tmp
set undodir=$HOME/.vim/undo_files/
set backup
set undolevels=5000
set undofile

" [ hybrid numbering ]                                      {{{1
" In insert mode, and when buffer loses focus, absolute only; relative otherwise.
" Allows glance at the absolute line you were working on.

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" [ splits and split navigation ]                           {{{1

" Open new split panes to right and bottom, which feels more natural
set splitbelow      " for :split, new window is below the current one
set splitright      " for vsplit, new window is right of the current one

" [ greek, math and extended text ]                         {{{1
"  [ greek ]                                                {{{2

map! <C-v>GA Γ
map! <C-v>DE Δ
map! <C-v>TH Θ
map! <C-v>LA Λ
map! <C-v>XI Ξ
map! <C-v>PI Π
map! <C-v>SI Σ
map! <C-v>PH Φ
map! <C-v>PS Ψ
map! <C-v>OM Ω
map! <C-v>al α
map! <C-v>be β
map! <C-v>ga γ
map! <C-v>de δ
map! <C-v>ep ε
map! <C-v>ze ζ
map! <C-v>et η
map! <C-v>th θ
map! <C-v>io ι
map! <C-v>ka κ
map! <C-v>la λ
map! <C-v>mu μ
map! <C-v>xi ξ
map! <C-v>pi π
map! <C-v>rh ρ
map! <C-v>si σ
map! <C-v>ta τ
map! <C-v>ps ψ
map! <C-v>om ω
map! <C-v>ph ϕ

"  [  math ]                                                {{{2

" Digraphs [⅛ ¼ ⅜ ½ ⅝ ¾ ⅞ ⅓ ⅙] use Ctrl+k to insert.  e.g. for ⅛ use:  <ins> <C-k> 18

map! <C-v>ll →
map! <C-v>hh ⇌
map! <C-v>kk ↑
map! <C-v>jj ↓
map! <C-v>= ∝
map! <C-v>~ ≈
map! <C-v>!= ≠
map! <C-v>!> ⇸
map! <C-v>~> ↝
map! <C-v>>= ≥
map! <C-v><= ≤
map! <C-v>0  °
map! <C-v>ce ¢
map! <C-v>*  •
map! <C-v>co ⌘

"  [ subscript and superscript ]                            {{{2

inoremap <leader>1 ~1~
inoremap <leader>2 ~2~
inoremap <leader>3 ~3~
inoremap <leader>4 ~4~
inoremap <leader>5 ~5~
inoremap <leader>6 ~6~
inoremap <leader>7 ~7~
inoremap <leader>8 ~8~
inoremap <leader>9 ~9~
inoremap <leader>== ^+^
inoremap <leader>=2 ^2+^
inoremap <leader>=3 ^3+^
inoremap <leader>-- ^-^
inoremap <leader>-2 ^2-^
inoremap <leader>-3 ^3-^

"  [ extended text objects ]                                {{{2

let s:items = [ "<bar>", "\\", "/", ":", ".", "*", "_" ]
for item in s:items
    exe "nnoremap yi".item." T".item."yt".item
    exe "nnoremap ya".item." F".item."yf".item
    exe "nnoremap ci".item." T".item."ct".item
    exe "nnoremap ca".item." F".item."cf".item
    exe "nnoremap di".item." T".item."dt".item
    exe "nnoremap da".item." F".item."df".item
    exe "nnoremap vi".item." T".item."vt".item
    exe "nnoremap va".item." F".item."vf".item
endfor

" [ clipboard ]                                             {{{1
"  [ clipboard - general ]                                  {{{2
" Copy to the clipboard can be achieved with <visual select>  "+p
"
" Now all operations such as yy, D, and P work with the clipboard.
" No need to prefix them with "* or "+.
set clipboard=unnamed

let g:clipboard = {
  \ 'name': 'pbcopy',
  \ 'copy': {
  \    '+': 'pbcopy',
  \    '*': 'pbcopy',
  \  },
  \ 'paste': {
  \    '+': 'pbpaste',
  \    '*': 'pbpaste',
  \ },
  \ 'cache_enabled': 0,
  \ }

" F2 - insert the filename - NO FILE EXTENSION
inoremap <F2> <C-R>='# '.expand('%:r')<CR>
" F3 - insert the filename WITH FILE EXTENSION
inoremap <F3> <C-R>=expand('%:t:h')<CR>
" F4 - insert the parent directory
inoremap <F4> <C-R>=expand('%:p:h')<CR>
" F5 - insert full directory / path of current buffer
inoremap <F5> <C-R>=expand('%:p')<CR>


" [ date and time stamping ]                                {{{1

" CheckTimeStamp(<comment_char>) appends a timestamp for certain files

au BufWritePre .vimrc,init.vim call s:CheckTimeStamp("\"")
au BufWritePre .bashrc,.zshrc call s:CheckTimeStamp("\#")

" if no time stamp, add one, else update it
" format: <start of line>" modified <secs from Epoch> <Date text> <time text>"

function! s:CheckTimeStamp(comment_char)
    let save_pos = getpos(".")          " save cursor position
    let tstamp = a:comment_char . " modified " . strftime('%s %v %r')
    let g:lastline = getline('$')
    if g:lastline =~ "modified.*"
        execute '$s/^' . a:comment_char . ' modified.*/\=tstamp/g'
    else
        call append(line('$'), split(tstamp, "\n"))
    endif
    call setpos(".", save_pos)          " restore cursor position
endfunction

command! CheckTimeStamp call s:CheckTimeStamp()

" [ visuals ]                                               {{{1
"  [ visuals: colorscheme and airline ] ---                 {{{2

set background=dark

" tender is the color scheme
colorscheme tender
" 
" colorscheme default tender
" autocmd BufEnter * colorscheme tender
autocmd BufEnter * highlight Folded cterm=NONE ctermfg=232 ctermbg=58
autocmd BufEnter * highlight Folded gui=NONE guifg=Black guibg=#5f5f00
" " for markdown use gruvbox with Brown/Black folds
" autocmd BufEnter *.md colorscheme gruvbox
" autocmd BufEnter *.md highlight Folded cterm=NONE ctermfg=Black ctermbg=Brown
" autocmd BufEnter *.md highlight Folded gui=NONE guifg=Black guibg=#af5f00

let g:airline_theme='tender'

" fix for tender issue on OSX: https://github.com/jacoborus/tender.vim/issues/9
let macvim_skip_colorscheme=0
let g:airline_powerline_fonts = 1

" Enable the list of buffers at the top of screen
let g:airline_extensions = ['tabline']
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename

"  [ colorcolumn ]                                          {{{2
" For lines exceeding width 81, 100 characters, also put after colorscheme

highlight ColorColumn ctermbg=124
highlight ColorColumn guibg=#af0000

" believe redundant test and delete
autocmd FileType python,html,xml call matchadd('ColorColumn', '\%85v')
autocmd FileType python,html,xml call matchadd('ColorColumn', '\%90v')

" [ folding ]                                               {{{1
"  [ folding - options and shortcuts ]                      {{{2
set foldmethod=marker
let g:markdown_folding = 1

" Open all folds
nnoremap = zR

" Close all folds
nnoremap - zM

" Toggle the current fold recursively
nnoremap <space> za

" Select within fold
nnoremap viz v[zo]z$
" start with folds at level 1
" set foldlevelstart=1

"  [ Folding colours ]                                      {{{2
"
" AFTER colorscheme; cterm=NONE removes colorscheme settings like underline
"
" tender match colours

"  [ better-whitespace plugin ]                             {{{2
"   https://github.com/ntpeters/vim-better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=0

" custom highlight color
highlight ExtraWhitespace ctermbg=darkred

autocmd FileType python,perl,ruby,html EnableStripWhitespaceOnSave
let g:better_whitespace_filetypes_blacklist=['vimrc', 'python', 'markdown', '<etc>', 'diff', 'gitcommit', 'unite', 'qf', 'help']
let g:better_whitespace_verbosity=0
let g:strip_whitespace_confirm=0

" modified 1571035348 14-Oct-2019 05:42:28 pm
