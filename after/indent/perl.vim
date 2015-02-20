setlocal indentexpr=GetMyPerlIndent()

function! GetMyPerlIndent()
	let ind = GetPerlIndent()

	if v:lnum > 1
		if getline(v:lnum) =~ '^\s*\(or\|and\)\>'
			if getline(v:lnum - 1) =~ '^\s*if\>'
				let ind -= &sw
			endif
		endif
	endif

	return ind
endfunction
