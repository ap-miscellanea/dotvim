"" this keeps coming up and seems attractive
"" but getting used to it would make stock Vim incredibly annoying to use
"nnoremap ; :
"nnoremap : ;

" Esc for quickly clearing the search highlight
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" run external commands really easily
nnoremap ! :!

" make n/N always mean forward/backward search
" regardless of whether it was done with / or ?
nmap <silent> n /<CR>
nmap <silent> N ?<CR>

" don't jump immediately when using * (but do if it’s the same word again)
nnoremap <silent> * :let b:starjump = @/<CR>*:exe @/ == remove(b:,'starjump') ? '' : "norm! \<C-O>"<CR>

" open file in the current buffer’s directory
nnoremap <Leader>e :e <C-R>=substitute(expand('%:h').'/','^\.\?/$','','')<CR>

" I never want to use Ex mode. Map this to something useful?
" But baking it into muscle memory would be counterproductive
" whenever I need to use a stock Vim
nnoremap Q <Nop>

" automatically break undo cycle at certain keys --
" better granularity for undoing insert mode work
inoremap <C-W>   <C-G>u<C-W>

" get spelling suggestions in a completion menu, easily
nnoremap <Leader>s a<C-X><C-S>

" option-/ on Mac US layout
noremap  <expr> ÷ ''[setbufvar('%', '&keymap', len(&keymap) ? '' : 'greek_utf-8')]
noremap! <expr> ÷ ''[setbufvar('%', '&keymap', len(&keymap) ? '' : 'greek_utf-8')]

" press Ctrl-R twice to insert the value of the VimL expr currently yanked
inoremap <expr> <C-R><C-R> eval(matchstr(@", '.*[^\n]'))

" fill in closing tags automatically
autocmd FileType * if len(&omnifunc) | exe 'inoremap <buffer> <expr> / getline(".")[col(".")-2] == "<" ? "/\<C-X>\<C-O>" : "/"' | endif
