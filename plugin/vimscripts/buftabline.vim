" references to mention:
" minibufexpl
" buftabs http://www.vim.org/scripts/script.php?script_id=1664

scriptencoding utf-8

augroup BufTabLine
autocmd!

function! BufTabName(name)
	"return fnamemodify(a:name, ':.')
	"return substitute(fnamemodify(a:name, ':.'),'.*/\ze[^/]\+/[^/]\+$','','')
	return substitute(fnamemodify(a:name, ':.'),'[^/]\zs[^/]\+\ze/','','g')
endfunction

function BufTabLabel(bufnum)
	let buffname   = bufname(a:bufnum)
	let bufactive  = winbufnr(0) == a:bufnum
	let bufvisible = bufwinnr(a:bufnum) > 0
	let bufscratch = index(['nofile','acwrite'], getbufvar(a:bufnum, '&buftype'), 0, 1) != -1
	let buftitle   = strlen(buffname) ? BufTabName(buffname) : bufscratch ? '·Scratch·' : '·No·Name·'
	let highlight  = bufvisible ? '%#TabLineSel#' : '%#TabLine#'
	let indicator  = bufvisible ? '[]' : '  '
	let indhilite  = bufactive ? '%#TabLineSel#' : '%#TabLine#'
	return indhilite.indicator[0] . highlight.buftitle . indhilite.indicator[1] . '%#TabLineFill#'
endfunction

function! BufTabLine()
	let listed_buffers = filter(range(1,bufnr('$')),'buflisted(v:val)')
	return '%0T'.join(map(listed_buffers,'BufTabLabel(v:val)'), '') . '%#TabLineFill#'
endfunction

function! BufTabLineSetup()
	if tabpagenr('$') == 1
		set guioptions-=e tabline=%!BufTabLine()
	else
		set guioptions+=e tabline=
	endif
endfunction

autocmd TabEnter * call BufTabLineSetup()

set showtabline=2
call BufTabLineSetup()
