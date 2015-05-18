function util#globpathlist(path, wildcards)
	" pass either a single wildcard or a list
	let wildcards = type(a:wildcards) == type("") ? [a:wildcards] : a:wildcards
	let matches = []
	call map( wildcards, 'extend( matches, split( globpath( a:path, v:val ), "\n" ) )' )
	return sort( map( matches, 'substitute(v:val, "/[.]$", "", "")' ) )
endfunc

function util#unbundle()
	let seen = {}
	call map( split( &runtimepath, ',' ), 'extend( seen, { v:val : 1 } )' )

	let bundlepath = join( filter( util#globpathlist( &runtimepath, 'bundle/*/.' ), '!has_key(seen, v:val)' ), ',' )
	for path in util#globpathlist( bundlepath, 'doc/.' )
		if filewritable( path ) == 2 && empty( glob( path . '/tags*' ) )
			execute 'helptags' fnameescape( path )
		endif
	endfor

	let bundleafter = join( filter( util#globpathlist( bundlepath, 'after/.' ), '!has_key(seen, v:val)' ), ',' )

	let rtp = split( &runtimepath, ',\ze[^,]*/after\(,\|$\)' )
	call extend( rtp, [ bundlepath ], 1 )
	call extend( rtp, [ bundleafter ] )
	let &runtimepath = join( filter( rtp, '!empty(v:val)' ), ',' )
endfunc
