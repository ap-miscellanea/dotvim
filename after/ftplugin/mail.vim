setlocal expandtab
setlocal textwidth=72
setlocal fencs=utf-8
setlocal spell

" mail.vim links mailSubject to LineNR but that doesn't stand out enough
hi link mailSubject PreProc

autocmd BufEnter <buffer> if search('\n\n\zs') | exe "norm 999\<C-Y>" | endif

function! s:fixup()
	let saveview = winsaveview()

	0norm 0 " start at start of file
	let headerbreak = search( '^$', 'W' )

	let sigbreak = search( '^-- $', 'W' )
	if sigbreak
		" drop additional sigs if there are multiple ones
		if search( '^-- $', 'W' )
			.,$ delete
			exe sigbreak
		endif

		" check if sig mentions any identity and set From: accordingly
		if search( '^@@', 'cW' )
			" abort if there are multiple identities
			if search( '^@@', 'nW' )
				try | echoerr 'Multiple identities' | endtry
			endif

			let identity = matchstr( getline('.'), '^@@ *\zs[^ ]*' )
			delete

			exe '1,'.(headerbreak - 1).'s/\c^From: \?\zs.*/\=identity/e'
		endif
	endif

	" remove trailing whitespace from all lines in the body
	exe (headerbreak + 1).','.(sigbreak ? sigbreak -1 : '$').'s/ \+$//e'

	" delete trailing empty lines
	$ | while search('^\s*$', 'cW') | delete | endwhile

	" delete empty sig
	if search('^-- $', 'cW') | delete | endif

	call winrestview(saveview)
endfunction

autocmd BufWritePre <buffer> call s:fixup()
