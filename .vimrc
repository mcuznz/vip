" .vimrc by Tobias Schlitt <toby@php.net>.
" No copyright, feel free to use this, as you like, as long as you keep some
" credits.
"
" Delete all auto commands (needed to auto source .vimrc after saving)
autocmd!

:set mouse=a
:set nocompatible
" required by Vundle!
filetype off

""""""""""""""
" tmux fixes "
" """"""""""""""
" Handle tmux $TERM quirks in vim
if $TERM =~ '^screen-256color'
	map <Esc>OH <Home>
	map! <Esc>OH <Home>
	map <Esc>OF <End>
	map! <Esc>OF <End>
endif

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" original repos on github
Bundle 'SirVer/ultisnips'
Bundle 'tobyS/pdv'
Bundle 'tobyS/vmustache'
Bundle "tobyS/skeletons.vim"
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'embear/vim-localvimrc'
Bundle 'joonty/vdebug'
Bundle 'joonty/vim-phpunitqf'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-unimpaired'
Bundle 'arnaud-lb/vim-php-namespace'
Bundle 'othree/html5-syntax.vim'
Bundle 'beyondwords/vim-twig'
Bundle 'stephpy/vim-php-cs-fixer'
Bundle 'puppetlabs/puppet-syntax-vim'
Bundle 'Lokaltog/powerline'
Bundle 'StanAngeloff/php.vim'
Bundle 'groenewege/vim-less'
Bundle 'vim-ruby/vim-ruby'

" Set new grep command, which ignores SVN!
" TODO: Add this to SVN
set grepprg=/usr/bin/vimgrep\ $*\ /dev/null

" Highlight current line in insert mode.
autocmd InsertLeave * set nocursorline
autocmd InsertEnter * set cursorline

" Set the hidden option to enable moving through args and buffers without
" saving them first
set hidden

" Show line numbers by default
set number

" Switch syntax highlighting on, if it was not
if !exists("g:syntax_on")
    syntax
endif

" Powerline symbols.
let g:Powerline_symbols = 'fancy'

" Save files as root
cnoremap w!! w !sudo tee % >/dev/null

" JSON syntax highlighting
au! BufRead,BufNewFile *.json set ft=javascript
augroup json_autocmd
	autocmd!
	autocmd FileType json set autoindent
	autocmd FileType json set formatoptions=tcq2l
	autocmd FileType json set textwidth=78 shiftwidth=2
	autocmd FileType json set softtabstop=2 tabstop=8
	autocmd FileType json set expandtab
	autocmd FileType json set foldmethod=syntax
augroup END

" load the man plugin for a nice man viewer
runtime! ftplugin/man.vim

" Use filetype plugins, e.g. for PHP
filetype plugin on
filetype plugin indent on

" Use built in matchit plugin
runtime macros/matchit.vim

" Colorscheme
set wrapscan
set tw=0
set t_Co=256
syntax enable
set background=dark
colorscheme wombat256mod

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType php setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType markdown set spell

" Enable folding by fold markers
set foldmethod=marker

" Autoclose folds, when moving out of them
set foldclose=all

" Use incremental searching
set incsearch

" Don't highlight search matches
set nohlsearch

" Jump 5 lines when running out of the screen
set scrolljump=5

" Indicate jump out of the screen when 3 lines before end of the screen
set scrolloff=3

" Repair wired terminal/vim settings
set backspace=start,eol,indent

" Allow file inline modelines to provide settings
set modeline

let g:localvimrc_sandbox=0
let g:localvimrc_ask=0
let g:localvimrc_count=1

let g:syntastic_enable_signs=1
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': [], 'passive_filetypes': ['html'] }

" Allow the dot command to be used in visual mode
:vnoremap . :norm.<CR>

" Toggle paste with <ins>
set pastetoggle=<ins>

" Switch paste mode off whenever insert mode is left
autocmd InsertLeave <buffer> set nopaste

" Show large "menu" with auto completion options
set wildmenu
set wildmode=list:longest

set ttyfast

" Save more commands in history
set history=200

" Configure Ultisnips
let g:UltiSnipsExpandTrigger = "<leader><Tab>"
let g:UltiSnipsListSnippets = "<leader><C-Tab>"
" Set a custom snippets directory
let g:UltiSnipsSnippetsDir = $HOME . "/.vim/snippets"
let g:UltiSnipsSnippetDirectories = ["snippets", "templates_snip"]

set laststatus=2
set encoding=UTF-8

set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

" Reads the skeleton php file
" Note: The normal command afterwards deletes an ugly pending line and moves
" the cursor to the middle of the file.
autocmd BufNewFile *.php 0r ~/.vim/skeleton.php | normal Gdda

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Autoreload Vimrc every time it's saved.
if has("autocmd")
	autocmd! bufwritepost .vimrc source $MYVIMRC
endif
