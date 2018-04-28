" NEXT
" tpope/eunuch unix commands from VIM
" (What is)   Plugin 'vim-voom/VOoM'
"
" ***************************************************
" *** git commit                                  ***
" ***************************************************
"   git commit
"   git init
"   git add .vimrc
"   git commit -m ".vimrc 2017-09-23"
"   git push
"   git push --set-upstream origin master
"
" ***************************************************
" *** key mappings                                ***
" ***************************************************
" 'jj'            <Esc> key
" Ctrl-j move to the split below
" Ctrl-k move to the split above
" Ctrl-l move to the split to the right
" Ctrl-h move to the split to the left

" ***************************************************
" *** commands                                    ***
" ***************************************************
" F5  toggle solarized dark/light (gui mode only)
" Ctrl-CMD-F      toggle full screen terminal on OSX
" 'split'         set to 'splitbelow' new pane below
" 'vsplit' 'vs'   split window to the right
" smaller         guifont Ubuntu_Mono_derivative_Powerline h12
" medium          guifont Ubuntu_Mono_derivative_Powerline h18
" larger          guifont Ubuntu_Mono_derivative_Powerline h24
"
" <visual-select> 'gc' - vim-commentary
"
" don't use 'syntax on', protect from overwriting colorschemes
if !exists("g:syntax_on")
  syntax enable
endif

" Max recommends for native netrw file browser
"
filetype plugin on
set path+=**
set wildmenu
set nocompatible              " required
filetype off                  " required

" ***************************************************
" *** vundle (windows)                            ***
" ***************************************************
"
if has('win32')
  set rtp+=$HOME/.vim/bundle/Vundle.vim/
  call vundle#begin('$HOME/.vim/bundle/')

" ***************************************************
" *** vundle (unix & osx)                         ***
" ***************************************************
"
else
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
endif

Plugin 'gmarik/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'

" show the docstrings for folded code:
"
let g:SimpylFold_docstring_preview=1

Plugin 'vim-scripts/indentpython.vim'

" recommended autocompleter for python, only for mac/unix
"
if has('linux')
  Bundle 'Valloric/YouCompleteMe'
  let g:ycm_autoclose_preview_window_after_completion=1
  map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" for YCM - python with virtualenv support

py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

endif

" ***************************************************
" *** syntax checking                             ***
" ***************************************************
"
Plugin 'vim-syntastic/syntastic'

" PEP8 checking with this nifty little plugin:
"
Plugin 'nvie/vim-flake8'
"
let python_highlight_all=1
syntax on

" color schemes - zenburn for console, solarized for gui
"
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'itspriddle/vim-marked'
Plugin 'scrooloose/nerdtree'

" files to ignore in NERDTree
"
let NERDTreeIgnore=['\.pyc$', '\~$']

" Installation: http://powerline.readthedocs.io/en/latest/installation.html
"
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" lightweight powerline derivative and themes to go with
"
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" https://github.com/morhetz/gruvbox/blob/master/README.md
"
Plugin 'morhetz/gruvbox'

" Fix color support - https://github.com/morhetz/gruvbox/wiki/Terminal-specific
"
set termguicolors

" <visual-select> gc  - vim-commentary - comment out visual selection
"
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'

call vundle#end()
filetype plugin indent on

" PEP8 for .py  (multiple 'set' statements require a "|")
au BufNewFile,BufRead *.py
  \ set tabstop=4 |
  \ set softtabstop=4 |
  \ set shiftwidth=4 |
  \ set textwidth=79 |
  \ set expandtab |
  \ set autoindent |
  \ set fileformat=unix

" specific settihgs, for other types:
"
au BufNewFile,BufRead *.js, *.html, *.css
  \ set tabstop=2 |
  \ set softtabstop=2 |
  \ set shiftwidth=2

imap jj <Esc>

" Split navigation
"
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Modify default split is to the left or the top of screen
"
set splitbelow
set splitright

" Enable folding
"
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" Deal with tabs and trailing space
" https://stackoverflow.com/questions/11087041/gvim-to-custom-highlight-group-in-vimrc-not-working
"
highlight UnwanttedTab ctermbg=red guibg=darkred
highlight TrailSpace guibg=red ctermbg=darkred
highlight BadWhiteSpace guibg=red ctermbg=darkred

match UnwanttedTab /\t/
match TrailSpace / \+$/
match BadWhitespace /\s\+$/

autocmd ColorScheme * highlight UnwanttedTab ctermbg=red guibg=darkred
autocmd ColorScheme * highlight TrailSpace guibg=red ctermbg=darkred
autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h highlight BadWhiteSpace guibg=red ctermbg=darkred


set backup
set backupdir=~/.vim/backup_files//
set directory=~/.vim/swap_files//
set undodir=~/.vim/undo_files//

" Should be used esp. for python3
set encoding=utf-8

" Defaults for all other files, not just python etc.
set ignorecase smartcase
set number
set hls
set tabstop=2
set softtabstop=2
set shiftwidth=2
set textwidth=79
set expandtab
set autoindent
set fileformat=unix

" -- markdown syntax checker
" -- markdown preview on various OSes

" Windows and Mac GUI
if has('gui_running')
  " GUI is running or is about to start.
  set background=dark
  " colorscheme solarized

  " Use F5 to toggle between dark and light version
  "
  call togglebg#map("<F5>")
  " disable menu
  set guioptions-=m
  " Maximize gvim window (for an alternative on Windows, see simalt below).
  set lines=32 columns=103
