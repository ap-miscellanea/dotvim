function! s:KeepSwitching(cmd)
	exe a:cmd
	" now we will check whether this buffer is shown in another window
	if winnr('$') < 2 | return | endif
	let curwin = winnr()
	let origbuf = winbufnr(curwin) " remember where we started
	let windows = range(1,winnr('$'))
	" if this buffer is already shown in another window, switch and check again
	while len(filter(windows[:], 'winbufnr(v:val) == winbufnr(curwin)')) > 1
		exe a:cmd
		if winbufnr(curwin) == origbuf | break | endif " endless loop breaker
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
