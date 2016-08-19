exe printf( join( [ 'function s:globpathdir(path, expr)', 'return map(%s,''fnamemodify(v:val,":h")'')', 'endfunction' ], "\n" )
	\ , has('patch-7.3.465') ? 'globpath(a:path, a:expr."/.", 0, 1)'
	\ : has('patch-7.2.051') ? 'split(globpath(a:path, a:expr."/.", 0), "\n")'
	\ : 'split(globpath(a:path, a:expr."/."), "\n")' )

" this needs to be called from vimrc to set up &runtimepath
" before Vim goes on its scan for plugins (which it only does once)
function runtimepath#setup()
	let rtp = split( &runtimepath, ',' )

	let bundles = s:globpathdir( join(uniq(map(copy(rtp),'resolve(v:val)')),','), 'bundle/*' )

	for docdir in filter( s:globpathdir( join( bundles, ',' ), 'doc' ), 'filewritable(v:val) == 2' )
		if empty( glob( docdir . "/tags{,-??}" ) ) | helptags `=docdir` | endif
	endfor

	let bundlepath = join( map( bundles, 'fnamemodify(v:val, ":~")' ), ',' )
	let bundleafter = join( s:globpathdir( bundlepath, 'after' ), ',' )

	set runtimepath&vim
	let [ uservim, uservimafter ] = split( &runtimepath, ',.*,' )

	call extend( rtp, [ bundlepath ],  index(rtp, uservim) + 1 )
	call extend( rtp, [ bundleafter ], len(rtp) - index(reverse(copy(rtp)), uservimafter) - 1 )
	let &runtimepath = join( rtp, ',' )
endfunc
