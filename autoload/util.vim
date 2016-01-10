function util#globpathlist(path, wildcards)
	" pass either a single wildcard or a list
	let wildcards = type(a:wildcards) == type("") ? [a:wildcards] : a:wildcards
	let matches = []
	call map( wildcards, 'extend( matches, split( globpath( a:path, v:val ), "\n" ) )' )
	return sort( map( matches, 'substitute(v:val, "/[.]$", "", "")' ) )
endfunc

" this needs to be called from .vimrc to set up &runtimepath
" before Vim goes on its scan for plugins (which it only does once)
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

" this can be called from .vimrc to suppress the stock Vim plugins
function util#unbundle_without_stockplugins()
	call util#unbundle()
	call util#hideruntime()
endfunc

function util#hideruntime()
	let g:real_rtp = &runtimepath
	let rt = escape( $VIMRUNTIME, '\' )
	let &rtp = substitute( &rtp, '\v(^|,)\V'.rt.'\v(,|$)', '\=(submatch(1).submatch(2))[0]', 'g' )
	" if Vim goes to source anything else whatsoever, fix &runtimepath first
	augroup HideRuntime
	autocmd SourcePre * call util#unhideruntime()
	augroup END
endfunc

function util#unhideruntime()
	let &runtimepath = g:real_rtp
	unlet g:real_rtp
	autocmd! HideRuntime
	augroup! HideRuntime
endfunc
