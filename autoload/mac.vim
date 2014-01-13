function! mac#get_desktop_resolution()
	let script = 'tell application "Finder" to get bounds of window of desktop'
	let cmd = printf('osascript -e %s', shellescape(script))
	let [x0,y0,x1,y1] = split(system(cmd), '[^0-9]\+')
	return [x1-x0, y1-y0]
endfunction
