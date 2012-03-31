" Vim doesn't like huge regexes much: there is a 'Press Enter' prompt whose reason I cannot find
"
function! FindNumbers()
	"let @/ = '\c\%(\<eight\?\|\<one\|\<ten\>\|eleven\|f\%(i\%(ve\|f\)\|our\)\|hundred\|nine\|s\%(even\|ix\)\|t\%(h\%(ir\|ousand\|ree\)\|w\%(e\%(lve\|n\)\|o\)\)\)\%(teen\|ty\)\?'
	 let @/ = '\c\%(\<eight\?\|\<ten\>\|eleven\|f\%(i\%(ve\|f\)\|our\)\|hundred\|nine\|s\%(even\|ix\)\|t\%(h\%(ir\|ousand\|ree\)\|w\%(e\%(lve\|n\)\|o\)\)\)\%(teen\|ty\)\?'
	call search(@/) " evade prompt
endfunction

nnoremap <Leader>n :call FindNumbers()<CR>:set hlsearch<CR>:echo<CR>
