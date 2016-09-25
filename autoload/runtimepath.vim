" this needs to be called from vimrc to set up &runtimepath
" before Vim goes on its scan for plugins (which it only does once)
function runtimepath#setup()
	let rtp = split( &runtimepath, ',' )
	let bundle = rtp[0].'/bundle/*'

	let after = index( rtp, rtp[0].'/after' )
	call extend( rtp, [bundle.'/after'], -1 < after ? after : 1 )
	call extend( rtp, [bundle], 1 )
	let &runtimepath = join( rtp, ',' )

	let existing = map( split( glob( bundle.'/doc/tags{,-??}', 0 ), "\n" ), 'fnamemodify(v:val,'':h'')' )
	for docdir in filter( split( glob( bundle.'/doc', 0 ), "\n" ), '-1 == index(existing, v:val)' )
		helptags `=docdir`
	endfor
endfunc
