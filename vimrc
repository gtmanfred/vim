" .vimrc
" 
" See: http://vimdoc.sourceforge.net/htmldoc/options.html for details

let $PATH="/Users/dani6186/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/opt/local/sbin:/Users/dani6186/go/bin"
set runtimepath+=~/.config/vim/
set viminfo+=n1~/.config/vim/viminfo

set nocompatible
filetype off

" setup powerline
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

set rtp+=~/.config/vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Bundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
call vundle#end()
set conceallevel=2
set concealcursor=vin

let g:clang_snippets=1
let g:clang_conceal_snippets=1
let g:clang_snippets_engine='clang_complete'

" Complete options (disable preview scratch window, longest removed to aways show menu)
set completeopt=menu,menuone

" Limit popup menu height
set pumheight=20

" SuperTab completion fall-back 
let g:SuperTabDefaultCompletionType='<c-x><c-u><c-p>'

filetype indent plugin on

set nobackup
set smartindent
set tabstop=4
set shiftwidth=4    " Number of spaces to use for each step of (auto)indent.
set expandtab
set showcmd         " Show (partial) command in status line.
set laststatus=2

set softtabstop=4
set number          " Show line numbers.
set showmatch       " When a bracket is inserted, briefly jump to the matching
set matchtime=1
set incsearch       " While typing a search command, show immediately where the
 
set ignorecase      " Ignore case in search patterns.
 
set smartcase       " Override the 'ignorecase' option if the search pattern
 
set backspace=2     " Influences the working of <BS>, <Del>, CTRL-W
set nocp 
set autoindent      " Copy indent from current line when starting a new line
 
set formatoptions=c,q,r,t " This is a sequence of letters which describes how
 
set ruler           " Show the line and column number of the cursor position,
 
set tags=./tags;/

set tabpagemax=15
 
set mouse=a         " Enable the use of the mouse.
set scrolloff=3


let g:netrw_http_cmd='curl -sL'
let g:netrw_http_xcmd='-o'
let g:netrw_silent=1
let g:clang_library_path = "/usr/lib"
"let g:clang_auto_select = 1

command W w ! sudo tee % <CR>L > /dev/null

set virtualedit=block
set foldmethod=syntax
set foldopen=all

let g:tar_cmd = 'bsdtar'


set nocp
syntax on
colo gardener
hi Normal ctermfg=NONE ctermbg=NONE cterm=NONE
let g:clang_complete_copen=1
map <F2> :call g:ClangUpdateQuickFix() <CR>
au BufRead,BufNew /tmp/mutt* so ~/.mutt/mutt.vim
au BufRead *.txt,*.mkd set tw=94
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
"au! BufRead,BufNewFile *.py call Setpython()
au BufNewFile,BufRead *.yml,*.rb,*.erb set ts=2 sw=2 et
au BufNewFile *zshcle* set ft=zsh
au Bufread,BufNewfile /tmp/zsh* set ft=zsh
au BufWinEnter,BufRead,BufNewFile *.java set filetype=java makeprg=javamake ts=4 sw=4 noet
au BufNewFile,BufRead *.svg setf svg 
autocmd BufReadPre *.pdf set ro nowrap
autocmd BufReadPost *.pdf silent %!pdftotext "%" -nopgbrk -layout -q -eol unix -
autocmd BufWritePost *.pdf silent !rm -rf ~/PDF/%
autocmd BufWritePost *.pdf silent !lp -s -d pdffg "%"
autocmd BufWritePost *.pdf silent !until [ -e ~/PDF/% ]; do sleep 1; done
autocmd BufWritePost *.pdf silent !mv ~/PDF/% %:p:h
au BufNewFile,BufRead /etc/nginx/conf/* set ft=nginx
autocmd BufReadPost ~/pastes/* noremap q <esc>:q!<esc>
autocmd BufReadPost /tmp/* noremap q <esc>:q!<esc>
au BufRead,BufNewFile *systemd* set filetype=systemd
au BufWinEnter /tmp/vimp* set tw=72 fo=cqt wm=0

au BufWinEnter,BufRead,BufNewFile *.c set filetype=c ts=4 sw=4 noet

set viminfo+=n~/.cache/vim/viminfo

let gitconfig=system("git config --get vim.settings")
if strlen(gitconfig)
    execute "set" gitconfig
endif
