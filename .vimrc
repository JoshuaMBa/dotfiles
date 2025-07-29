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

" Files will open at the position at which they were closed
if has("autocmd")
  autocmd BufRead *.txt set tw=78
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif
endif

" C/C++ programming helpers
augroup csrc
  au!
  autocmd FileType *      set nocindent smartindent
  autocmd FileType c,cpp,h  set cindent
augroup END

" In Makefiles, don't expand tabs to spaces, since we need the actual tabs
autocmd FileType make set noexpandtab

" Scroll down with fj and scroll down with fk
map fj <C-F>
map fk <C-B>

" Move to end of line with L and start of line with H
noremap H ^
noremap L $

" Escape with jj
inoremap jj <Esc>

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh() 

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

" Insert mode autocompletion (`CocInstall coc-clangd` for C/C++ LSP, add
" { suggest.noselect: true } to coc config with `CocConfig` to fix autcomplete
" menu selection of first result)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Auto pairing of brackets, braces, parentheses and quotations
Plug 'jiangmiao/auto-pairs'

" Status bar customization
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Directory panel
Plug 'preservim/nerdtree'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Color Theme
Plug 'cesardeazevedo/Fx-ColorScheme'

call plug#end()

colorscheme fx

" Color Display
set background=dark
hi Search ctermbg=LightYellow
hi Search ctermfg=red
hi Visual ctermbg=White

" Toggle directory panel with ctrl + h
inoremap <C-h> <Esc>:NERDTreeToggle<cr>
nnoremap <C-h> <Esc>:NERDTreeToggle<cr>

" Open fuzzy finder for files 
inoremap <C-Q> :Files<CR>
nnoremap <C-Q> :Files<CR>

" Open fuzzy finder for buffers 
inoremap <C-R> :Buffers<CR>
nnoremap <C-R> :Buffers<CR>

" Format C/C++ files with clang-format on exit
if executable('clang-format')     
    autocmd VimLeave *.cpp,*.c,*.h:!clang-format -i %
endif
