" [ what's new .... ]                                       {{{1
" vim-markdown is out, too slow
" new function SwitchStatus mapped to F2 to toggle markdown listitems
"
" [ spelling ]                                              {{{1
"

" Configure the spelling language and file.
set spellfile=$HOME/Dropbox/repositories/cfg_user/vimspell/en.utf-8.add
set spelllang=en_au
" set spell
set spellcapcheck=.  "don't complain about uncapitalised start of line, etc

" spellcheck option

hi clear SpellBad
hi SpellBad cterm=undercurl gui=undercurl guisp=Red

" [ os detection & python ]                                 {{{1
" [ os detection ]                                          {{{2

if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

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
  let g:python_host_prog = "C:\Python27\python.exe"
  let g:python3_host_prog = "C:\Program files\Python37\python3.exe"
  " none of this works for gvim. neovim works with 3.7 and 2.7
endif

" [ python - run current file, or a selection ]             {{{2
"
" use <C-l> to run the current python file
noremap <C-l> :w !python<CR>
"
" use <leader>p (\p by default) to run python code selection
xnoremap <leader>p :w !python<CR>

iab pydef def function():
iab pymain if __name__ == "__main__":

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
  Plug 'vim-vdebug/vdebug'
  Plug 'zhou13/vim-easyescape'
  let g:easyescape_chars = { "j": 2 }
  let g:easyescape_timeout = 400
  cnoremap jj <ESC>
