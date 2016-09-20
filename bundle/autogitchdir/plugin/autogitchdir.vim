" keep current directory synchronised to the basedir of the current buffer,
" paying special attention to netrw stuff

function! ChangeToDirFromBuffer()
	if -1 < index(['help','nofile','acwrite'], &buftype) | return | endif
	if bufname('%') =~ '://' | return | endif
	lcd %:p:h
	if has('win32') | return | endif
	let git_dir = matchstr( system( 'git rev-parse --show-cdup' ), '^.*\ze\n' )
	if isdirectory( git_dir ) | lcd `=git_dir` | endif
endfunction

autocmd BufEnter * call ChangeToDirFromBuffer()
