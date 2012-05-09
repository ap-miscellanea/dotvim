" plugin for https://github.com/burke/matcher

if v:version < 700 | finish | endif
if exists('g:tmopen_loaded') && g:tmopen_loaded | finish | endif
let g:tmopen_loaded = 1

if ! exists('g:tmopen_match_cmd')
	let g:tmopen_match_cmd = 'matcher'
endif

if ! exists('g:tmopen_list_cmd')
	let g:tmopen_list_cmd = 'git ls-files . --cached --exclude-standard --others'
endif

function! s:run()
	let l:list = system( g:tmopen_list_cmd )
	if v:shell_error
		echoerr 'Failed to get file list'
		return
	endif

	let l:lazyredraw = &lazyredraw
	let l:cmdheight = &cmdheight
	let l:query = ''
	let l:requery = 1
	let l:cursel = 0

	" figure out what key the user has mapped this to
	if hasmapto(':TMOpen<CR>', 'n')
		redir => l:nmap
		silent nmap
		redir END
		let l:mappings = split(l:nmap, "\n")
		let l:line     = l:mappings[match(l:mappings, ':TMOpen\>')]
		let l:key      = matchstr(l:line[3:], '[^ ]\+')
		let l:toggle   = eval('"'.escape(l:key, '"<').'"')
		unlet l:nmap
	endif

	try | while 1
		if l:requery
			let l:cursel = 0
			let l:candidates = split( system( g:tmopen_match_cmd . ' ' . l:query, l:list ), "\n" )
		endif
		let l:requery = 1

		set cmdheight=1 " vim doesn't draw the menu properly otherwise
		let &cmdheight = 1 + len(l:candidates)
		redraw

		let l:width = max(map(copy(l:candidates),'strlen(v:val)'))
		for l:idx in range(len(l:candidates))
			exe 'echohl' l:idx == l:cursel ? 'PmenuSel' : 'Pmenu'
			echo strpart(printf('  %-*s', l:width, l:candidates[l:idx]), 0, &columns-2).' '
			echohl None
		endfor

		echo '> '.l:query

		let l:key = getchar()

		if type(l:key) == type(0)
			let l:key = nr2char(l:key)
		endif

		if     l:key == "\<C-P>" | let l:key = "\<Up>"
		elseif l:key == "\<C-N>" | let l:key = "\<Down>"
		elseif l:key == l:toggle | let l:key = "\<Esc>"
		endif

		if l:key == "\<Esc>"
			break
		elseif l:key == "\<Up>"
			let l:cursel -= 1
			let l:requery = 0
		elseif l:key == "\<Down>"
			let l:cursel += 1
			let l:requery = 0
		elseif l:key == "\<CR>"
			exe 'e' l:candidates[l:cursel]
			break
		elseif l:key == "\<BS>"
			let l:query = substitute(l:query, '.$', '', '')
		elseif l:key =~ '^[a-z._\-/]$'
			let l:query .= l:key
		endif

		" wrap around
		let l:cursel += len(l:candidates)
		let l:cursel  = l:cursel % len(l:candidates)
	endwhile | finally
		let &cmdheight = l:cmdheight
		redraw
		let &lazyredraw = l:lazyredraw
		echo ''
	endtry
endfunction

command TMOpen call s:run()
