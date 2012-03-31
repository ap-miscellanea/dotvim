setlocal makeprg=tidy\ -q\ %\ 2>&1\ \\\|\ grep\ ^line
setlocal errorformat+=line\ %l\ column\ %*\\d\ -\ %m

" regular autoindent works better for me
setlocal indentexpr=
