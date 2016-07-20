function runtimepath#globpathlist(path, wildcards)
	" pass either a single wildcard or a list
	let wildcards = type(a:wildcards) == type("") ? [a:wildcards] : a:wildcards
	let matches = []
	call map( wildcards, 'extend( matches, split( globpath( a:path, v:val ), "\n" ) )' )
	return sort( map( matches, 'substitute(v:val, "/[.]$", "", "")' ) )
endfunc

" this needs to be called from vimrc to set up &runtimepath
" before Vim goes on its scan for plugins (which it only does once)
function runtimepath#setup()
	let rtp = split( &runtimepath, ',' )

	let seen = {}
	call map( copy(rtp), 'extend( seen, { v:val : 1 } )' )

	let bundlepath = join( filter( runtimepath#globpathlist( &runtimepath, 'bundle/*/.' ), '!has_key(seen, v:val)' ), ',' )
	for path in runtimepath#globpathlist( bundlepath, 'doc/.' )
		if filewritable( path ) == 2 && empty( glob( path . '/tags*' ) )
			execute 'helptags' fnameescape( path )
		endif
	endfor

	let bundleafter = join( filter( runtimepath#globpathlist( bundlepath, 'after/.' ), '!has_key(seen, v:val)' ), ',' )

	set runtimepath&vim
	let [ uservim, uservimafter ] = split( &runtimepath, ',.*,' )

	call extend( rtp, [ bundlepath ],  index(rtp, uservim) + 1 )
	call extend( rtp, [ bundleafter ], len(rtp) - index(reverse(copy(rtp)), uservimafter) - 1 )
	let &runtimepath = join( filter( rtp, '!empty(v:val)' ), ',' )
endfunc
