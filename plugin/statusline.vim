let s:rx = '^}\s*\zs$\|^sub\s\+\zs\S\+'
"let s:rx = '^[[:alpha:]$_]'

function! PerlStatusLine()
	if &filetype !=# 'perl' | return '' | endif
	let b:statusline_funcname = matchstr(getline(search(s:rx,'bcnW')),s:rx)
	return ' %#PmenuSel#%( %{get(b:,''statusline_funcname'','''')} %)%*'
endf

function! StatusLine(l,r)
	return '%<%f%( %h%w%{ &modified ? ''[+]'' : '''' }%r%)' . a:l . '%=' . a:r
	\ . '%( <%{ &iminsert == 1 ? get( b:, ''keymap_name'', len(''&keymap'') ? &keymap : ''lang'' ) : '''' }> %)'
	\ . ( &ruler ? '%18.18(%<' . ( len(&rulerformat) ? &rulerformat : '%-14.(%l,%c%V%) %P' ) . '%)' : '' )
endfunction

set statusline=%!StatusLine(PerlStatusLine(),'')