else
  inoremap jj <Esc>`^
endif


Plug 'ctrlpvim/ctrlp.vim'

noremap <C-a> :CtrlP ~/Dropbox/repositories<CR>

" new markdown and syntax solution...
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" provides command :XTermColorTable to view all term colours and codes
Plug 'guns/xterm-color-table.vim'


Plug 'Yggdroot/indentLine'                     " visible indentation
" Plug 'Yggdroot/indentLine', {'for': 'python' }

" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_char_list = ['┊']
let g:indentLine_color_term = 238 " Vim
let g:indentLine_color_gui = '#444444' " GVim


if has('python') || has ('python3')
    Plug 'ambv/black', {'for': 'python'}
    " use Ctrl+space to bring up completer
    Plug 'davidhalter/jedi-vim', {'for': 'python'}
    let g:jedi#force_py_version = '3.7'
    let g:jedi#show_call_signatures = 1
endif

Plug 'flazz/vim-colorschemes'
Plug 'itspriddle/vim-marked'
let g:marked_filetypes = ["markdown", "md", "pandoc", "vimwiki"]

Plug 'junegunn/fzf'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rizzatti/dash.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'haya14busa/incsearch.vim' " search highlighting
" set shortcut for inc-search
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

Plug 'scrooloose/syntastic'
Plug 'tmhedberg/SimpylFold', {'for': 'python'}
Plug 'tpope/vim-commentary'

" commentary settings
autocmd FileType apache setlocal commentstring=#\ %s

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

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


"  [ plugins: fzf ]---                                      {{{2

" junegunn fzf
nnoremap <C-p> :<C-u>FZF<CR>

" [ plugins: black settings ]---                            {{{2

autocmd BufWritePost *.py silent! execute ':Black'
cnoreabbrev B Black

let g:black_fast=0                          " default 0
let g:black_linelength=88                   " default 88
let g:black_skip_string_normalization=0     " default 0
let g:black_virtualenv="~/.vim/black"

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

" [ pandoc, new markdown solution ... ]                     {{{2
"
augroup pandoc_syntax
  au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
  au! BufEnter,BufNewFile,BufFilePre,BufRead *.md set foldtext=MyFoldText()
augroup END

let g:pandoc#filetypes#handled = ["pandoc", "markdown", "textile"]
let g:pandoc#syntax#conceal#use = 0
let g:pandoc#folding#level = 999

" [ Auto lists: continue/end lists by adding markers        {{{2
" automatically,  if the previous line is a list item, removing them when they are empty
" https://gist.github.com/sedm0784/dffda43bcfb4728f8e90
"
function! s:auto_list()
  let l:preceding_line = getline(line(".") - 1)
  if l:preceding_line =~ '\v^\d+\.\s.'
    " The previous line matches any number of digits followed by a full-stop
    " followed by one character of whitespace followed by one more character
    " i.e. it is an ordered list item

    " Continue the list
    let l:list_index = matchstr(l:preceding_line, '\v^\d*')
    call setline(".", l:list_index + 1. ". ")
  elseif l:preceding_line =~ '\v^\d+\.\s$'
    " The previous line matches any number of digits followed by a full-stop
    " followed by one character of whitespace followed by nothing
    " i.e. it is an empty ordered list item

    " End the list and clear the empty item
    call setline(line(".") - 1, "")
  elseif l:preceding_line[0] == "-" && l:preceding_line[1] == " "
    " The previous line is an unordered list item
    if strlen(l:preceding_line) == 2
      " ...which is empty: end the list and clear the empty item
      call setline(line(".") - 1, "")
    else
      " ...which is not empty: continue the list
      call setline(".", "- ")
    endif
  endif
endfunction

" N.B. Currently only enabled for return key in insert mode, not for normal
" mode 'o' or 'O'
inoremap <buffer> <CR> <CR><Esc>:call <SID>auto_list()<CR>A

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
au filetype python
  \ set autoindent      |   " align the new line indent with the previous line
  \ set expandtab       |   " expand TABs, this should be on anyway
  \ set nolinebreak     |
  \ set nowrap          |
  \ set shiftround      |   " round indent to multiple of 'shiftwidth'
  \ set shiftwidth=4    |
  \ set shiftwidth=4    |   " operation >> indents 4 columns; << unindents 4 columns
  \ set softtabstop=4   |   " insert/delete 4 spaces when hitting a TAB/BACKSPACE
  \ set tabstop=4       |   " a hard TAB displays as 4 columns
  \ set textwidth=0         " Kenneth say to use 79


au filetype text,markdown,pandoc
  \ set foldcolumn=4    |
  \ set tabstop=2       |
  \ set softtabstop=2   |
  \ set shiftwidth=2    |
  \ set textwidth=80    |
  \ set wrap

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
set backupdir=$HOME/.vim/backup_files//,/tmp
set directory=$HOME/.vim/swap_files//,/tmp
set undodir=$HOME/.vim/undo_files//
set backup
set undolevels=5000
set undofile

" [ notes & search ]                                        {{{1

command! -nargs=1 Ngrep vimgrep "<args>" $NOTES_DIR/**/*\.md
nnoremap <leader>[ :Ngrep

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

" [ multipurpose tab key  ]                                 {{{1
"  Indent if we're at the beginning of a line, else, do completion.

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

" [ mappings - insert mode ]                                {{{1
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" F2 - insert the filename - NO FILE EXTENSION
inoremap <F2> <C-R>=expand('%:r')<CR>
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


" [ diff detection & specific handling ]                    {{{1

" should echo '1' when entering 'diff mode' and '0' otherwise
function! IsDiff(opt)
    let isdiff = 0
    if v:progname =~ "diff"
        let isdiff = isdiff + 1
    endif
    if &diff == 1
        let isdiff = isdiff + 1
    endif

    if a:opt =~ "scrollopt"
        if &scrollopt =~ "hor"
            let isdiff = isdiff + 1
        endif
    endif
    return isdiff
endfunction

" [ visuals ]                                               {{{1
"  [ colorscheme selection ]                                {{{2

"  [ visuals: airline settings ]---                         {{{2

if g:os == "Windows"
    colorscheme gruvbox
    set background=dark
    let g:airline_theme='tomorrow'
else
    " colorscheme solarized
    colorscheme gruvbox
    set background=dark
    let g:solarized_underline=0         "default value is 1
    let g:solarized_contrast="high"     "default value is normal
    let g:solarized_visibility="high"   "default value is normal
    syntax enable
    let g:solarized_termcolors=256

    let g:airline_theme='tomorrow'
endif

let g:airline_powerline_fonts = 1

" Enable the list of buffers at the top of screen
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"  [ true black background ]                                {{{2

" remove background colours for everything, true black background
"
function! MyHighlights() abort
    highlight Normal      ctermbg=NONE
    highlight NonText     ctermbg=NONE
    highlight EndOfBuffer ctermbg=NONE
    highlight Normal      guibg=Black
    highlight NonText     guibg=Black
    highlight EndOfBuffer guibg=Black
endfunction

augroup MyColors
    if g:os != "Windows"  " not for windows, which uses gruvbox light bg
        autocmd!
        autocmd ColorScheme * call MyHighlights()
    endif
augroup END

"  [ colorcolumn ]                                          {{{2
" For lines exceeding width 81, 100 characters, also put after colorscheme
highlight ColorColumn ctermbg=darkblue
highlight ColorColumn guibg=#0000df

call matchadd('ColorColumn', '\%80v', 100)
call matchadd('ColorColumn', '\%90v', 100)


" [ folding ]                                               {{{1
"  [ folding - options and keymaps ]                        {{{2
" Needed for cfg and python folding; markdown use:w
" foldtype=expr, set by syntax?
set foldmethod=marker

" folding shortcuts

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

" [ folding - markdown_folding options ]                    {{{2

"  [ Folding colours ]                                      {{{2
"
" AFTER colorscheme; cterm=NONE removes colorscheme settings like underline

" white on deep brown bg
highlight Folded cterm=NONE ctermfg=Black ctermbg=Brown
highlight Folded gui=NONE guifg=Black guibg=#af5f00

" white on black
highlight FoldColumn ctermfg=White ctermbg=16
highlight FoldColumn guifg=#ffffff guibg=#080808

set foldcolumn=2

"  [ folding function ]                                     {{{2

" Fixes headers:
" (1) removes the 'lines' part of heading
" (2) fold line counts are on the RHS of the screen
" v:foldend line number of last line in the fold
" v:foldstart line number of first line in the fold
" nblines is computed doing the diff and add 1

function! MyFoldText()
    let nblines = v:foldend - v:foldstart + 1
    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let line = getline(v:foldstart)
    let comment = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
    let expansionString = repeat(".", w - strwidth(nblines.comment.'"'))
    let txt = '"' . comment . expansionString . nblines
    return txt
endfunction

set foldtext=MyFoldText()

"  [ better-whitespace plugin ]                             {{{2
"
"   https://github.com/ntpeters/vim-better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=0

" custom highlight color
highlight ExtraWhitespace ctermbg=darkred

" strip on save for these file types
autocmd FileType python,perl,ruby,html EnableStripWhitespaceOnSave
" better-whitespace blacklist - add types that don't need whitespace highlighted
let g:better_whitespace_filetypes_blacklist=['python', 'markdown', '<etc>', 'diff', 'gitcommit', 'unite', 'qf', 'help']
let g:better_whitespace_verbosity=0
let g:strip_whitespace_confirm=0  " stop asking, just do it ™
" [ per-host settings ... ]                                 {{{1

let hostname = substitute(system('hostname'), '\n', '', '')

if hostname == "caveman.magrathea.int"
    set guifont=HackNerdFontComplete-Regular:h15
endif

if hostname == "Zarquon"
    set guifont=Hack:h15
endif

if hostname == "Zarquon-1077.local"
    set guifont=Hack:h15
endif


" [ color for high contrast... ]                            {{{1
" true black background
highlight Normal guibg=Black
highlight Normal ctermbg=232


" [ -------- The End ----------                             {{{1
" {{{ SWITCH STATUS

" function SwitchStatus()
"   let current_line = getline('.')
"   if match(current_line, '^\s*[*\-+] \[ \]') >= 0
"     call setline('.', substitute(current_line, '^\(\s*[*\-+]\) \[ \]', '\1 [x]', ''))
"     return
"   endif
"   if match(current_line, '^\s*[*\-+] \[x\]') >= 0
"     call setline('.', substitute(current_line, '^\(\s*[*\-+]\) \[x\]', '\1', ''))
"     return
"   endif
"   if match(current_line, '^\s*[*\-+] \(\[[x ]\]\)\@!') >= 0
"     call setline('.', substitute(current_line, '^\(\s*[*\-+]\)', '\1 [ ]', ''))
"     return
"   endif
"   if match(current_line, '^\s*#\{1,5}\s') >= 0
"     call setline('.', substitute(current_line, '^\(\s*#\{1,5}\) \(.*$\)', '\1# \2', ''))
"     return
"   endif
"   if match(current_line, '^\s*#\{6}\s') >= 0
"     call setline('.', substitute(current_line, '^\(\s*\)#\{6} \(.*$\)', '\1# \2', ''))
"     return
"   endif
" endfunction

" noremap <F2> :call SwitchStatus()<CR>


" modified 1557043020  5-May-2019 05:57:00 pm
