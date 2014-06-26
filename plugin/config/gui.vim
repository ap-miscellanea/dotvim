if ! has( 'gui_running' ) | finish | endif

" this must run after the GUI is already up
autocmd GUIEnter * source <sfile>

set t_vb= " shut up -- for the 4th time

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
	function! s:set_macvim_window_size()
		let v = mac#get_desktop_resolution()[1]
		let [&columns, &lines] =
			\ v ==  768 ? [113, 42] :
			\ v == 1080 ? [124, 57] :
			\ v == 1440 ? [136, 70] :
			\             [110, 30]
	endfunction
	autocmd GUIEnter * call s:set_macvim_window_size()
elseif has( 'gui_win32' )
	nnoremap <M-Space> :simalt ~<CR>
	inoremap <M-Space> <C-o>:simalt ~<CR>

	try   | set guifont=Consolas:h8:cANSI
	catch | set guifont=Andale_Mono:h8:cANSI
	endtry
endif

"colorscheme desert
"colorscheme slate2 " XXX: slate2 is now moria, give that a spin
colorscheme lucius
