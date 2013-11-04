if has( 'gui_win32' )
	let g:netrw_cygwin = 0
	let g:netrw_ssh_cmd  = 'C:\Programme\PuTTY\plink.exe'
	let g:netrw_scp_cmd  = 'C:\Programme\PuTTY\pscp.exe -batch -q -scp'
	let g:netrw_sftp_cmd = 'C:\Programme\PuTTY\pscp.exe -batch -q -sftp'
else
	" some silly servers refuse to respond to user agents that they assume to be spiders
	let g:netrw_http_cmd  = printf("wget -U 'Vim %d.%d (netrw)' -O", v:version / 100, v:version % 100)
endif

let g:netrw_liststyle = 3 " default to tree view
