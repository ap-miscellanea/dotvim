" experimental: easier typing and deleting of delimiter pairs
function! IsEmptyPair(str)
	for pair in split( &matchpairs, ',' ) + [ "''", '""', '``' ]
		if a:str == join( split( pair, ':' ),'' )
			return 1
		endif
	endfor
	return 0
endfunc

function! SkipDelim(pair)
	let lft = a:pair[0]
	let rgt = a:pair[1]
	let prev = strpart( getline('.'), col('.')-2, 1 )[0]
	if IsEmptyPair( prev . rgt ) && prev != "\\"
		return rgt . "\<Left>"
	else
		return rgt
	endif
endfunc

function! WithinEmptyPair()
	let cur = strpart( getline('.'), col('.')-2, 2 )
	return IsEmptyPair( cur )
endfunc

function! SpacePair(sep)
	let cur = strpart( getline('.'), col('.')-3, 3 )
	if IsEmptyPair( cur[0] . cur[2] ) && cur[1] == a:sep
		return a:sep . "\<Left>"
	else
		return a:sep
	endif
endfunc

inoremap <expr> ) SkipDelim('()')
inoremap <expr> ] SkipDelim('[]')
inoremap <expr> } SkipDelim('{}')
inoremap <expr> ' SkipDelim("''")
inoremap <expr> " SkipDelim('""')
inoremap <expr> ` SkipDelim('``')

 inoremap <expr> <BS>    WithinEmptyPair() ? "\<Right>\<BS>\<BS>"      : "\<BS>"
"inoremap <expr> <CR>    WithinEmptyPair() ? "\<CR>\<CR>\<Up>"         : "\<CR>"
inoremap <expr> <Space> SpacePair(' ')

vnoremap q( s(<C-R>")<Esc>
vnoremap q) s(<C-R>")<Esc>
vnoremap q[ s[<C-R>"]<Esc>
vnoremap q] s[<C-R>"]<Esc>
vnoremap q{ s{<C-R>"}<Esc>
vnoremap q} s{<C-R>"}<Esc>
vnoremap q' s'<C-R>"'<Esc>
vnoremap q" s"<C-R>""<Esc>
vnoremap q` s`<C-R>"`<Esc>
vnoremap q<Space> s<Space><C-R>"<Space><Esc>
