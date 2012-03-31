setlocal keywordprg=:help " use internal help fo  keywords in this file

" easier help browsing
nnoremap <buffer><CR> <C-]>
nnoremap <buffer><BS> <C-T>
nnoremap <buffer><Tab> :call search('<Bar>\zs\k*\ze<Bar>')<CR>:echo<CR>
