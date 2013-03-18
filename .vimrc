" .vimrc by Tobias Schlitt <toby@php.net>.
" No copyright, feel free to use this, as you like, as long as you keep some
" credits.
"
" v1.1pl1
"
" Changelog:
"
" v1.1:
" --------------
"  - Added versioning and changelog
"  - Added auto-completion using <TAB>
"  - Added auto-reload command, when .vimrc changes
"  - Deactivated <CTRL>-p => "pear package" in favor of
"  - Mapped <CTRL>-p => "run through CLI"
"  - Added fold markers for better overview
"  - Added for mapping for wrapping visual selections into chars (like '/(/...)
"  - Added scrolljump=5 and scrolloff=3 for better moving around with folds
"  - Added mapping <CTRL>-h to search for the word under the cursor (should be
"    a funcion) using phpm
"  - Replaced map/imap with noremap/inoremap for clearer mappings
"
" v1.1pl1:
" --------------
"  - Fixed issue with <CTRL>-p for running PHP CLI (missing <cr>)
"  - Remapped PHP compile check to ; (in command mode only)
"
" v1.2:
" -----
"  - Remapped PHP compile check to . (in command mode only)
"  - Mapped ; to (add ; at the end of line, when missing - command mode only)
"  - Added make facilities (:make, jump to error).
"  - Added setting for not highlighting every search result (nohlsearch).
"  - Added laststatus=2 (tipp by Derick)
"  - Tip by Jakob (UG): Visual, <z>, <f> == foldmarkers for area
"  - Moved PHP specific settings to .vim/ftdetect/php.vim
"  - Activated sourcing of ftplugins
"  - Added file type setting for .phps files
"  - Created PDV (phpDocumentor for VIM) and added mapping (ATTENTION! BC
"    break!)
"  - Fixed bug with cover char mapping of "" in visual mode
"  - Added possible alternatives for other coding standards
"
"  - Replace grepprg to remove SVN results
"  - Add mapping for VIM7 spell checks to <F5>
"  - Added autocommand to highlight the current line in insert mode.
"  - Added skeleton file to be read for new PHP files.

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

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
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
Bundle 'tobyS/pdv'
Bundle 'tobyS/vmustache'
Bundle 'jakobwesthoff/whitespacetrail'
Bundle 'Lokaltog/vim-powerline'
Bundle 'SirVer/ultisnips'
Bundle 'actionshrimp/vim-xpath'
" vim-scripts repos
Bundle 'taglist.vim'
Bundle 'surround.vim'
"Bundle 'AutoTag'
Bundle 'JSON.vim'
Bundle 'phpvim'

