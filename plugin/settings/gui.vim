" this must run after the GUI is already up
autocmd GUIEnter * source <sfile>
if ! has( 'gui_running' )
	finish
endif

set t_vb= " shut up -- for the 4th time

set guioptions-=t         " no tear-off menu items
set guioptions-=T         " no toolbar
set guioptions+=c         " use cmdline prompt instead of dialog windows for confirmation
set guicursor+=a:blinkon0 " turn off cursor blinking
set guitablabel=%N\ %t    " simpler tab labels than default

if has( 'gui_win32' )
	nnoremap <M-Space> :simalt ~<CR>
	inoremap <M-Space> <C-o>:simalt ~<CR>

	try   | set guifont=Consolas:h8:cANSI
	catch | set guifont=Andale_Mono:h8:cANSI
	endtry
elseif has( 'gui_mac' )
	set guifont=Menlo:h13
endif

let colorscheme = 'desert'

let hostname = tolower(split(hostname(),'\.')[0])
if 'klangraum' == hostname
	" XXX: slate is now moria, give it a spin
	let colorscheme = 'lucius'
	" XXX also see .pekwm/autoproperties
	set columns=113 lines=68
	set guifont=DejaVu\ Sans\ Mono\ 9
elseif 'heliopause' == hostname
	set columns=110 lines=60
elseif 'apastron' == hostname
	let colorscheme = 'lucius'
	set columns=110 lines=35
else
	set columns=110 lines=35
endif

exe 'colorscheme' colorscheme