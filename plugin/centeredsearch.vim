" always put search match in the center of the screen
let g:centeronsearch = "zzzv"
autocmd InsertEnter * let g:centeronsearch = "\<C-O>zz\<C-O>zv"
autocmd InsertLeave * let g:centeronsearch = "zzzv"
cnoremap <expr> <CR> "\<CR>" . ( getcmdtype() =~ "[/?]" ? g:centeronsearch : "" )
function s:CenterOnOperatorPendingSearch(key)
	let g:centeronsearch = "\<C-O>zz\<C-O>zv\<C-O>:let g:centeronsearch = 'zzzv'\<CR>"
	return a:key
endfunction
omap <expr> / <SID>CenterOnOperatorPendingSearch("/")
omap <expr> ? <SID>CenterOnOperatorPendingSearch("?")
