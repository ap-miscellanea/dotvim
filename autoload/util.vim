function util#flatten(list_of_lists)
	let result = []
	for list in a:list_of_lists
		call extend( result, list )
	endfor
	return result
endfunc

function util#globpathlist(path, wildcards)
	" pass either a single wildcard or a list
	let wildcards = type(a:wildcards) == type("") ? [a:wildcards] : a:wildcards
	return sort( util#flatten( map( wildcards, 'split( globpath( a:path, v:val ), "\n" )' ) ) )
endfunc
