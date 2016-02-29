function stockless#hidevimruntime()
	let g:real_rtp = &runtimepath
	let rt = escape( $VIMRUNTIME, '\' )
	let &rtp = substitute( &rtp, '\v(^|,)\V'.rt.'\v(,|$)', '\=(submatch(1).submatch(2))[0]', 'g' )
endfunc

" this can be called at the very end of vimrc to suppress loading the stock Vim plugins
function stockless#auto()
	call stockless#hidevimruntime()
	" if Vim goes to source anything else whatsoever, fix &runtimepath first
	augroup Stockless
		autocmd SourcePre * call stockless#unhidevimruntime()
	augroup END
endfunc

function stockless#unhidevimruntime()
	if exists('g:real_rtp')
		let &runtimepath = g:real_rtp
		unlet g:real_rtp
	endif
	if exists('#Stockless')
		autocmd! Stockless
		augroup! Stockless
	endif
endfunc
