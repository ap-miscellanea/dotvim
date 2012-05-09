if v:version < 700 | finish | endif
if exists('g:qbuf_loaded') && g:qbuf_loaded | finish | endif
let g:qbuf_loaded = 1

function s:run()
	" SETUP =================================================================

	let l:unlisted = 1 - getbufvar('%', '&buflisted')
	let l:cursorbg = synIDattr(hlID('Cursor'),'bg')
	let l:cursorfg = synIDattr(hlID('Cursor'),'fg')
	hi Cursor guibg=NONE guifg=NONE

	let l:lazyredraw = &lazyredraw
	set nolazyredraw

	let l:cmdheight = &cmdheight

	let l:toggle  = ''
	let l:bang    = ''
	let l:cursel  = -1
	let l:refresh =  1

	" figure out what key the user has mapped this to
	if hasmapto(':QBuf<CR>', 'n')
		redir => l:nmap
		silent nmap
		redir END
		let l:mappings = split(l:nmap, "\n")
		let l:line     = l:mappings[match(l:mappings, ':QBuf\>')]
		let l:key      = matchstr(l:line[3:], '[^ ]\+')
		let l:toggle   = eval('"'.escape(l:key, '"<').'"')
		unlet l:nmap
	endif

	try | while 1
		" SCAN ===============================================================

		if l:refresh
			redir => l:ls
			silent ls!
			redir END

			let l:buffers = []

			for l:line in split(l:ls, "\n")
				" see  :help ls  for the string format parsed here

				let l:line_unlisted = l:line[3] == 'u'
				if l:unlisted != l:line_unlisted | continue | endif

				let l:line_active   = l:line[5] =~ '[ah]'
				let l:line_nomodif  = l:line[6] != '-'
				let l:line_modified = l:line[7] == '+'

				if l:unlisted
					if l:line_nomodif && !l:line_active | continue | endif
				endif

				let l:line_num   = str2nr(l:line)
				let l:line_fname = matchstr(l:line, '"\zs[^"]*')

				call add(l:buffers, {
					\'idx' : len(l:buffers),
					\'num' : l:line_num,
					\'vis' : bufwinnr(l:line_num) > 0 ? '[]' : '  ',
					\'name': fnamemodify(l:line_fname, ':t'),
					\'path': fnamemodify(l:line_fname, ':h'),
					\'info': l:unlisted ? (l:line_active ? '[L]' : '') : (l:line_modified ? '[+]' : '')})
			endfor

			unlet l:ls

			let l:idxwidth  = len(l:buffers) ? strlen(l:buffers[-1]['idx']) + l:unlisted : 0
			let l:numwidth  = max(map(copy(l:buffers),'strlen(v:val["num"])'))
			let l:namewidth = max(map(copy(l:buffers),'strlen(v:val["name"])'))
			let l:pathwidth = max(map(copy(l:buffers),'strlen(v:val["path"])'))
		endif

		let l:refresh = 1

		" DRAW ===============================================================

		set cmdheight=1 " vim doesn't draw the menu properly otherwise

		if len(l:buffers) < 1 " probably no unlisted buffers
			let l:unlisted = 1 - l:unlisted " switch mode to try again
			continue
		endif

		if &cmdheight != len(l:buffers)
			let &cmdheight = len(l:buffers)

			if &cmdheight < len(l:buffers)
				set cmdheight=1
				redraw
				echohl ErrorMsg
				echo 'No room to display buffer list'
				echohl None
				break
			endif
		endif

		let l:curbuf = bufnr('')

		for l:buf in l:buffers
			let l:idx = l:buf['idx']

			if l:cursel == -1 && l:buf['num'] == l:curbuf
				let l:cursel = l:idx
			endif

			let l:line = printf(' %*s: %1s %s%*d%s %-*s %3s %-*s ',
				\l:idxwidth,
				\(l:unlisted ? 'U' : '') . (l:idx+1),
				\l:buf['num'] == l:curbuf ? '*' : '',
				\l:buf['vis'][0:0],
				\l:numwidth,
				\l:buf['num'],
				\l:buf['vis'][1:1],
				\l:namewidth,
				\l:buf['name'],
				\l:buf['info'],
				\l:pathwidth,
				\l:buf['path'])

			exe 'echohl' l:idx == l:cursel ? 'PmenuSel' : 'Pmenu'
			echo strpart(l:line, 0, &columns-2).' '
			echohl None
		endfor

		redraw

		" INPUT ==============================================================

		let l:key = getchar()

		" DISPATCH ===========================================================

		if type(l:key) == type(0)
			let l:key = nr2char(l:key)
		end

		if     l:key == "\<Up>"   | let l:key = 'k'
		elseif l:key == "\<Down>" | let l:key = 'j'
		elseif l:key == "\<C-P>"  | let l:key = 'k'
		elseif l:key == "\<C-N>"  | let l:key = 'j'
		elseif l:key == "\<Esc>"  | let l:key = 'q'
		elseif l:key == l:toggle  | let l:key = 'q'
		end

		let l:selbuf = l:buffers[l:cursel]['num']
		let l:selwin = bufwinnr(l:selbuf)

		try
			if l:key == '!'
				let l:bang = l:bang ? '' : '!'
				let l:refresh = 0

			elseif l:key == 'k' " up
				let l:cursel -= 1
				let l:refresh = 0
				let l:bang = ''

			elseif l:key == 'j' " down
				let l:cursel += 1
				let l:refresh = 0
				let l:bang = ''

			elseif l:key == 'u' " hide
				let l:cursel += 1
				exe 'hide buffer' l:selbuf
				let l:bang = ''

			elseif l:key == 's' " split
				exe 'sbuffer' l:selbuf
				let l:bang = ''

			elseif l:key == 'w' " wipeout
				exe 'bwipeout' l:selbuf
				let l:bang = ''

			elseif l:key == 'l' " toggle to un-/listed buffers
				let l:unlisted = 1 - l:unlisted
				let l:cursel = 0
				let l:bang = ''

			elseif l:key == 'c' " close
				if l:selwin == -1
					let l:refresh = 0
				else
					exe l:selwin . 'wincmd w | close' . l:bang
				endif
				let l:bang = ''

			elseif l:key == 'd' " delete
				if l:unlisted
					call setbufvar(l:selbuf, '&buflisted', 1)
				else
					exe 'bdelete'.l:bang l:selbuf
				endif
				let l:bang = ''

			elseif l:key == 'q' " quit
				break

			elseif l:key == 'g' || l:key == "\r"
				if l:selwin == -1
					exe 'buffer'.l:bang l:selbuf
				else
					exe l:selwin . 'wincmd w'
				endif
				if l:key == "\r" | break | endif
				let l:bang = ''

			else
				let l:bang = ''
				let l:refresh = 0

			endif
		catch
			echohl ErrorMsg | echo "\rVIM" matchstr(v:exception, '^Vim(\a*):\zs.*') | echohl None
			call inputsave()
			call getchar()
			call inputrestore()
		endtry

		" wrap around
		let l:cursel += len(l:buffers)
		let l:cursel  = l:cursel % len(l:buffers)
	endwhile | finally
		" TEAR DOWN ==========================================================

		let &cmdheight = l:cmdheight
		let &lazyredraw = l:lazyredraw
		exe printf('hi Cursor guibg=%s guifg=%s', l:cursorbg, l:cursorfg ? l:cursorfg : 'NONE')
		echo
	endtry
endfunc

command QBuf call s:run()