else
endif

if has('win32')
  " Windows only
  " Markdown Preview requires plugin
  " Use two <CR> at the end to avoid the command message
  " File name is %:p - always quote - "%:p"
  " "F4+c"  Chrome extension  https://chrome.google.com/webstore/detail/markdown-preview/
  "         This Chrome extension auto-refreshes on save
  " "F4+f"  Firefox markdown-preview by Thit https://github.com/Thiht/markdown-viewer/
  "
  autocmd BufEnter *.md exe 'noremap <F4>c :!start "c:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "%:p"<CR><CR>'
  autocmd BufEnter *.md exe 'noremap <F4>f :!start "c:\Program Files (x86)\Mozilla Firefox\firefox.exe" "%:p"<CR><CR>'
  autocmd BufEnter *.mdown exe 'noremap <F4>c :!start "c:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "%:p"<CR><CR>'
  autocmd BufEnter *.mdown exe 'noremap <F4>f :!start "c:\Program Files (x86)\Mozilla Firefox\firefox.exe" "%:p"<CR><CR>'
  autocmd BufEnter *.markdown exe 'noremap <F4>c :!start "c:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "%:p"<CR><CR>'
  autocmd BufEnter *.markdown exe 'noremap <F4>f :!start "c:\Program Files (x86)\Mozilla Firefox\firefox.exe" "%:p"<CR><CR>'

  " Font fallback if Ubuntu font is not present
  " set guifont=Lucida_Console:h14:cANSI:qDRAFT
  set guifont=Ubuntu_Mono_derivative_Powerlin:h12:cANSI:qDRAFT
  
  " OSX SPECIFICS HERE
elseif has('mac')
  " Dash only works for OSX
  Plugin 'rizzatti/dash.vim'
  " fallback for OSX
  cnoreabbrev m MarkedOpen
  cnoreabbrev D Dash

  " Markdown Preview MAC
  " --------------------
  " Use F5 to current file in browser of choice:
  " Firefox on Mac - markdown opens in Markdown-Viewer by Thit
  " https://addons.mozilla.org/en-US/firefox/addon/markdown-viewer/?src=userprofile
  " Chrome on Mac - markdown opens in Markdown Reader by Yanis Wang
  " https://chrome.google.com/webstore/detail/markdown-reader/gpoigdifkoadgajcincpilkjmejcaanc
  "
  " <F4>f - Markdown Preview in Firefox
  " <F4>c - Markdown Preview in Chrome
  "
  " NB % represents current file; must quote "%" or filenames with spaces won't open
  nnoremap <F4>s :!open -a Safari "%"<CR><CR>
  nnoremap <F4>f :exe ':silent !open -a /Applications/Firefox.app "%"'<CR>
  nnoremap <F4>c :exe ':silent !open -a /Applications/Google\ Chrome.app "%"'<CR>
  nnoremap <F4>g :exe ':silent !open -a /Applications/Google\ Chrome.app "%"'<CR>
  
  " set guifont=Ubuntu_Mono_derivative_Powerline:h14
  set guifont=Hack_Regular_Nerd_Font_Complete:h12

elseif has('unix')
  " UNIX including OSX terminal
  "
  set guifont=Hack_Regular_Nerd_Font_Complete:h12
  "
  cnoreabbrev m MarkedOpen
endif

" should work on all (win/ux/osx)
cnoreabbrev smaller set guifont=Ubuntu_Mono_derivative_Powerline:h10
cnoreabbrev regular set guifont=Ubuntu_Mono_derivative_Powerline:h14
cnoreabbrev medium set guifont=Ubuntu_Mono_derivative_Powerline:h18
cnoreabbrev larger set guifont=Ubuntu_Mono_derivative_Powerline:h24

" Airline / Powerline
"
if (&encoding == 'utf-8' || &termencoding == 'utf-8') && (has('gui_running') || $TERM !~# '^linux\|^putty')
  let g:airline_powerline_fonts = 1
else
   let g:airline_left_sep = ''
   let g:airline_left_alt_sep = '|'
   let g:airline_right_sep = ''
   let g:airline_right_alt_sep = '|'
endif

set noshowmode

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers=['python', 'flake8']

set colorcolumn=80,103
colorscheme gruvbox
" 
" not working right now:
"
" source "$HOME/.vim/bundle/gruvbox/gruvbox_256palette.sh"
" colorscheme torte
" colorscheme zenburn
" colorscheme zenburn
" colorscheme solarized
"
" To use "solarized dark" set :AirlineTheme solarized, add to .vimrc:
" let g:airline_solarized_bg='dark'
"
" let g:airline_exclude_preview = 1
" let g:airline#extensions#hunks#non_zero_only = 1
" let g:airline_theme="gruvbox"
" let g:airline_solarized_bg='dark'
" let g:airline#extensions#tabline#enabled = 1
"
let g:airline_powerline_fonts = 1

" refer FAQ: https://github.com/bling/vim-airline/wiki/FAQ
set t_Co=256

" use AirlineTheme to show current theme
" More themes: https://github.com/bling/vim-airline/wiki/Screenshots
let g:airline_powerline_fonts = 1
" make Airline look like Powerline
" let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])

" destructive bs in insert mode
if has('win32')
 set backspace=indent,eol,start
endif
