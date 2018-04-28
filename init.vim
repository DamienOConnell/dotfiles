" plugins!
call plug#begin(expand('~/.config/nvim/plugged'))

" complete brackets
Plug 'jiangmiao/auto-pairs'

" autocomplete my life in python
Plug 'davidhalter/jedi-vim', {'for': 'python'}

" one for all (except python)
Plug 'Valloric/YouCompleteMe', {'for': '!python'}

" save time in html
Plug 'mattn/emmet-vim'

" distraction free for fun
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" see the indentation
Plug 'Yggdroot/indentLine'

" using airline now
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" file icons
Plug 'ryanoasis/vim-devicons'

" most recently used
Plug 'vim-scripts/mru.vim'

" nerdtree just incase I want a side view
Plug 'scrooloose/nerdtree'

" undoooss
Plug 'mbbill/undotree'

" syntax checking
Plug 'vim-syntastic/syntastic'

" show white spaces
Plug 'ntpeters/vim-better-whitespace'

" colors schemes
Plug 'flazz/vim-colorschemes'

" and gruvbox for airline theme
Plug 'morhetz/gruvbox'

" commenting made easy
Plug 'tpope/vim-commentary'

" git in vim
Plug 'tpope/vim-fugitive'

" edit images
Plug 'tpope/vim-afterimage'

" see git changes easily
Plug 'airblade/vim-gitgutter'

" open file on github
Plug 'tpope/vim-rhubarb'

Plug 'itspriddle/vim-marked'
"
" fallback for OSX
cnoreabbrev m MarkedOpen
"
" time for plugging is over
"
call plug#end()

" relative number
set number relativenumber

" now adays we use mice
set mouse=a

" make buffer and tab switching much quicker
set hidden

" much simpler better
noremap ; :

" smarter searching
set ignorecase smartcase

" tell me what command I'm typing
set showcmd

" libclang for c++
let g:clang_library_path='/usr/lib/llvm-5.0/lib/'

" syntax highlighting for different files
syntax on
filetype plugin on

" colorscheme
" set background=dark
" set background=light

" set termguicolors
colorscheme gruvbox

" better command autocompletion
set wildmode=longest,full

" move swap files
if exists('$XDG_RUNTIME_DIR')
    set directory^=$XDG_RUNTIME_DIR//
endif

" persistent undo
set undodir=~/.undodir/
set undofile

" can already see mode in status bar
set noshowmode

" show the limit
set colorcolumn=80

" airline
let g:airline_exclude_preview = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#tabline#formatter = 'default'

" pythons
let python3_host_prog="python"
let python_host_prog="/usr/bin/python2"

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers=['flake8']
let g:syntastic_javascript_checkers=['jsl', 'jshint']
let g:syntastic_html_checkers=['tidy', 'jshint']
let g:syntastic_error_symbol='✹'
let g:syntastic_warning_symbol='✴'
let g:syntastic_aggregate_errors=1

" more reachable leader
let mapleader = " "

" mappings
noremap gh :Gbrowse <CR>
noremap tt :NERDTreeToggle <CR>
noremap mm :MRU <CR>
noremap q :wq <CR>
noremap bn :bnext<CR>
noremap bp :bprevious<CR>
noremap <Leader>u: UndotreeToggle<CR>
noremap <Leader>y "+y

" clang
let g:clang_library_path="/usr/lib/llvm-6.0/lib"

" map jedi complete
let g:jedi#completetions_command = "<C-N>"

" YCM
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/plugged/YouCompleteMe/.ycm_extra_conf.py'

" install vim plug if it doesn't exist
if !filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    echo "Installing Vim-Plug"
    echo ""
    silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
    echo "Installed vim-plug"
endif
"
"
" indents and tab
"
command! -bar -count=4 HardTab set tabstop=<count> softtabstop=0 shiftwidth=0 noexpandtab
command! -bar -count=4 SoftTab set tabstop=8 softtabstop=<count> shiftwidth=<count> expandtab
HardTab
"
" END OF DANIEL'S FILE
"
" background was set earlier but
" set background=light
set background=dark
imap jj <Esc>

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Check and setup paths if needed
"
if !isdirectory($HOME .  ".vim")
    call mkdir($HOME . "/.vim", "p", 0700)
endif

if !isdirectory($HOME .  ".vim/backup_files")
    call mkdir($HOME . "/.vim/backup_files", "p", 0700)
endif

if !isdirectory($HOME .  ".vim/swap_files")
    call mkdir($HOME . "/.vim/swap_files", "p", 0700)
endif

if !isdirectory($HOME . ".vim/undo_files")
    call mkdir($HOME . "/.vim/undo_files", "p", 0700)
endif

set backup
set backupdir=~/.vim/backup_files//
set directory=~/.vim/swap_files//
set undodir=~/.vim/undo_files//

"
