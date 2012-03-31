set nocompatible
scriptencoding utf-8

" TODO
" :help auto-format " for mail?
" 
" http://items.sjbach.com/319/configuring-vim-right
" http://blog.learnr.org/post/59098925/configuring-vim-some-more
"
" http://gist.github.com/251482 ?
"
" http://yanpritzker.com/2012/01/20/the-cleanest-vimrc-youve-ever-seen/ ?

augroup User

" safeguard for re-sourcing
autocmd!

" editor behaviour
set autoindent        " can't live without it
if has( "&copyindent" )
	set copyindent    " stick to the file's existing indentation format for new indented lines
endif
set tabstop=4         " tabs displayed at 4 columns
set softtabstop=4     " tab key shifts by 4 columns
set shiftwidth=4      " indentation at 4 columns
set nolist            " [will selectively set this later] ensure we don't mess up the tabbing
set listchars=tab:›·,trail:•,nbsp:– " and make it look nice
if has( "&shiftround" )
	set shiftround    " always in-/outdent to next tabstop
endif
set backspace=2       " allow backspacing over indent,eol,start
set nojoinspaces      " don't treat [.?!] specially when joining lines.
set nostartofline     " don't jump to start of line on paging motions
set autowrite         " auto-save prior to :! :make and others
set hidden            " keep current buffer around when :edit'ing another file
set noswapfile        " don't litter
set nobackup          " don't litter
set nowritebackup     " really, don't litter
set confirm           " ask interactively instead of requiring a ! on commands
set history=2000      " 100x the default
set undolevels=5000   " 5x the default
set shortmess+=mrI    " supress intro message, shorten flags [Modified] and [readonly]
set shortmess-=tT     " don't truncate file messages
" FIXME FIXME FIXME set viminfo

" Make vim work with the 'crontab -e' command
set backupskip+=/var/spool/cron/*

set formatoptions+=l1
"set formatoptions+=n formatlistpat="^\s*\(\d\+[\]:.)}\t ]\|[*-]\)\s*" " recognize numbered and bulleted lists when formatting

if exists( "&encoding" )
	set encoding=utf-8                      " use UTF-8 internally
	set fileencodings=ucs-bom,utf-8,cp1252  " assume files are UTF-8; if that fails, use Latin1
endif

if exists( ':filetype' )
	filetype plugin indent on
endif

" display setup
syntax enable
set incsearch           " incremental search is convenient
set hlsearch            " ... and search highlighting helpful
set ruler               " show cursor Y,X in status line
set number              " show line numbers
set showcmd             " show (partial) command in status line
set report=1            " threshold for reporting how many lines were affected by a :cmd
set linebreak           " word wrap mode
set scrolloff=4         " scroll file when cursor gets this close to edge of window
if has( "&sidescrolloff" )
	set sidescrolloff=2 " ... or to other edge of window
endif
set winminheight=0      " don't try to keep windows visible
set laststatus=2        " always show status line
set mouse=a             " be mouse-aware, in all modes
set nomousehide         " hidden pointer = disorienting
set lazyredraw          " speed up macros
set noerrorbells        " shut up
set visualbell          " shut up
set t_vb=               " no really, shut up

" Esc for quickly clearing the search highlight
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" missing ZZ and ZQ counterparts:
" quick save-buffer and quit-everything
nnoremap ZS :w<CR>
nnoremap ZX :qa<CR>

" I do this a lot
nnoremap ZD :bd<CR>

" automatically break undo cycle at certain keys --
" better granularity for undoing insert mode work
inoremap <C-W>   <C-G>u<C-W>



" experimental: easier typing and deleting of delimiter pairs
function! IsEmptyPair(str)
	for pair in split( &matchpairs, ',' ) + [ "''", '""', '``' ]
		if a:str == join( split( pair, ':' ),'' )
			return 1
		endif
	endfor
	return 0
endfunc
function! SkipDelim(pair)
	let lft = a:pair[0]
	let rgt = a:pair[1]
	let prev = strpart( getline('.'), col('.')-2, 1 )[0]
	if IsEmptyPair( prev . rgt ) && prev != "\\"
		return rgt . "\<Left>"
	else
		return rgt
	endif
endfunc
function! WithinEmptyPair()
	let cur = strpart( getline('.'), col('.')-2, 2 )
	return IsEmptyPair( cur )
endfunc
function! SpacePair(sep)
	let cur = strpart( getline('.'), col('.')-3, 3 )
	if IsEmptyPair( cur[0] . cur[2] ) && cur[1] == a:sep
		return a:sep . "\<Left>"
	else
		return a:sep
	endif
endfunc
inoremap <expr> ) SkipDelim('()')
inoremap <expr> ] SkipDelim('[]')
inoremap <expr> } SkipDelim('{}')
inoremap <expr> ' SkipDelim("''")
inoremap <expr> " SkipDelim('""')
inoremap <expr> ` SkipDelim('``')
 inoremap <expr> <BS>    WithinEmptyPair() ? "\<Right>\<BS>\<BS>"      : "\<BS>"
"inoremap <expr> <CR>    WithinEmptyPair() ? "\<CR>\<CR>\<Up>"         : "\<CR>"
inoremap <expr> <Space> SpacePair(' ')
vnoremap q( s(<C-R>")<Esc>
vnoremap q) s(<C-R>")<Esc>
vnoremap q[ s[<C-R>"]<Esc>
vnoremap q] s[<C-R>"]<Esc>
vnoremap q{ s{<C-R>"}<Esc>
vnoremap q} s{<C-R>"}<Esc>
vnoremap q' s'<C-R>"'<Esc>
vnoremap q" s"<C-R>""<Esc>
vnoremap q` s`<C-R>"`<Esc>
vnoremap q<Space> s<Space><C-R>"<Space><Esc>


" fast window switching
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
" fast buffer switching
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>


" Alt-LeftMouse for visual block selections
noremap  <M-LeftMouse> <4-LeftMouse>
inoremap <M-LeftMouse> <4-LeftMouse>
onoremap <M-LeftMouse> <C-C><4-LeftMouse>
noremap  <M-LeftDrag>  <LeftDrag>
inoremap <M-LeftDrag>  <LeftDrag>
onoremap <M-LeftDrag>  <C-C><LeftDrag>

" keep current directory synchronised to the basedir of the current buffer,
" paying special attention to netrw stuff
function! ChangeToDirFromBuffer()
	if bufname( '' ) =~ '://' | return | endif
	lcd %:p:h
	if ! has( "win32" )
		let git_dir = substitute( system( 'git rev-parse --show-toplevel' ), '\n.*', '', '' )
		if isdirectory( git_dir ) | exe 'lcd' git_dir | endif
	endif
endfunction
autocmd BufEnter * call ChangeToDirFromBuffer()

nnoremap <Leader>e :e <C-R>=expand('%:h')<CR>/


" bookmarks
if has( "menu" )
	exec 'amenu Book&marks.&vimrc :e' expand( '<sfile>' ) . '<CR>'
endif



" plugin- and filetype-specific settings
"-======================================

if exists( '&filetype' )
	" disable wrapping in most any particular format
	" but enable it in email, Markdown, XML and X?HTML
	" NB: this needs to be done here and this way so regular text files
	" (which have no file type) will have the default wrapping enabled
	autocmd FileType * setlocal nowrap | setlocal list
	autocmd FileType {mail,mkd,xml,xhtml,html} setlocal wrap | setlocal nolist
endif

augroup END
