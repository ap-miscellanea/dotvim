" references to mention:
" minibufexpl
" buftabs http://www.vim.org/scripts/script.php?script_id=1664

scriptencoding utf-8

augroup BufTabLine
autocmd!

function! BufTabName(name)
	"return fnamemodify(a:name, ':.')
	"return substitute(fnamemodify(a:name, ':.'),'.*/\ze[^/]\+/[^/]\+$','','')
	"return substitute(fnamemodify(a:name, ':.'),'[^/]\zs[^/]\+\ze/','','g')
	return substitute(substitute(fnamemodify(a:name, ':.'),'[^/]\zs[^/]\+\ze/[^/]\+/','','g'),'\(/\|^\)\@<![aieou]\ze.*/','','g')
endfunction

function BufTabLabel(bufnum)
	let buffname   = bufname(a:bufnum)
	let bufscratch = index(['nofile','acwrite'], getbufvar(a:bufnum, '&buftype'), 0, 1) != -1
	return {
		\ 'num'    : a:bufnum,
		\ 'title'  : strlen(buffname) ? BufTabName(buffname) : bufscratch ? '·Scratch·' : '·No·Name·',
		\ 'visible': bufwinnr(a:bufnum) > 0,
		\ 'active' : winbufnr(0) == a:bufnum,
		\ }
endfunction

function BufTabLabelRender(buf)
	let highlight  = a:buf.visible ? '%#TabLineSel#' : '%#TabLine#'
	let indicator  = a:buf.visible ? '[]' : '  '
	let indhilite  = a:buf.active ? '%#TabLineSel#' : '%#TabLine#'
	return indhilite .indicator[0]  . highlight .a:buf.title  . indhilite .indicator[1]  . '%#TabLineFill#'
endfunction

function! BufTabLine()
	let tabline = []
	" help buffers are always unlisted, but quickfix windows are not
	for bnum in filter(range(1,bufnr('$')),'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')
		let tabline += [BufTabLabel(bnum)]
	endfor
	return '%0T'.join(map(tabline,'BufTabLabelRender(v:val)'), '') . '%#TabLineFill#'
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
