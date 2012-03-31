if has( 'gui' )
	finish
endif

set t_Co=256

if exists( ":colorscheme" )
	try   | colorscheme railscasts
	catch | colorscheme default
	endtry
endif
