set nocompatible
scriptencoding utf-8

" TODO
" :help auto-format " for mail?
" 
" http://items.sjbach.com/319/configuring-vim-right
" http://blog.learnr.org/post/59098925/configuring-vim-some-more
"
" http://gist.github.com/251482 ?

augroup User

" safeguard for re-sourcing
autocmd!

" HACK: I don't want a .gvimrc but some stuff gets reset during GUI init,
" therefore re-source .vimrc at GUI start.
" Unfortunately re-sourcing isn't inherently idempotent, so gotta be careful
if has( "gui" )
	autocmd GUIEnter * source <sfile>
endif

let mapleader=','

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
if exists( ":filetype" )
	filetype plugin indent on
	runtime ftplugin/man.vim " to have :Man available
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

runtime macros/matchit.vim

" make good typography easy to type
if has( "digraphs" )
	digraphs  160 " non-breaking space
	digraphs *.   183 " centered dot
	digraphs --  8211 " en-dash
	digraphs __  8212 " em-dash
	digraphs `   8216 " single left quote
	digraphs '   8217 " single right quote
	digraphs ,   8218 " double bottom quote
	digraphs ``  8220 " double left quote
	digraphs ''  8221 " double right quote
	digraphs ,,  8222 " double bottom quote
	digraphs **  8226 " bullet
	digraphs ..  8230 " horizontal ellipsis
	digraphs <3  9829 " black heart suit
	digraphs ?!  8253 " interrobang
	digraphs !?  8253 " interrobang
endif

" Esc for quickly clearing the search highlight
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" missing ZZ and ZQ counterparts:
" quick save-buffer and quit-everything
nnoremap ZS :w<CR>
nnoremap ZX :qa<CR>

" I do this a lot
nnoremap ZD :bd<CR>

" automatically break undo cycle at certain keys --
" better granularity for undoing insert mode work
inoremap <C-W>   <C-G>u<C-W>

" " XXX: the motivation for the following undo cycle breakers was to avoid the
" " occasional loss of large inserts due to accidental edits erasing the redo
" " list after undo. With undo branches in Vim 7 the premise of lost redos is
" " void.
" inoremap <CR>    <C-G>u<CR>
" inoremap <Space> <C-G>u<Space>
" inoremap <BS>    <C-G>u<BS>
" inoremap <Del>   <C-G>u<Del>



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
if exists( ':lcd' )
	autocmd BufEnter * if bufname( "" ) !~ '^[[:alnum:]]*://' | silent! exec "lcd" matchstr( expand( '%:p:h' ), '^\(sudo:\)\?\zs.*' ) | endif
else
	" good grief, we're riding a dinosaur
	autocmd BufEnter * if bufname( "" ) !~ '^[[:alnum:]]*://' | cd %:p:h | endif
endif

function! SudoWrite(file,line1,line2)
	" intercept the external file change reload prompt event
	autocmd FileChangedShell <buffer> :
	" shazzam
	exe 'silent' a:line1 . ',' . a:line2 . 'write !sudo tee 1>/dev/null' strlen(a:file) ? a:file : '%'
	" force-trigger vim's file modification check, then undo the intercept
	checktime | autocmd! FileChangedShell <buffer>
	" if it was a whole-file write, tell vim to consider the buffer saved
	if a:line1 == 1 && a:line2 == line('$') | set nomodified | endif
endfunction
command! -range=% -nargs=? -complete=file Sudo call SudoWrite(<q-args>,<q-line1>,<q-line2>)

" gooey settings
if has( "gui_running" )       " has( 'gui' ) alone is insufficient
	set guioptions-=t         " no tear-off menu items
	set guioptions-=T         " no toolbar
	set guioptions+=c         " use cmdline prompt instead of dialog windows for confirmation
	set guicursor+=a:blinkon0 " turn off cursor blinking
	set guitablabel=%N\ %t    " simpler tab labels than default

	if has( "gui_win32" )
		nnoremap <M-Space> :simalt ~<CR>
		inoremap <M-Space> <C-o>:simalt ~<CR>
		try | set guifont=Consolas:h10:cANSI | catch | set guifont=Andale_Mono:h9:cANSI | endtry
		" requires gvimfullscreen_win32 <http://www.vim.org/scripts/script.php?script_id=2596>
		nnoremap <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
		inoremap <F11> <C-o>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
	elseif has( "gui_mac" )
		set guifont=Menlo:h13
	endif

	let colorscheme = 'desert'

	let hostname = tolower(split(hostname(),'\.')[0])
	if "klangraum" == hostname
		let colorscheme = 'lucius'
		" XXX: slate is now moria, give it a spin
		set columns=113 lines=68
		set guifont=DejaVu\ Sans\ Mono\ 9
	elseif "heliopause" == hostname
		set columns=110 lines=60
	elseif "apastron" == hostname
		let colorscheme = 'lucius'
		set columns=110 lines=35
	else
		set columns=110 lines=35
	endif

	exe 'colorscheme' colorscheme
else
	set t_Co=256
	if exists( ":colorscheme" )
		try | colorscheme railscasts | catch | colorscheme default | endtry
	endif
endif


" bookmarks
if has( "menu" )
	exec 'amenu Book&marks.&vimrc :e' expand( '<sfile>' ) . '<CR>'
endif


if has( "perl" ) " wheee!
	perl eval 'use Encode;'
	perl eval 'use HTML::Entities;'
	perl eval 'use Text::Markdown qw(markdown);'
	perl eval 'use Text::SmartyPants; *smarten = \&Text::SmartyPants::process;'
	perl << EOF
		sub VIM::Filter {
			my ( $start, $end, $func ) = @_;
			my $encoding = VIM::Eval( '&fileencoding' ) || VIM::Eval( '&encoding' );
			my $text = join '', map "$_\n", map { decode $encoding, $_ } $curbuf->Get( $start .. $end );
			my @filtered = $func->( $text );
			chomp @filtered;
			$curbuf->Delete( $start + 1, $end ) if $end > $start;
			$curbuf->Append( $start, map { split m!$/!, $_, -1 } @filtered );
			$curbuf->Delete( $start );
		}
EOF

	command! -range Markdown     perl VIM::Filter( <line1>, <line2>, sub { my $_ = smarten( markdown( shift ), 2 ); s/&#(\d+);/chr $1/eg; return $_ } )
	command! -range SmartyPants  perl VIM::Filter( <line1>, <line2>, sub { my $_ = smarten( shift, 2 ); s/&#(\d+);/chr $1/eg; return $_ } )
    command! MailPants 0/^$/ , /^-- /-1 SmartyPants
	command! -range DecodeHTML   perl VIM::Filter( <line1>, <line2>, \&HTML::Entities::decode )
endif

command! GreekPants silent! %s!\%u201C!«!g | silent! %s!<<!«!g | silent! %s!>>!»!g | silent! %s!\%u201D!»!g | silent! %s! - !\=' ' . nr2char(8211) . ' '!g | silent! %s!?!\=nr2char(894)!gc

" Vim doesn't like huge regexes much and there is a 'Press Enter' prompt whose reason I cannot find
function! FindNumbers()
	let @/ = '\c\%(\<eight\?\|\<one\|\<ten\>\|eleven\|f\%(i\%(ve\|f\)\|our\)\|hundred\|nine\|s\%(even\|ix\)\|t\%(h\%(ir\|ousand\|ree\)\|w\%(e\%(lve\|n\)\|o\)\)\)\%(teen\|ty\)\?'
	call search(@/) " evade prompt
endfunction
nnoremap <Leader>n :call FindNumbers()<CR>:set hlsearch<CR>:echo<CR>


let s:allowed_langs = [ 'en_gb', 'de', 'el' ]
function! UnsetLanguage()
	if exists( 's:save_spell' )
		exe 'setl' s:save_spell
		unlet s:save_spell
	endif
	set keymap=
	unlet s:lang
	echohl ModeMsg
	echo 'Language off'
	echohl None
endfunction
function! SetLanguage(lang)
	if index(s:allowed_langs, a:lang) < 0 | throw 'Language "'.a:lang.'" not in list' | endif
	if ! exists( 's:save_spell' )
		let s:save_spell=( &spell ? 'spell' : 'nospell' ) . ' spelllang=' . &spelllang
	endif
	exe 'setl spell spelllang=' . a:lang
	exe 'set keymap=' . ( a:lang == 'el' ? 'greek_utf-8' : '' )
	let s:lang = a:lang
	echohl ModeMsg
	echon 'Language: [' a:lang ']'
	echohl None
endfunction
function! CycleLanguage()
	let next = 0
	if exists( 's:lang' )
		let next = index( s:allowed_langs, s:lang ) + 1
	endif
	if next >= len( s:allowed_langs )
		call UnsetLanguage()
	else
		call SetLanguage( s:allowed_langs[next] )
	endif
endfunction
nnoremap <Leader><Leader> :call CycleLanguage()<CR>


" plugin- and filetype-specific settings
"-======================================

" NERD_tree on the left is weird
let g:NERDTreeWinPos = 'right'
nnoremap <F12> :NERDTree<CR>

" qbuf hotkey
let g:qb_hotkey = '<F11>'

" matchparen slows gvim down noticably
let g:loaded_matchparen = 1

" for Michal Gorny's improved syntax/xhtml.vim
let g:xhtml_no_embedded_mathml = 1
let g:xhtml_no_embedded_svg = 1

if has( "gui_win32" )
	let g:netrw_cygwin = 0
	let g:netrw_ssh_cmd  = 'C:\Programme\PuTTY\plink.exe'
	let g:netrw_scp_cmd  = 'C:\Programme\PuTTY\pscp.exe -batch -q -scp'
	let g:netrw_sftp_cmd = 'C:\Programme\PuTTY\pscp.exe -batch -q -sftp'
else
	" some silly servers refuse to respond to user agents that they assume to be spiders
	let g:netrw_http_cmd  = "wget -U 'Vim " . v:version / 100 . "." . v:version % 100 . " (netrw)' -O"
endif

" for :TOhtml
let g:html_use_css = 1
let g:use_xhtml = 1
let g:html_number_lines = 1
let g:html_use_encoding = "utf-8"

" for Perl syntax
let g:perl_include_pod = 1 " include POD syntax highlighting

if exists( '&filetype' )
	" disable wrapping in most any particular format
	" but enable it in email, Markdown, XML and X?HTML
	" NB: this needs to be done here and this way so regular text files
	" (which have no file type) will have the default wrapping enabled
	autocmd FileType * setlocal nowrap | setlocal list
	autocmd FileType {mail,mkd,xml,xhtml,html} setlocal wrap

	" use internal help when editing vim scripts or viewing help
	autocmd FileType {vim,help} setlocal keywordprg=:help

	" easier help browsing
	autocmd FileType help nnoremap <buffer><CR> <C-]>
	autocmd FileType help nnoremap <buffer><BS> <C-T>
	autocmd FileType help nnoremap <buffer><Tab> :call search('<Bar>\zs\k*\ze<Bar>')<CR>:echo<CR>

	" XML = nesting, which makes 4 places per tab way too much
	" also, make it possible to autocomplete tag names with hyphens in them
	autocmd FileType {xml,xslt} setlocal ts=2 sw=2 sts=2 iskeyword=@,-,\:,48-57,_,128-167,224-235

	" miscellany for Perl
	autocmd FileType perl setlocal iskeyword+=: makeprg=perl\ -Wc\ % errorformat=%m\ at\ %f\ line\ %l%.%#,%-G%.%#
	if has( "win32" )
		" Vim uses a temp file in Windows; Perl's stderr has to be handled corectly
		autocmd FileType perl setlocal shellpipe=1>&2\ 2>
	endif
	autocmd FileType perl setlocal keywordprg=sh\ -c\ 'perldoc\ -f\ \$1\ \|\|\ perldoc\ \$1'\ --

	autocmd FileType python setlocal expandtab

	" inexplicable omission; necessary so CSS color highlighting will work right
	autocmd FileType css  setlocal iskeyword+=-

	autocmd FileType html setlocal makeprg=tidy\ -q\ %\ 2>&1\ \\\|\ grep\ ^line errorformat+=line\ %l\ column\ %*\\d\ -\ %m

	" regular autoindent works better for me
	autocmd FileType {html,xml} setlocal indentexpr=

	autocmd FileType crontab setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

	" automatically enable spellcheck for mails and Markdown documents
	autocmd FileType {mail,mkd} call SetLanguage('en_gb')

	autocmd FileType mail setlocal expandtab textwidth=65 fencs=utf-8
	autocmd FileType mail if search('^$') | exe 'norm j0' | endif

	" mail.vim links mailSubject to LineNR but that doesn't stand out enough
	autocmd FileType mail hi link mailSubject PreProc

	" when saving mail, remove trailing whitespace from all lines except sig markers
	autocmd FileType mail autocmd BufWritePre <buffer> let s:saveview = winsaveview() | silent! %s:\(^--\)\@<! \+$:: | call winrestview(s:saveview) | unlet s:saveview

	" nicer From: line for my emails: if it's a `mail` buffer, then before
	" saving, find the first signature in the buffer, find the name in full
	" within it, and use that to replace the 'A.' on the From: line
	autocmd FileType mail autocmd BufWritePre <buffer> let s:saveview = winsaveview() | silent! 1,/^\n/s!^From:.*\zsA\.\ze Pagaltzis!\= filter( [ matchstr( matchstr( join( getline(1,'$'), "\r" ), '\v\r-- \r\zs([^\r]+(\r|$))*' ), '\v(Aristot(le|eles)|Αριστοτέλης)' ), 'A.' ], 'len(v:val) > 0' )[0] !e | call winrestview(s:saveview) | unlet s:saveview
	autocmd FileType mail autocmd BufWritePre <buffer> let s:saveview = winsaveview() | silent! 1,/^\n/s!^From:.*\zsPagaltzis!\= filter( [ matchstr( matchstr( join( getline(1,'$'), "\r" ), '\v\r-- \r\zs([^\r]+(\r|$))*' ), 'Παγκαλτζής' ), 'Pagaltzis' ], 'len(v:val) > 0' )[0] !e | call winrestview(s:saveview) | unlet s:saveview

endif

augroup END
