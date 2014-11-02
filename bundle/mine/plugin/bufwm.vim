function! s:KeepSwitching(cmd)
	exe a:cmd
	if winnr('$') < 2 | return | endif
	let curwin = winnr()
	let origbuf = winbufnr(curwin)
	let windows = range(1,winnr('$'))
	while len(filter(windows, 'winbufnr(v:val) == winbufnr(curwin)')) > 1
		exe a:cmd
		if winbufnr(curwin) == origbuf | break | endif
	endwhile
	return
endfunction

function! s:DeleteBuffer()
	bwipeout | return
	" XXX just make it not annoying for now, address the FIXMEs later




	if index(['help','quickfix'],&buftype,0,1) != -1
		bwipeout
		return
	endif
	bprev " attach another buffer to to the window to keep it alive
	" FIXME if no available buffer, create one and switch explicitly to it
	" FIXME buffer can be attached to any number of windows! need a loop
	bwipeout #
endfunction

" quick buffer switching
nnoremap <silent> <C-N> :call<Space><SID>KeepSwitching('bnext')<CR><C-G>
nnoremap <silent> <C-P> :call<Space><SID>KeepSwitching('bprev')<CR><C-G>

" I delete buffers a lot
nnoremap <silent> ZD :call<Space><SID>DeleteBuffer()<CR><C-G>

" missing ZZ counterpart
nnoremap <silent> ZS :w<CR>
