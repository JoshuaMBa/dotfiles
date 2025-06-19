" Enable file type based indent configuration and syntax highlighting
filetype plugin indent on
syntax on

" Personalized features
set nocompatible                    
set scrolloff=8                     " Keep 8 lines visible above/below the cursor
set ignorecase                      " Ignore case when searching
set smartcase                       " Override 'ignorecase' if search contains uppercase letters
set completeopt=menuone,longest     
set shortmess+=c                    " Don't show ins-completion-menu messages
set tabstop=4                       " Number of spaces that a <Tab> in the file counts for
set softtabstop=4                   " Number of spaces a <Tab> feels like while editing
set shiftwidth=4                    " Number of spaces used for each step of (auto)indent
set smarttab                        " Insert 'shiftwidth' spaces when <Tab> is used in indent
set expandtab                       " Convert tabs to spaces
set relativenumber                  " Enable relative line numbers
set backspace=eol,start,indent      " Allow backspacing over everything in insert mode
set hlsearch                        " Highlight search matches
set number                          " Show absolute line number on current line
set ruler                           " Show the cursor position in the status line
set nowrap                          " Don't wrap lines visually
set linebreak                       " Break long lines at word boundaries (only with wrap)
set incsearch                       " Show search matches as you type
set t_Co=256                        
set clipboard^=unnamed,unnamedplus  " Use system clipboard for all yank/paste operations
set autochdir                       " Automatically change the working directory to the file's location
set matchpairs+=<:>                 " Treat < and > as matching pairs (for %, etc.)
set statusline+=%F                  " Show full file path in the status line
set whichwrap+=<,>,h,l              " Allow left/right arrow keys to move across lines
set signcolumn=yes                  " Always show the sign column (useful for Git/Gutter/Diagnostics)

" Tab autocompletion configuration
set wildmode=list,longest,full
set wildmenu

" Back to the position last time opened
if has("autocmd")
  autocmd BufRead *.txt set tw=78
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif
endif

" Enable file type detection
filetype on

" C/C++ programming helpers
augroup csrc
  au!
  autocmd FileType *      set nocindent smartindent
  autocmd FileType c,cpp,h  set cindent
augroup END

" In Makefiles, don't expand tabs to spaces, since we need the actual tabs
autocmd FileType make set noexpandtab

" Map forward/backward
map fj <C-F>
map fk <C-B>

" Map move to begin line and end line
noremap H ^
noremap L $

" Map escape
inoremap jj <Esc>

" Use tab for autocompletion when popup menu is visible
inoremap <expr> <tab> pumvisible() ? "<CR>" : "<tab>"

" Close braces, parentheses, brackets, quotation marks automatically
inoremap { {}<Esc>ha
inoremap ( ()<Esc>ha
inoremap [ []<Esc>ha
inoremap " ""<Esc>ha
inoremap ' ''<Esc>ha
inoremap ` ``<Esc>ha 

" Splits configuration 
set splitbelow 
set splitright
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Plugin setup
call plug#begin()

" List of plugins

" Insert mode autocompletion
Plug 'vim-scripts/AutoComplPop'

" Color Theme
Plug 'cesardeazevedo/Fx-ColorScheme'

call plug#end()

" Color Display
colorscheme fx
set background=dark
hi Search ctermbg=LightYellow
hi Search ctermfg=red
hi Visual ctermbg=White

" Format C/C++ files with clang-format on exit
if executable('clang-format')     
    autocmd VimLeave *.cpp,*.c,*.h:!clang-format -i %
endif
