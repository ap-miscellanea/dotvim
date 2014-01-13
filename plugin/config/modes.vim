if has( 'syntax' ) | syntax enable | endif

if exists( ':filetype' )
	filetype plugin indent on
	" disable wrapping in most any particular format
	" but enable it in email, Markdown, XML and X?HTML
	" NB: this needs to be done here and this way so regular text files
	" (which have no file type) will have the default wrapping enabled
	autocmd FileType * setlocal nowrap | setlocal list
	autocmd FileType {text,mail,mkd,xml,xhtml,html} setlocal wrap | setlocal nolist
endif
