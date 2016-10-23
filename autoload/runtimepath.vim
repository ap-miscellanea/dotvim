" this needs to be called from vimrc to set up &runtimepath
" before Vim goes on its scan for plugins (which it only does once)
function runtimepath#setup()
	let rtp = split( &runtimepath, ',' )
	let bundle = rtp[0].'/pack/bundle/start/*'

	if ! exists(':packloadall')
		let after = index( rtp, rtp[0].'/after' )
		call extend( rtp, [bundle.'/after'], -1 < after ? after : 1 )
		call extend( rtp, [bundle], 1 )
		let &runtimepath = join( rtp, ',' )
	endif

	for docdir in split( glob( bundle.'/doc' ), "\n" )
		helptags `=docdir`
	endfor
endfunc
