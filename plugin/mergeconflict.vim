" MergeConflict: a vimdiff-based way to view and edit cvs-conflict containing files
" Author:	Charles E. Campbell, Jr.
" Date:		Sep 28, 2005
" Version:	1
" Copyright:    Copyright (C) 2005 Charles E. Campbell, Jr. {{{1
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               MergeConflict.vim is provided *as is* and comes with no warranty
"               of any kind, either expressed or implied. By using this
"               plugin, you agree that in no event will the copyright
"               holder be liable for any damages resulting from the use
"               of this software.
" GetLatestVimScripts: 1370 1 :AutoInstall: MergeConflict.vim

" ---------------------------------------------------------------------
" Load Once: {{{1
if exists("g:loaded_MergeConflict") || &cp
 finish
endif
let g:loaded_MergeConflict = "v1"
let s:keepcpo            = &cpo
set cpo&vim

" ---------------------------------------------------------------------
"  Public Interface:	{{{1
com! MergeConflict	call <SID>MergeConflict()

" ---------------------------------------------------------------------
" MergeConflict: this function splits the current, presumably {{{1
"              cvs-conflict'ed file into two versions, and then applies
"              vimdiff.  The original file is left untouched.
fun! s:MergeConflict()
  " sanity check
  if !search('^>>>>>>>','nw')
   echohl ErrorMsg | echo 'MergeConflict: no conflict markers present'
   return
  endif

  " construct A and B files
  let curfile = expand("%")
  let f_ours = curfile.".OURS"
  let f_theirs = curfile.".THEIRS"

  " check if f_ours or f_theirs already exists (as a file).  Although MergeConflict
  " doesn't write these files, I don't want to have a user inadvertently
  " writing over such a file.
  if filereadable(f_ours)
   echohl WarningMsg | echo 'MergeConflict:' f_ours 'already exists'
   return
  endif
  if filereadable(f_theirs)
   echohl WarningMsg | echo 'MergeConflict:' f_theirs 'already exists'
   return
  endif

  let ft=&ft
  let srcbuf=winbufnr(0)

  " left window: ours
  silent vnew
  call append(0, getbufline(srcbuf, 1, '$'))
  $d
  exe 'silent file' f_ours
  " remove sections between '=======' and '>>>>>>>' and the '<<<<<<<' line
  silent g/^=======/.;/^>>>>>>>/d
  silent g/^<<<<<<</d
  set nomod
  let &ft=ft

  " right window: theirs
  wincmd l
  exe 'silent file' f_theirs
  " remove sections between '>>>>>>>' and '=======' and the '<<<<<<<' line
  silent g/^<<<<<<</.;/^=======/d
  silent g/^>>>>>>>/d
  set nomod
  let &ft=ft

  diffthis
  wincmd h
  diffthis

endfun

" ---------------------------------------------------------------------
"  Restore Cpo: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: ts=4 fdm=marker
