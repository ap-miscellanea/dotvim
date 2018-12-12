set t_vb= " no really, shut up

set columns=110 lines=60
set mousehide
set guioptions-=t         " no tear-off menu items
set guioptions-=T         " no toolbar
set guioptions+=c         " use cmdline prompt instead of dialog windows for confirmation
set guicursor+=a:blinkon0 " turn off cursor blinking
set guitablabel=%N\ %t    " simpler tab labels than default

" Alt-LeftMouse for visual block selections
noremap  <M-LeftMouse> <4-LeftMouse>
inoremap <M-LeftMouse> <4-LeftMouse>
onoremap <M-LeftMouse> <C-C><4-LeftMouse>
noremap  <M-LeftDrag>  <LeftDrag>
inoremap <M-LeftDrag>  <LeftDrag>
onoremap <M-LeftDrag>  <C-C><LeftDrag>

if has( 'gui_gtk' )
	set guifont=DejaVu\ Sans\ Mono\ 9,Bitstream\ Vera\ Sans\ Mono\ 9
elseif has( 'gui_macvim' )
	set guifont=Source_Code_Pro_Light:h13,Andale_Mono:h11,Menlo:h11
	nnoremap <D-CR> :set invfullscreen<CR>
	" defaults write org.vim.MacVim MMNativeFullScreen 0
	let &guioptions = substitute(&guioptions, '[lLrR]', '', 'g') " turn off any and all scrollbars
elseif has( 'gui_win32' )
	set guifont=Consolas:h8:cANSI,Andale_Mono:h8:cANSI
	nnoremap <M-Space> :simalt ~<CR>
	inoremap <M-Space> <C-o>:simalt ~<CR>
endif

"colorscheme desert
"colorscheme slate2 " XXX: slate2 is now moria, give that a spin
colorscheme lucius
