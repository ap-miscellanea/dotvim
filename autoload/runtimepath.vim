" this needs to be called from vimrc to set up &runtimepath
" before Vim goes on its scan for plugins (which it only does once)
function runtimepath#setup()
	let rtp = split( &runtimepath, ',' )
	let bundle = rtp[0].'/bundle/*'

	call extend( rtp, [bundle.'/after'], abs( index( rtp, rtp[0].'/after' ) ) )
	call extend( rtp, [bundle], 1 )
	let &runtimepath = join( rtp, ',' )

	for docdir in split( glob( bundle.'/doc', 0 ), "\n" )
		helptags `=docdir`
	endfor
endfunc
