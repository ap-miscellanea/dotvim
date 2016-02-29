" set up &runtimepath to load the bundles
" this must be done before Vim starts its scan for plugins
call runtimepath#setup()

" core Vim configuration, split across files
runtime! vimrc.d/*.vim

" plugin configurations, which sometimes must be done before loading
runtime! vimrc.d/pluginprefs/*.vim

" suppress loading of the stock Vim plugins
call stockless#auto()
