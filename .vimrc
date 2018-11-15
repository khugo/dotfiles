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
Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'osyo-manga/vim-over'
Plug 'koirand/tokyo-metro.vim', { 'as': 'tokyo-metro' }
Plug 'Quramy/vim-js-pretty-template'
Plug 'tpope/vim-repeat'
call plug#end()

syntax on
filetype plugin indent on
colorscheme tokyo-metro
set termguicolors

let mapleader=" "

set nocompatible " Disable vi compability
set modelines=0 " Security fixes

set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in tab when editing
set shiftwidth=2
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
"set lazyredraw " redraw only when needed
set showmatch " highlight matching [{(

set backspace=indent,eol,start " Fix backspace magically

" Turn off vim regex syntax
nnoremap / /\v
vnoremap / /\v
vnoremap // y/\V<C-R>"<CR> " Search for visual selection
set ignorecase " Ignore case by default
set smartcase " Case sensitive if contains uppercase
set gdefault " Replace all occurences on the line
set incsearch " search as characters are entered
set hlsearch " highlight matches
set showmatch
" Turn off search highlight
nnoremap ,<leader> :noh<cr>
" Search for highlighted text
vnoremap // y/<C-R>"<CR>
" vim-over settings 
cabbrev %s OverCommandLine<cr>%s
cabbrev '<,'>s OverCommandLine<cr>'<,'>s

" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

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
tnoremap <Esc> <C-\><C-n>

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
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" Run Neoformat on save
augroup fmt
  autocmd!
  " Ignore undojoin errors
  autocmd BufWritePre *.hs try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
  autocmd BufWritePre *.ts try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
  autocmd BufWritePre *.tsx try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
augroup END

" Easymotion
let g:EasyMotion_do_mapping = 0  "Disable default mappings
map <Leader> <Plug>(easymotion-prefx)

nmap s <Plug>(easymotion-overwin-f2)
map <Leader> w <Plug>(easymotion-wl)
map f <Plug>(easymotion-fl)
map F <Plug>(easymotion-Fl)
map t <Plug>(easymotion-tl)
map T <Plug>(easymotion-Tl)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Airline
set noshowmode
let g:airline_theme='deus'
let g:airline_powerline_fonts=1

augroup TypeScript
  au!
  autocmd FileType typescript nnoremap <Leader>ct :echo tsuquyomi#hint()<CR>
  autocmd FileType typescript nnoremap <Leader>ce :TsuGeterr<CR>
  " set filetypes as typescript.tsx
  autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
  " dark red
  hi tsxTagName guifg=#E06C75

  " orange
  hi tsxCloseString guifg=#F99575
  hi tsxCloseTag guifg=#F99575
  hi tsxAttributeBraces guifg=#F99575
  hi tsxEqual guifg=#F99575

  " yellow
  hi tsxAttrib guifg=#F8BD7F cterm=italic

augroup END
let g:tsuquyomi_disable_quickfix = 1 " Disable type check on save

let g:polyglot_disabled = ['typescript', 'typescript.tsx']
