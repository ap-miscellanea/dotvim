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

function! SpacePair()
	let sep = ' '
	let cur = strpart( getline('.'), col('.')-3, 3 )
	if IsEmptyPair( cur[0] . cur[2] ) && cur[1] == sep
		return sep . "\<Left>"
	else
		return sep
	endif
endfunc

function! BackSpacePair()
	let ln = getline('.')
	let pos = col('.')
	return
	\ pos >= 3 && pos <= strlen(ln) && IsEmptyPair( ln[pos-3] . ln[pos]   ) ? "\<Del>" :
	\ pos >= 2 &&                      IsEmptyPair( ln[pos-2] . ln[pos-1] ) ? "\<Del>\<BS>" :
	\ "\<BS>"
endfunc

inoremap <expr> ) SkipDelim('()')
inoremap <expr> ] SkipDelim('[]')
inoremap <expr> } SkipDelim('{}')
inoremap <expr> ' SkipDelim("''")
inoremap <expr> " SkipDelim('""')
inoremap <expr> ` SkipDelim('``')

inoremap <expr> <Space>  SpacePair()
inoremap <expr> <BS> BackSpacePair()

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
