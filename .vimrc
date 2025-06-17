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


""""""""
" Coc.nvim configuration 
""""""""

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction 

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)""""""""
""""""""

" Use tab for autocompletion when popup menu is visible
"inoremap <expr> <tab> pumvisible() ? "<CR>" : "<tab>"

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

" Color Theme
Plug 'cesardeazevedo/Fx-ColorScheme'

" Insert mode autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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
