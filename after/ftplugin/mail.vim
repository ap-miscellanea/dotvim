setlocal expandtab
setlocal textwidth=72
setlocal fencs=utf-8
setlocal spell

" mail.vim links mailSubject to LineNR but that doesn't stand out enough
hi link mailSubject PreProc

autocmd BufEnter <buffer> if search('\n\n\zs') | exe "norm 999\<C-Y>" | endif

" before saving, remove trailing whitespace from all lines except sig markers
autocmd BufWritePre <buffer> let s:saveview = winsaveview() | silent! %s:\(^--\)\@<! \+$:: | call winrestview(s:saveview) | unlet s:saveview

" before saving, find the first signature in the buffer,
" then find the name in full within it,
" then use that to replace the 'A.' on the From: line
autocmd BufWritePre <buffer> let s:saveview = winsaveview() | silent! 1,/^\n/s!^From:.*\zsA\.\ze Pagaltzis!\= filter( [ matchstr( matchstr( join( getline(1,'$'), "\r" ), '\v\r-- \r\zs([^\r]+(\r|$))*' ), '\v(Aristot(le|eles)|Αριστοτέλης)' ), 'A.' ], 'len(v:val) > 0' )[0] !e | call winrestview(s:saveview) | unlet s:saveview
autocmd BufWritePre <buffer> let s:saveview = winsaveview() | silent! 1,/^\n/s!^From:.*\zsPagaltzis!\= filter( [ matchstr( matchstr( join( getline(1,'$'), "\r" ), '\v\r-- \r\zs([^\r]+(\r|$))*' ), 'Παγκαλτζής' ), 'Pagaltzis' ], 'len(v:val) > 0' )[0] !e | call winrestview(s:saveview) | unlet s:saveview
