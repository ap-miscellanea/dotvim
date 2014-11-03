" experimental: easier typing and deleting of delimiter pairs
function! IsEmptyPair(str)
	let pairs = map( split( &matchpairs, ',' ), 'substitute(v:val,":","","")' ) + [ "''", '""', '``' ]
	return -1 != index( pairs, a:str )
endfunc

function! SkipDelim(pair)
	let lft = a:pair[0]
	let rgt = a:pair[1]
	let prev = strpart( getline('.'), col('.')-2, 1 )[0]
	let motion = IsEmptyPair( prev . rgt ) && prev != "\\" ? "\<Left>" : ""
	return rgt . motion
endfunc

function! EnterPair()
	let cur = strpart( getline('.'), col('.')-2, 2 )
	let motion = IsEmptyPair( cur ) ? "\<C-O>O" : ""
	return "\<CR>" . motion
endfunc

function! SpacePair()
	let cur = strpart( getline('.'), col('.')-2, 2 )
	let motion = IsEmptyPair( cur ) ? "\<Left>" : ""
	return ' ' . motion
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

inoremap <expr> <CR>     EnterPair()
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
