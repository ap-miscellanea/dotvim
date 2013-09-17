" this must run after the GUI is already up
autocmd GUIEnter * source <sfile>
if ! has( 'gui_running' )
	finish
endif

set t_vb= " shut up -- for the 4th time

set mousehide
set guioptions-=t         " no tear-off menu items
set guioptions-=T         " no toolbar
set guioptions+=c         " use cmdline prompt instead of dialog windows for confirmation
set guicursor+=a:blinkon0 " turn off cursor blinking
set guitablabel=%N\ %t    " simpler tab labels than default

if has( 'gui_gtk' )
	try   | set guifont=DejaVu\ Sans\ Mono\ 9
	catch | set guifont=Bitstream\ Vera\ Sans\ Mono\ 9
	endtry
elseif has( 'gui_macvim' )
	nnoremap <D-CR> :set invfullscreen<CR>
	" defaults write org.vim.MacVim MMNativeFullScreen 0
	let &guioptions = substitute(&guioptions, '[lLrR]', '', 'g') " turn off any and all scrollbars
	try | set guifont=Source_Code_Pro_Light:h13 | catch
	try | set guifont=Andale_Mono:h11           | catch
	try | set guifont=Menlo:h11                 | catch
	endtry | endtry | endtry
elseif has( 'gui_win32' )
	nnoremap <M-Space> :simalt ~<CR>
	inoremap <M-Space> <C-o>:simalt ~<CR>

	try   | set guifont=Consolas:h8:cANSI
	catch | set guifont=Andale_Mono:h8:cANSI
	endtry
endif

let hostname = tolower(split(hostname(),'\.')[0])
if 'klangraum' == hostname
	" XXX also see .pekwm/autoproperties
	set columns=113 lines=68
elseif 'heliopause' == hostname
	set columns=113 lines=42
else
	set columns=113 lines=35
endif

"colorscheme desert
"colorscheme slate " XXX: slate is now moria, give that a spin
colorscheme lucius
