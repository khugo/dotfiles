call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'sbdchd/neoformat'
Plug 'haya14busa/incsearch.vim'
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
call plug#end()

syntax on
filetype plugin indent on
colorscheme breezy
set termguicolors
set background=light

let mapleader=" "

set nocompatible " Disable vi compability
set modelines=0 " Security fixes

set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set shiftwidth=4
set expandtab " tabs are spaces
set autoindent

set relativenumber " show relative line numbers
set cursorline " show cursorline
hi CursorLine   cterm=NONE " no underline

set showcmd " show last command in bottom bar
set showmode " show mode in bottom bar
set undofile " make undofiles
set undodir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

set wildmenu " visual autocomplete for command menu
set lazyredraw " redraw only when needed
set showmatch " highlight matching [{(

set backspace=indent,eol,start " Fix backspace magically

" Turn off vim regex syntax
nnoremap / /\v
vnoremap / /\v
set ignorecase " Ignore case by default
set smartcase " Case sensitive if contains uppercase
set gdefault " Replace all occurences on the line
set incsearch " search as characters are entered
set hlsearch " highlight matches
set showmatch
" Turn off search highlight
nnoremap <leader><space> :noh<cr>
" Search for highlighted text
vnoremap // y/<C-R>"<CR>

set foldenable " enable folding
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " 10 nested fold max
set foldmethod=indent " fold based on indent level

" Long line handling
set wrap
set textwidth=79
set formatoptions=qrn1

" Unmap pleb keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Creating split
nnoremap <leader>vs <C-w>v<C-w>l
nnoremap <leader>hs <C-w><C-s>

" Switching splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Disable help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" move vertically by visual line
nnoremap j gj
nnoremap k gk

"highlight last inserted text
nnoremap gV `[v`]

" edit vimrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>

" Terminal mode commands
"tnoremap <Esc> <C-\><C-n>

" CtrlP
let g:ctrlp_match_window = 'bottom,order:ttb' " order matching files top to bottom with ttb
let g:ctrlp_switch_buffer = 0 " always open files in new buffers
let g:ctrlp_working_path_mode = 0 " allow changing working directory during a session
let g:ctrlp_user_command = ['.git', 'cd %s && rg --files-with-matches ".*"', 'find %s -type f']

" Backups
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '>'
let g:NERDTreeDirArrowCollapsible = 'v'
" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" Run Neoformat on save
augroup fmt
  autocmd!
  autocmd BufWritePre *.hs undojoin | Neoformat
augroup END
" Intero configs
"augroup interoMaps
  "au!
  "" Maps for intero. Restrict to Haskell buffers so the bindings don't collide.

  "" Background process and window management
  "au FileType haskell nnoremap <silent> <leader>is :InteroStart<CR>
  "au FileType haskell nnoremap <silent> <leader>ik :InteroKill<CR>

  "" Open intero/GHCi split horizontally
  "au FileType haskell nnoremap <silent> <leader>io :InteroOpen<CR>
  "" Open intero/GHCi split vertically
  "au FileType haskell nnoremap <silent> <leader>iov :InteroOpen<CR><C-W>H
  "au FileType haskell nnoremap <silent> <leader>ih :InteroHide<CR>

  "" Reloading (pick one)
  "" Automatically reload on save
  "au BufWritePost *.hs InteroReload
  "" Manually save and reload
  "au FileType haskell nnoremap <silent> <leader>wr :w \| :InteroReload<CR>

  "" Load individual modules
  "au FileType haskell nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
  "au FileType haskell nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>

  "" Type-related information
  "" Heads up! These next two differ from the rest.
  "au FileType haskell map <silent> <leader>t <Plug>InteroGenericType
  "au FileType haskell map <silent> <leader>T <Plug>InteroType
  "au FileType haskell nnoremap <silent> <leader>it :InteroTypeInsert<CR>

  "" Navigation
  "au FileType haskell nnoremap <silent> <leader>jd :InteroGoToDef<CR>

  "" Managing targets
  "" Prompts you to enter targets (no silent):
  "au FileType haskell nnoremap <leader>ist :InteroSetTargets<SPACE>

  "au FileType haskell setlocal ts=4 sw=4 sts=4
"augroup END

" Intero starts automatically. Set this if you'd like to prevent that.
"let g:intero_start_immediately = 0

" Enable type information on hover (when holding cursor at point for ~1 second).
" let g:intero_type_on_hover = 1

" Change the intero window size; default is 10.
"let g:intero_window_size = 15

" OPTIONAL: Make the update time shorter, so the type info will trigger faster.
" set updatetime=1000
"
" Easymotion
let g:EasyMotion_do_mapping = 0  "Disable default mappings
map <Leader> <Plug>(easymotion-prefx)

nmap s <Plug>(easymotion-overwin-f2)
map <Leader>w <Plug>(easymotion-wl) map <Leader>f <Plug>(easymotion-f)
map <Leader>F <Plug>(easymotion-F)
map <Leader>t <Plug>(easymotion-t)
map <Leader>T <Plug>(easymotion-T)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Airline
set noshowmode
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1
