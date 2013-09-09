" .vimrc
" 
" See: http://vimdoc.sourceforge.net/htmldoc/options.html for details


filetype indent plugin on

set runtimepath+=~/.config/vim/
set viminfo+=n1~/.config/vim/viminfo

runtime bundle/vim-pathogen/autoload/pathogen.vim 
call pathogen#incubate()
call pathogen#helptags()

set nobackup
set smartindent
set tabstop=4
set shiftwidth=4    " Number of spaces to use for each step of (auto)indent.
set expandtab
set showcmd         " Show (partial) command in status line.
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


let g:ycm_global_ycm_extra_conf = '~/.config/vim/bundle/youcompleteme/cpp/ycm/.ycm_extra_conf.py'


"call pathogen#runtime_append_all_bundles()

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

au BufReadPost *.docx silent %!/usr/bin/docx2txt.pl % -
au BufReadCmd *.xlsx,*.pptx call zip#Browse(expand("<amatch>"))
au BufReadCmd *.odt,*.ott,*.ods,*.ots,*.odp,*.otp,*.odg,*.otg call zip#Browse(expand("<amatch>"))


function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

" XML formatter
function! DoFormatXML() range
	" Save the file type
	let l:origft = &ft

	" Clean the file type
	set ft=

	" Add fake initial tag (so we can process multiple top-level elements)
	exe ":let l:beforeFirstLine=" . a:firstline . "-1"
	if l:beforeFirstLine < 0
		let l:beforeFirstLine=0
	endif
	exe a:lastline . "put ='</PrettyXML>'"
	exe l:beforeFirstLine . "put ='<PrettyXML>'"
	exe ":let l:newLastLine=" . a:lastline . "+2"
	if l:newLastLine > line('$')
		let l:newLastLine=line('$')
	endif

	" Remove XML header
	exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

	" Recalculate last line of the edited code
	let l:newLastLine=search('</PrettyXML>')

	" Execute external formatter
	exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

	" Recalculate first and last lines of the edited code
	let l:newFirstLine=search('<PrettyXML>')
	let l:newLastLine=search('</PrettyXML>')
	
	" Get inner range
	let l:innerFirstLine=l:newFirstLine+1
	let l:innerLastLine=l:newLastLine-1

	" Remove extra unnecessary indentation
	exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

	" Remove fake tag
	exe l:newLastLine . "d"
	exe l:newFirstLine . "d"

	" Put the cursor at the first line of the edited code
	exe ":" . l:newFirstLine

	" Restore the file type
	exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

nmap <silent> <leader>x :%FormatXML<CR>
vmap <silent> <leader>x :FormatXML<CR>
