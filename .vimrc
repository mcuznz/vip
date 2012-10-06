" .vimrc by Tobias Schlitt <toby@php.net>.
" No copyright, feel free to use this, as you like, as long as you keep some
" credits.
"
" General VIM settings file. Optimized for coding PHP can be found in
" ~/vim/ftdetect/php.vim.
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
:autocmd!

:set mouse=a
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'joonty/vdebug.git'

" Set new grep command, which ignores SVN!
" TODO: Add this to SVN
set grepprg=/usr/bin/vimgrep\ $*\ /dev/null

" Map <F5> to turn spelling on (VIM 7.0+)
" map <F5> :setlocal spell! spelllang=en_us<cr>
" Map <F6> to turn spelling (de) on (VIM 7.0+)
" map <F6> :setlocal spell! spelllang=de<cr>

" Highlight current line in insert mode.
autocmd InsertLeave * se nocul
autocmd InsertEnter * se cul

" Reads the skeleton php file
" Note: The normal command afterwards deletes an ugly pending line and moves
" the cursor to the middle of the file.
autocmd BufNewFile *.php 0r ~/.vim/skeleton.php | normal Gdda

" Reads the skeleton txt file
autocmd BufNewFile *.txt 0r ~/.vim/skeleton.txt | normal GddOAOAOAOAOAOAOAOAOA
autocmd BufNewFile *.rst 0r ~/.vim/skeleton.txt | normal GddOAOAOAOAOAOAOAOAOA

" Disable phpsyntax base
" d indenting for .php files {{{
au BufRead,BufNewFile *.php		set indentexpr= | set smartindent
" }}}

"
" {{{ .phps files handlied like .php

au BufRead,BufNewFile *.phps		set filetype=php

" }}}

"
" {{{  Settings

" Use filetype plugins, e.g. for PHP
filetype plugin on
filetype indent on

set exrc
set secure

" Show nice info in ruler
set ruler
set laststatus=2

set wrapscan
set t_Co=256
colorscheme wombat256mod

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

source ~/.vim/php-doc.vim
syntax on

inoremap <C-P> :call PhpDocSingle()<CR>
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

" Set standard setting for PEAR coding standards
set tabstop=4
set shiftwidth=4

" Show line numbers by default
set number

" Enable folding by fold markers
set foldmethod=marker

" Autoclose folds, when moving out of them
set foldclose=all

" Use incremental searching
set incsearch

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
" }}}

" Toggle paste with <ins>
set pastetoggle=<ins>
" Go to insert mode when <ins> pressed in normal mode
nnoremap <silent> <ins> :setlocal paste!<CR>i
" Switch paste mode off whenever insert mode is left
autocmd InsertLeave <buffer> se nopaste

" Source .vimrc after saving .vimrc
autocmd bufwritepost .vimrc source $MYVIMRC

" Show large "menu" with auto completion options
set wildmenu
set wildmode=list:longest

" Write with sudo ":w!!"
cnoremap w!! w !sudo tee % >/dev/null


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

" Source local settings -- this should always be the LAST thing to do in here!
if filereadable($HOME . "/.vimlocalrc")
    source ~/.vimlocalrc
endif
