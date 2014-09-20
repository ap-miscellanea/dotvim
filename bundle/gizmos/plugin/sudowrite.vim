function! SudoWrite(file,line1,line2)
	" intercept the external file change reload prompt event
	autocmd FileChangedShell <buffer> :
	" shazzam
	exe 'silent' a:line1 . ',' . a:line2 . 'write !sudo tee 1>/dev/null' strlen(a:file) ? a:file : '%'
	" force-trigger vim's file modification check, then undo the intercept
	checktime | autocmd! FileChangedShell <buffer>
	" if it was a whole-file write, tell vim to consider the buffer saved
	if a:line1 == 1 && a:line2 == line('$') | set nomodified | endif
endfunction

command! -range=% -nargs=? -complete=file W call SudoWrite(<q-args>,<q-line1>,<q-line2>)
