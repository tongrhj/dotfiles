" .vimrc

" Setup

" Use Pathogen
" execute pathogen#infect()

" Syntax highlighting

" Detect filetype
filetype plugin on
" Enable syntax highighting
syntax enable
highlight Comment cterm=italic

" Text management

filetype plugin indent on
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
" Round indent to nearest multiple of 2
set shiftround
" No line-wrapping
set nowrap
" Spell-check always on
set spell
" Auto-format comments
set formatoptions+=roq

" Visual decorations

" Show status line
set laststatus=2
" Show what mode you're currently in
set showmode
" Show what commands you're typing
set showcmd
" Allow modelines
set modeline
" Show current line and column position in file
set ruler
" Show file title in terminal tab
set title
" Show invisibles
set list
set listchars=tab:ª-,trail:∑
" Force the cursor onto a new line after 80 characters
set textwidth=80
" However, in Git commit messages, let's make it 72 characters
autocmd FileType gitcommit set textwidth=72
" Colour the 81st (or 73rd) column so that no typing over our limit
set colorcolumn=+1
" Highlight current line
set cursorline

" Search

" Highlight as we type
set incsearch
" Ignore case when searching...
set ignorecase
" ...except if we input a capital letter
set smartcase

" Disable beeping
set vb t_vb=
set hls

" Auto reload vimrc on change
augroup reload_vimrc " {
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }
