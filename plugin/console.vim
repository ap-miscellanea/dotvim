if has( 'gui_running' )
	finish
endif

set title
set t_Co=256

if exists( ':colorscheme' )
	try   | colorscheme railscasts
	catch | colorscheme default
	endtry
endif
