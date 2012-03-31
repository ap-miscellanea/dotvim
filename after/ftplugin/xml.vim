" regular autoindent works better for me
setlocal indentexpr=

" XML = nesting, which makes 4 places per tab way too much
setlocal ts=2 sw=2 sts=2

" make it possible to autocomplete tag names with hyphens in them
setlocal iskeyword=@,-,\:,48-57,_,128-167,224-235
