" keep current directory synchronised to the basedir of the current buffer,
" paying special attention to netrw stuff

function! ChangeToDirFromBuffer()
	if bufname( '' ) =~ '://' | return | endif
	if &buftype ==? 'help' | return | endif
	lcd %:p:h
	if ! has( "win32" )
		let git_dir = substitute( system( 'git rev-parse --show-toplevel' ), '\n.*', '', '' )
		if isdirectory( git_dir ) | exe 'lcd' git_dir | endif
	endif
endfunction

autocmd BufEnter * call ChangeToDirFromBuffer()

nnoremap <Leader>e :e <C-R>=expand('%:h')<CR>/
