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

	function! GetMacDesktopResolution()
		let script = 'tell application "Finder" to get bounds of window of desktop'
		let cmd = printf('osascript -e %s', shellescape(script))
		let [x0,y0,x1,y1] = split(system(cmd), '[^0-9]\+')
		return [x1-x0, y1-y0]
	endfunction
elseif has( 'gui_win32' )
	nnoremap <M-Space> :simalt ~<CR>
	inoremap <M-Space> <C-o>:simalt ~<CR>

	try   | set guifont=Consolas:h8:cANSI
	catch | set guifont=Andale_Mono:h8:cANSI
	endtry
endif

"colorscheme desert
"colorscheme slate " XXX: slate is now moria, give that a spin
colorscheme lucius
