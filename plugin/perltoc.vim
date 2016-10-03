function s:quickfix_perl_toc()
	cclose
	call setqflist([])
	let view = winsaveview()
	g/^sub /caddexpr printf('%s:%d:%s', expand('%:p'), line('.'), getline('.'))
	call winrestview(view)
	if ! len(getqflist()) | return | endif
	exe 'cope' min([ &lines, len(getqflist()) ])
	syntax match qfFilenameConceal '[^|]\+' conceal containedin=qfFileName contained
	setlocal concealcursor=nc conceallevel=2
	nmap <buffer> <CR> <CR>:ccl<CR>
endfunction
nnoremap <silent> <Leader>i :call <SID>quickfix_perl_toc()<CR>
