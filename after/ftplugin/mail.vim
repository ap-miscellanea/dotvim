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
		" abort if there are multiple sigs
		if search( '^-- $', 'W' )
			call winrestview(saveview)
			try | echoerr 'Multiple signatures' | endtry
		endif

		let signature = join( getline( sigbreak + 1, '$' ), "\r" )

		let firstname = matchstr( signature, '\v(Aristot(le|eles)|Αριστοτέλης)' )
		if len(firstname)
			1,/^$/s!^From:.*\zsA\.\ze Pagaltzis!\= firstname!e
		endif

		let surname = matchstr( signature, '\v(Pagaltzis|Παγκαλτζής)')
		if len(surname)
			1,/^$/s!^From:.*\zsPagaltzis!\= surname !e
		endif
	endif

	" remove trailing whitespace from all lines in the body
	exe (headerbreak + 1).','.(sigbreak ? sigbreak -1 : '$').'s/ \+$//e'

	" delete trailing empty lines
	$ | while search('^\s*$', 'cW') | delete | endwhile

	call winrestview(saveview)
endfunction

autocmd BufWritePre <buffer> call s:fixup()
