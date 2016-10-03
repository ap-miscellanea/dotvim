"" this keeps coming up and seems attractive
"" but getting used to it would make stock Vim incredibly annoying to use
"nnoremap ; :
"nnoremap : ;

" Esc for quickly clearing the search highlight
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" run external commands really easily
nnoremap ! :!

" make n/N always mean forward/backward search
" regardless of whether it was done with / or ?
nmap <silent> n /<CR>
nmap <silent> N ?<CR>

" don't jump immediately when using * (but do if it’s the same word again)
nnoremap <silent> * :let b:starjump = @/<CR>*:exe @/ == remove(b:,'starjump') ? '' : "norm! \<C-O>"<CR>

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

" open file in the current buffer’s directory
nnoremap <Leader>e :e <C-R>=substitute(expand('%:h').'/','^\.\?/$','','')<CR>

" I never want to use Ex mode. Map this to something useful?
" But baking it into muscle memory would be counterproductive
" whenever I need to use a stock Vim
nnoremap Q <Nop>

" why do I care about top/bottom of screen?
nnoremap H ^
nnoremap L $

" automatically break undo cycle at certain keys --
" better granularity for undoing insert mode work
inoremap <C-W>   <C-G>u<C-W>

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

" get spelling suggestions in a completion menu, easily
nnoremap <Leader>s a<C-X><C-S>

function s:toggle_greek_keymap()
	let &keymap = len(&keymap) ? '' : 'greek_utf-8'
	return ''
endfunction
" option-/ on Mac US layout
nnoremap <expr> ÷ <SID>toggle_greek_keymap()
inoremap <expr> ÷ <SID>toggle_greek_keymap()

" press Ctrl-R twice to insert the value of the VimL expr currently yanked
inoremap <C-R><C-R> <C-R>=eval(substitute(@","\n$",'',''))<C-M>

" fill in closing tags automatically
function! BeforeCursor(char)
	return a:char == getline('.')[col('.')-2]
endfunction
autocmd FileType * if strlen(&indentexpr) | exe 'inoremap <buffer> <expr> / BeforeCursor("<") ? "/\<C-X>\<C-O>" : "/"' | endif
