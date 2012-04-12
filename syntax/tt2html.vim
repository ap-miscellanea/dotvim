" Vim syntax file
" Language: TT2 ( Inner HTML )
" Last Change:  16 May 2007
" Maintainar:   Atsushi Moriki <4woods+vim@gmail.com>

if exists("b:current_syntax")
    finish
endif

runtime! syntax/html.vim
unlet b:current_syntax

runtime! syntax/tt2.vim
unlet b:current_syntax

syn cluster htmlPreProc add=@tt2_top_cluster

let b:current_syntax = "tt2html"