" Allow gf to work with PHP namespaced classes.
set includeexpr=substitute(v:fname,'\\\','/','g')
set suffixesadd+=.php

" PHP cs fixer config
let g:php_cs_fixer_path = "/usr/local/bin/php-cs-fixer" " define the path to the php-cs-fixer.phar
let g:php_cs_fixer_level = "all"                " which level ?
let g:php_cs_fixer_config = "default"           " configuration
let g:php_cs_fixer_php_path = "php"             " Path to PHP
let g:php_cs_fixer_fixers_list = ""             " List of fixers
let g:php_cs_fixer_enable_default_mapping = 1   " Enable the mapping by default (<leader>pcd)
let g:php_cs_fixer_dry_run = 0                  " Call command with dry-run option
let g:php_cs_fixer_verbose = 0                  " Return the output of command if 1, else an inline information.

" Set new grep command, which ignores SVN!
" TODO: Add this to SVN
set grepprg=/usr/bin/vimgrep\ $*\ /dev/null

" Highlight current line in insert mode.
autocmd InsertLeave * set nocursorline
autocmd InsertEnter * set cursorline

let g:Powerline_symbols = 'fancy'

" Save files as root
cnoremap w!! w !sudo tee % >/dev/null
" Reads the skeleton php file
" Note: The normal command afterwards deletes an ugly pending line and moves
" the cursor to the middle of the file.
autocmd BufNewFile *.php 0r ~/.vim/skeleton.php | normal Gdda

" Reads the skeleton txt file
autocmd BufNewFile *.txt 0r ~/.vim/skeleton.txt | normal GddOAOAOAOAOAOAOAOAOA
autocmd BufNewFile *.rst 0r ~/.vim/skeleton.txt | normal GddOAOAOAOAOAOAOAOAOA

" JSON syntax highlighting
au! BufRead,BufNewFile *.json set filetype=json
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

" d indenting for .php files {{{
" Disable phpsyntax base
au BufRead,BufNewFile *.php		set indentexpr= | set smartindent
" Set standard setting for PEAR coding standards
set tabstop=4
set shiftwidth=4
" }}}

" {{{ .phps files handlied like .php

au BufRead,BufNewFile *.phps		set filetype=php

" }}}

" {{{  Settings

" Use filetype plugins, e.g. for PHP
filetype plugin on
filetype plugin indent on

set wrapscan
set tw=0
set t_Co=256
set background=dark
colorscheme wombat256mod

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

syntax on

" Show line numbers by default
set number

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

" MovingThroughCamelCaseWords
nnoremap <silent><C-Left>  :<C-u>cal search('\<\<Bar>\U\@<=\u\<Bar>\u\ze\%(\U\&\>\@!\)\<Bar>\%^','bW')<CR>
nnoremap <silent><C-Right> :<C-u>cal search('\<\<Bar>\U\@<=\u\<Bar>\u\ze\%(\U\&\>\@!\)\<Bar>\%$','W')<CR>
inoremap <silent><C-Left>  <C-o>:cal search('\<\<Bar>\U\@<=\u\<Bar>\u\ze\%(\U\&\>\@!\)\<Bar>\%^','bW')<CR>
inoremap <silent><C-Right> <C-o>:cal search('\<\<Bar>\U\@<=\u\<Bar>\u\ze\%(\U\&\>\@!\)\<Bar>\%$','W')<CR>

let g:localvimrc_sandbox=0
let g:localvimrc_ask=0

let g:syntastic_enable_signs=1
let g:syntastic_php_checkers=['php', 'phpcs', 'phpmd']

" Set the hidden option to enable moving through args and buffers without
" saving them first
set hidden

" Allow the dot command to be used in visual mode
:vnoremap . :norm.<CR>

" Toggle paste with <ins>
set pastetoggle=<ins>

" Switch paste mode off whenever insert mode is left
autocmd InsertLeave <buffer> set nopaste

" Source .vimrc after saving .vimrc
autocmd bufwritepost .vimrc source $MYVIMRC

" Show large "menu" with auto completion options
set wildmenu
set wildmode=list:longest

set ttyfast

" Save more commands in history
set history=200

" Write with sudo ":w!!"
cnoremap w!! w !sudo tee % >/dev/null

" Search the php manual from within Vim
function! OpenPhpFunction (keyword)
  let proc_keyword = substitute(a:keyword , '_', '-', 'g')
  exe 'split'
  exe 'enew'
  exe "set buftype=nofile"
  exe 'silent r!lynx -dump -nolist http://ca.php.net/'.proc_keyword
  exe 'norm gg'
  exe 'call search ("' . a:keyword .'")'
  exe 'norm dgg'
  exe 'call search("User Contributed Notes")'
  exe 'norm dGgg'
endfunction
au FileType php map K :call OpenPhpFunction('<C-r><C-w>')<CR>

" Configure PDV
let g:pdv_template_dir = $HOME . "/.vim/pdv_templates"
nnoremap <buffer> <C-p> :call pdv#DocumentWithSnip()<CR>

" Configure Ultisnips
let g:UltiSnipsExpandTrigger = "<leader><Tab>"
let g:UltiSnipsListSnippets = "<leader><C-Tab>"
" Set a custom snippets directory
let g:UltiSnipsSnippetsDir = $HOME . "/.vim/bundle/ultisnips/UltiSnips"
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "snippets", "templates_snip"]

set laststatus=2
set encoding=UTF-8

" Autoreload Vimrc every time it's saved.
if has("autocmd")
	autocmd! bufwritepost .vimrc source $MYVIMRC
endif

" Source local settings -- this should always be the LAST thing to do in here!
if filereadable($HOME . "/.vimlocalrc")
    source ~/.vimlocalrc
endif
" }}}
