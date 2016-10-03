" this can be called at the very end of vimrc to suppress loading the stock Vim plugins
function stockless#setup()
	let g:real_rtp = &runtimepath
	set rtp-=$VIMRUNTIME
	if &rtp == g:real_rtp | unlet g:real_rtp | return | endif
	" if Vim goes to source anything else whatsoever, fix &runtimepath first
	augroup Stockless
	autocmd SourcePre * let &runtimepath = remove(g:,'real_rtp') | exe 'autocmd! Stockless' | exe 'augroup! Stockless'
	augroup END
endfunc
