command! R enew | setlocal buftype=nofile bufhidden=hide noswapfile

command! FindMarker /\([<=>|]\)\1\{6}/

command! -range DecodeURI <line1>,<line2>s/%\([0-9A-F]\{2}\)/\=nr2char('0x'.submatch(1))/g

command! -range TidyHTML <line1>,<line2>!tidyp -q -utf8 -config ~/.tidy.conf.unintrusive

function s:ClearUndo()
	let saved = [&undolevels, &modified]
	set undolevels=-1
	call setline('.', getline('.'))
	let [&undolevels, &modified] = saved
endfunction
command! ClearUndo call s:ClearUndo()

command! SynDebug echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

if exists( ':filetype' )
	command! -nargs=+ Man delcommand Man | runtime ftplugin/man.vim | Man <args>
endif
