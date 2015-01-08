function! WriteHarder(line1,line2,file)
	call system('sudo -l') | if v:shell_error | echohl ErrorMsg | echo 'Sorry, sudo is not playing ball' | echohl None | return | endif
	augroup SudoWrite
		" intercept the external file change reload prompt event
		autocmd FileChangedShell <buffer> :
		" put it in an env var to avoid the need to shell-quote
		let $VIM_SUDO_FILE = strlen(a:file) ? a:file : expand('%')
		" shazzam
		exe 'silent' a:line1.','.a:line2 . 'write !sudo tee "$VIM_SUDO_FILE" 1> /dev/null'
		" force-trigger vim's file modification check
		checktime
		" now undo the intercept
		autocmd! FileChangedShell <buffer>
	augroup END
	" if it was a whole-file write, tell vim to consider the buffer saved
	if a:line1 == 1 && a:line2 == line('$') | set nomodified | endif
endfunction

command! -range=% -nargs=? -complete=file W call WriteHarder(<q-line1>,<q-line2>,<q-args>)
