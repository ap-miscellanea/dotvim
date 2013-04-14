if ! has( 'menu' ) | finish | endif

" set up bookmarks menu
exe 'amenu Book&marks.&Settings :e' expand( '<sfile>' ) . '<CR>'
