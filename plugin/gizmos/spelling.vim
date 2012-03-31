let s:allowed_langs = [ 'en_gb', 'de', 'el' ]

function! UnsetLanguage()
	if exists( 's:save_spell' )
		exe 'setl' s:save_spell
		unlet s:save_spell
	endif
	set keymap=
	unlet s:lang
	echohl ModeMsg
	echo 'Language off'
	echohl None
endfunction

function! SetLanguage(lang)
	if index(s:allowed_langs, a:lang) < 0 | throw 'Language "'.a:lang.'" not in list' | endif
	if ! exists( 's:save_spell' )
		let s:save_spell=( &spell ? 'spell' : 'nospell' ) . ' spelllang=' . &spelllang
	endif
	exe 'setl spell spelllang=' . a:lang
	exe 'set keymap=' . ( a:lang == 'el' ? 'greek_utf-8' : '' )
	let s:lang = a:lang
	echohl ModeMsg
	echon 'Language: [' a:lang ']'
	echohl None
endfunction

function! CycleLanguage()
	let next = 0
	if exists( 's:lang' )
		let next = index( s:allowed_langs, s:lang ) + 1
	endif
	if next >= len( s:allowed_langs )
		call UnsetLanguage()
	else
		call SetLanguage( s:allowed_langs[next] )
	endif
endfunction

nnoremap <Leader><Leader> :call CycleLanguage()<CR>

" automatically enable spellcheck for mails and Markdown documents
autocmd FileType {mail,mkd} call SetLanguage('en_gb')
