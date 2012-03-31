setlocal iskeyword+=:
setlocal makeprg=perl\ -Wc\ %
setlocal errorformat=%m\ at\ %f\ line\ %l%.%#,%-G%.%#
setlocal keywordprg=sh\ -c\ 'perldoc\ -f\ \$1\ \|\|\ perldoc\ \$1'\ --

if has( "win32" )
	" Vim uses a temp file in Windows; Perl's stderr has to be handled corectly
	setlocal shellpipe=1>&2\ 2>
endif
