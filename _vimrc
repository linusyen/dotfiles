"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	1999 Jul 25
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set nobackup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set t_Co=16		" number of colors
set t_Sf=[1;3%dm	" set foreground color
set t_Sb=[1;4%dm	" set background color
set sw=4		" set soft width
"set tabstop=2
" Only do this part when compiled with support for autocommands
if has("autocmd")
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost * if line("'\"") | exe "'\"" | endif
endif

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
" map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax on
set hlsearch

if has("autocmd")
 augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
  autocmd FileType php    set dictionary-=~/.dict/php.dat dictionary+=~/.dict/php.dat
  au BufNewFile,BufRead *.tpl	setf html
 augroup END

 augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPost,FileReadPost	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
 augroup END
endif

" highlight Cursor ctermfg=Green ctermbg=white guifg=Green guibg=white
" highlight NonText ctermfg=grey ctermbg=black guifg=gray guibg=black
" highlight Constant ctermfg=6 ctermbg=black guifg=6 guibg=black
" highlight Special ctermfg=red ctermbg=black guifg=red guibg=black
" highlight nontext ctermfg=gray ctermbg=black guifg=gray guibg=black
" highlight directory ctermbg=black guibg=black
" highlight moremsg ctermbg=black guibg=black
" highlight modemsg ctermbg=black guibg=black
" highlight Linenr ctermfg=cyan ctermbg=black guifg=cyan guibg=black
" highlight Normal ctermfg=gray ctermbg=black guifg=gray guibg=black
" highlight IncSearch ctermbg=white ctermfg=black gui=reverse guibg=black
 highlight Search ctermbg=red  ctermfg=white guifg=white guibg=black
" highlight Search ctermbg=black  ctermfg=white guifg=white guibg=black
" highlight Comment ctermbg=yellow ctermfg=red guifg=white guibg=red
" highlight PreProc ctermbg=4 ctermfg=7 guifg=7 guibg=4
" highlight Error ctermbg=1 ctermfg=2 guifg=2 guibg=1
" highlight Visual ctermbg=yellow ctermfg=white guifg=white guifg=yellow

set tags=./tags,./TAGS,../tags,../TAGS
set smartindent
set smarttab
" set foldmethod=indent
set incsearch
set vb t_vb=
" set nowrap

"set fileencoding=taiwan

" 讓PHP的顏色更好看
let php_sql_query = 1
let php_htmlInStrings = 1
let php_minlines = 3000
let php_baselib = 1
let php_asp_tags = 1

" Find cursor position , highlight near word of cursor.
function VIMRCWhere()
	if !exists("s:highlightcursor")
	match Todo /\k*\%#\k*/
	let s:highlightcursor=1
	else
	match None
	unlet s:highlightcursor
	endif
endfunction
map <C-K> :call VIMRCWhere()<CR>

" Shifting blocks visually
:vnoremap < <gv
:vnoremap > >gv

" Vim online Tip #195: Switching between files
map <C-J> <C-W>w

" Vim Online  Tip #91: Dictionary completions
set dictionary-=~/.dict/mydict.dat dictionary+=~/.dict/mydict.dat
set complete-=k complete+=k

" By Edward G.J. Lee <edt1023@speedymail.org> 2003.01.04pl1
" 修正 if 判斷語法錯誤
" 增加判斷 Latin1 locale
" This code is Public Domain.
"
"func B5()
"  set enc=big5
"  set fenc=big5
"  set fencs=ucs-bom,big5
"endf

"func U8()
"  set enc=utf8
"  set fenc=utf8
"  set fencs=ucs-bom,utf8
"endf

"if ($LC_CTYPE ==? "zh_TW.UTF-8") || ($LC_CTYPE ==? "zh_TW.utf8")
"  call U8()
"else
"  call B5()
"endif

"func U8Big5()
"  if &encoding == "big5"
"    call U8()
"    redraw | echohl ModeMsg | echo "UTF-8 Encoding" | echohl None
"  else
"    call B5()
"    redraw | echohl ModeMsg | echo "Big-5 Encoding" | echohl None
"    endif
"endf

" 按 F9 切換 utf8 及 big5
"map <F9> :call U8Big5()<CR>

set tags=./tags,./TAGS,../tags,../TAGS
set fileencodings=utf-8,ucs-bom,gb2312,big5
set encoding=utf-8
set termencoding=utf-8
set smartindent
set background=dark
"set filetype=unix
"colors elflord
"colors zellner
"colors darkblue

nmap <F1> :NERDTreeToggle<CR>
nmap <F2> :tabNext<CR>
nmap <F3> :tabprevious<CR>
set pastetoggle=<F12>

set cindent
set expandtab
set shiftwidth=4

set laststatus=2   " Always show the statusline
set statusline=%4*%<\ %1*[%F]
set statusline+=%4*\ %5*%m " encoding
set statusline+=%4*%=[%{&encoding},%{&fenc},%{&fileformat}
set statusline+=%{\"\".((exists(\"+bomb\")\ &&\ &bomb)?\",BOM\":\"\").\"\"}]\ %6*%y%4*\ %3*%l%4*,\ %3*%c%4*\ \<\ %2*%P%4*\ \>
syntax on

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
"set listchars=tab:=.,trail:.
"set list

