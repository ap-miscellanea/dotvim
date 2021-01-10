set nocompatible
scriptencoding utf-8


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" editor behaviour
"

set autoindent        " can't live without it
set copyindent        " stick to the file's existing indentation format for new indented lines
set tabstop=4         " tabs displayed at 4 columns
set softtabstop=4     " tab key shifts by 4 columns
set shiftwidth=4      " indentation at 4 columns
set shiftround        " always in-/outdent to next tabstop
set backspace=2       " allow backspacing over indent,eol,start
set nojoinspaces      " don't treat [.?!] specially when joining lines.
set nrformats-=octal  " the heuristic for octals is too broad
set nostartofline     " don't jump to start of line on paging motions
set spelllang=el,de,en_gb
set autowrite         " auto-save prior to :! :make and others
set hidden            " don't throw away changes when :edit'ing another file
set noswapfile        " don't litter
set nobackup          " don't litter
set nowritebackup     " really, don't litter
set confirm           " ask interactively instead of requiring a ! on commands
set history=10000     " 50x the default
set undolevels=5000   " 5x the default
set shortmess+=Is     " supress intro message and search wrap-around message
set shortmess+=mr     " shorten flags [Modified] and [readonly]
set shortmess-=tT     " don't truncate file messages
set viminfo='1000,h   " remove limits on register content size, keep marks for 10x as many files
set viminfo+=f0       " forget user marks in order to forget the jumplist (docs say '0 does that but nope)
set viminfo+=n~/.vim/.var/viminfo " don't litter in $HOME
set directory=~/.vim/.var " ensure swap files do not end up on a network share
set backupdir=~/.vim/.var " ditto backup files

" Make vim work with the 'crontab -e' command
set backupskip+=/var/spool/cron/*

set formatoptions+=l1
"set formatoptions+=n formatlistpat="^\s*\(\d\+[\]:.)}\t ]\|[*-]\)\s*" " recognize numbered and bulleted lists when formatting

if has( 'multi_byte' )
	set encoding=utf-8                      " use UTF-8 internally
	set fileencodings=ucs-bom,utf-8,cp1252  " assume files are UTF-8; if that fails, use Latin1
endif

if has( 'digraphs' )
	digraphs *.   183 " centered dot
	digraphs **  8226 " bullet
	digraphs ?!  8253 " interrobang
	digraphs !?  8253 " interrobang
	digraphs <3  9829 " black heart suit
	digraphs :(  9785 " white frowning face
	digraphs :)  9786 " white smiling face
endif

" works together with autogitchdir to make gf work nicely within projects
set path=.,,**

if has( 'wildmenu' )
	set wildmenu
	set wildmode=longest:full,list:full
	set wildignore+=*.a,*.o
	set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
	set wildignore+=.git,.hg,.svn
	set wildignore+=*~,*.swp,*.tmp
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" basic display setup
"

" must happen before enabling syntax, for some reason:
"let did_install_default_menus = 1 " File Edit Tools Window Help
let did_install_syntax_menu = 1 " Syntax
let no_buffers_menu = 1 " Buffers

if has( 'syntax' ) | syntax enable | endif

if has( 'gui_running' )
	let colors_name='' " keep stock gvimrc from loading a colorscheme
else
	set background=dark
	colorscheme PaperColor
	hi Normal ctermbg=NONE guibg=NONE
endif

set linebreak           " word wrap mode
silent! set breakindent " visually indent continuation lines to match the wrapped line
set nowrap              " but actually disable wrapping (in most filetypes)
set list                " ensure we don't mess up the tabbing
set listchars=tab:›·    " and make that look nice
set listchars+=trail:•  " also ensure we don't miss trailing whitespace
set listchars+=nbsp:—   " make literal non-break spaces visible
set incsearch           " incremental search is convenient
set hlsearch            " ... and search highlighting helpful
set ruler               " show cursor Y,X in status line
set number              " show line numbers
set showcmd             " show (partial) command in status line
set report=1            " threshold for reporting how many lines were affected by a :cmd
set scrolloff=4         " scroll file when cursor gets this close to edge of window
set sidescrolloff=2     " ... or to other edge of window
set winminheight=0      " don't try to keep windows visible
set laststatus=2        " always show status line
set title               " show filename in window title
set mouse=a             " be mouse-aware, in all modes
set nomousehide         " hidden pointer = disorienting
set lazyredraw          " speed up macros
set visualbell t_vb=    " shut up

if has( 'autocmd' )
	filetype plugin indent on
	autocmd filetypedetect BufRead,BufNewFile bash-fc-* call SetFileTypeSH('bash')
	" ... and now the filetypedetect augroup is filled, so this will go last:
	autocmd filetypedetect BufNewFile,BufRead,StdinReadPost * setfiletype unknown
	" ... which makes this reliable:
	exe 'autocmd FileType text,mail,markdown,xml,xhtml,html,unknown setlocal wrap'
		\ exists( '&breakindent' ) ? '' : 'nolist'
		" setting &list breaks &linebreak in Vims that do not have &breakindent
endif

" set up bookmarks menu
if has( 'menu' ) | exe 'anoremenu 100.9999 Book&marks.&Settings :e' expand( '<sfile>' ) . '<CR>' | endif

" when switching buffers, preserve window view
autocmd BufWinLeave * if !&diff | let b:winview = winsaveview() | endif
autocmd BufWinEnter * if !&diff | call winrestview(get(b:,'winview',{})) | unlet! b:winview | endif

" not needed there
autocmd CmdwinEnter * set nonumber


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings
"

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
inoremap <C-W> <C-G>u<C-W>

" get spelling suggestions in a completion menu, easily
nnoremap <Leader>s a<C-X><C-S>

" option-/ on Mac US layout
noremap  <expr> ÷ ''[setbufvar('%', '&keymap', len(&keymap) ? '' : 'greek_utf-8')]
noremap! <expr> ÷ ''[setbufvar('%', '&keymap', len(&keymap) ? '' : 'greek_utf-8')]

" press Ctrl-R twice to insert the value of the VimL expr currently yanked
inoremap <expr> <C-R><C-R> eval(matchstr(@", '.*[^\n]'))

" fill in closing tags automatically
autocmd FileType * if len(&omnifunc) | exe 'inoremap <buffer> <expr> / getline(".")[col(".")-2] == "<" ? "/\<C-X>\<C-O>" : "/"' | endif

vnoremap < <gv
vnoremap > >gv

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" commands
"

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

if has( 'autocmd' )
	command! -nargs=+ Man delcommand Man | runtime ftplugin/man.vim | Man <args>
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin settings
"

" :help matchit
runtime macros/matchit.vim

" :help ft-perl-syntax
let g:perl_include_pod = 1 " include POD syntax highlighting

" :help ft-sh-syntax
let g:is_posix = 1 " assume POSIX by default, not original Bourne shell

let g:togglecursor_default = 'block'
let g:togglecursor_insert  = 'line'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin loading setup
"                       (must be done before Vim starts its scan for plugins)

call runtimepath#setup() " add plugin bundles to &runtimepath
call stockless#setup() " suppress the stock Vim plugins
