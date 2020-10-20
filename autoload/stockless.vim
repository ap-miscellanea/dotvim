" this suppresses loading the stock Vim plugins; MUST be called at the very end of vimrc
function stockless#setup()
	let g:rt_marker = repeat( '.', strlen( $VIMRUNTIME ) )
	let real_rtp = &rtp
	call stockless#replace( $VIMRUNTIME, g:rt_marker )
	if &rtp == real_rtp | return | endif
	" if Vim goes to source anything else whatsoever, fix &runtimepath first
	augroup Stockless
	autocmd SourcePre * call stockless#replace( remove(g:,'rt_marker'), $VIMRUNTIME ) | exe 'autocmd! Stockless' | exe 'augroup! Stockless'
	augroup END
endfunc

function stockless#replace(before, after)
	let &rtp = join( split( &rtp, '\v(^|,)\zs\V' . escape( a:before, '\\' ) . '\v\ze(,|$)', 1 ), a:after )
endfunc
