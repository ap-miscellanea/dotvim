if ! exists( ':filetype' ) | finish | endif

autocmd BufRead,BufNewFile bash-fc-* setfiletype sh

" disable wrapping in most any particular format except email, Markdown, XML and X?HTML
" NB: this needs to be done here and this way so regular text files
" (which have no file type) will have the default wrapping enabled
autocmd FileType * if index(split('text mail markdown xml xhtml html'),&filetype) < 0 | setlocal nowrap list | end