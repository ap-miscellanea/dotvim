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

		" check if sig mentions any identity and set From: accordingly
		if search( '^@@', 'cW' )
			" abort if there are multiple identities
			if search( '^@@', 'W' )
				call winrestview(saveview)
				try | echoerr 'Multiple identities' | endtry
			endif

			let identity = 'ident_' . matchstr( getline('.'), '^@@ *\zs[^ ]*' )
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

	" check if body mentions any attachments and add header to indicate so
	" and take care to adjust cursor position to match afterwards
	let body = filter( getline( headerbreak + 1, sigbreak ? sigbreak -1 : '$' ), 'v:val !~ "^>"' )
	if match( body, '\c\v<(anbei>|angehängt>|Anhang>|attach)' ) >= 0
		let i = 1
		while i < headerbreak
			if getline(i) =~ '\c^X-Require-Multipart:'
				exe i 'delete'
				if saveview.lnum > i | let saveview.lnum -= 1 | endif
				let headerbreak -= 1
				continue
			endif
			let i += 1
		endwhile
		call append(headerbreak - 1, 'X-Require-Multipart: yes')
		if saveview.lnum >= headerbreak | let saveview.lnum += 1 | endif
		let headerbreak += 1
	endif

	call winrestview(saveview)
endfunction

autocmd BufWritePre <buffer> call s:fixup()
