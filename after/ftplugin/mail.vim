setlocal expandtab
setlocal textwidth=72
setlocal fencs=utf-8
setlocal spell

if search('^$') | exe 'norm j0' | endif

" mail.vim links mailSubject to LineNR but that doesn't stand out enough
hi link mailSubject PreProc

" when saving mail, remove trailing whitespace from all lines except sig markers
autocmd BufWritePre <buffer> let s:saveview = winsaveview() | silent! %s:\(^--\)\@<! \+$:: | call winrestview(s:saveview) | unlet s:saveview

" nicer From: line for my emails: if it's a `mail` buffer, then before
" saving, find the first signature in the buffer, find the name in full
" within it, and use that to replace the 'A.' on the From: line
autocmd BufWritePre <buffer> let s:saveview = winsaveview() | silent! 1,/^\n/s!^From:.*\zsA\.\ze Pagaltzis!\= filter( [ matchstr( matchstr( join( getline(1,'$'), "\r" ), '\v\r-- \r\zs([^\r]+(\r|$))*' ), '\v(Aristot(le|eles)|Αριστοτέλης)' ), 'A.' ], 'len(v:val) > 0' )[0] !e | call winrestview(s:saveview) | unlet s:saveview
autocmd BufWritePre <buffer> let s:saveview = winsaveview() | silent! 1,/^\n/s!^From:.*\zsPagaltzis!\= filter( [ matchstr( matchstr( join( getline(1,'$'), "\r" ), '\v\r-- \r\zs([^\r]+(\r|$))*' ), 'Παγκαλτζής' ), 'Pagaltzis' ], 'len(v:val) > 0' )[0] !e | call winrestview(s:saveview) | unlet s:saveview
