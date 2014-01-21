set nocompatible
scriptencoding utf-8



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" editor behaviour
"

set autoindent        " can't live without it
if has( "&copyindent" )
	set copyindent    " stick to the file's existing indentation format for new indented lines
endif
set tabstop=4         " tabs displayed at 4 columns
set softtabstop=4     " tab key shifts by 4 columns
set shiftwidth=4      " indentation at 4 columns
set nolist            " [will selectively set this later] ensure we don't mess up the tabbing
set listchars=tab:›·,trail:•,nbsp:– " and make it look nice
if has( "&shiftround" )
	set shiftround    " always in-/outdent to next tabstop
endif
set backspace=2       " allow backspacing over indent,eol,start
set nojoinspaces      " don't treat [.?!] specially when joining lines.
set nostartofline     " don't jump to start of line on paging motions
set spelllang=el,de,en_gb
set autowrite         " auto-save prior to :! :make and others
set hidden            " keep current buffer around when :edit'ing another file
set noswapfile        " don't litter
set nobackup          " don't litter
set nowritebackup     " really, don't litter
set confirm           " ask interactively instead of requiring a ! on commands
set history=2000      " 100x the default
set undolevels=5000   " 5x the default
set shortmess+=Is     " supress intro message and search wrap-around message
set shortmess+=mr     " shorten flags [Modified] and [readonly]
set shortmess-=tT     " don't truncate file messages
set viminfo='10000,<50,s10000,h

" Make vim work with the 'crontab -e' command
set backupskip+=/var/spool/cron/*

set formatoptions+=l1
"set formatoptions+=n formatlistpat="^\s*\(\d\+[\]:.)}\t ]\|[*-]\)\s*" " recognize numbered and bulleted lists when formatting

if exists( '&encoding' )
	set encoding=utf-8                      " use UTF-8 internally
	set fileencodings=ucs-bom,utf-8,cp1252  " assume files are UTF-8; if that fails, use Latin1
endif

" when switching buffers, preserve window view
autocmd BufWinLeave * if !&diff | let b:winview = winsaveview() | endif
autocmd BufWinEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | endif

if v:version >= 703
	" some legwork for more serious use of encrypted files
	set cryptmethod=blowfish
	" FIXME smart security, but needs to deal with restoring the settings
	"autocmd BufReadPost * if strlen(&l:key) | set noswapfile nowritebackup viminfo= nobackup noshelltemp history=0 | endif
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" basic display setup
"

set incsearch           " incremental search is convenient
set hlsearch            " ... and search highlighting helpful
set ruler               " show cursor Y,X in status line
set number              " show line numbers
set showcmd             " show (partial) command in status line
set report=1            " threshold for reporting how many lines were affected by a :cmd
set linebreak           " word wrap mode
set scrolloff=4         " scroll file when cursor gets this close to edge of window
if has( "&sidescrolloff" )
	set sidescrolloff=2 " ... or to other edge of window
endif
set winminheight=0      " don't try to keep windows visible
set laststatus=2        " always show status line
set mouse=a             " be mouse-aware, in all modes
set nomousehide         " hidden pointer = disorienting
set lazyredraw          " speed up macros
set noerrorbells        " shut up
set visualbell          " shut up
set t_vb=               " no really, shut up

" set up bookmarks menu
if has( 'menu' ) | exe 'amenu Book&marks.&Settings :e' expand( '<sfile>' ) . '<CR>' | endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings
"

" Esc for quickly clearing the search highlight
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" I never want to use Ex mode. Map this to something useful?
" But baking it into muscle memory would be counterproductive
" whenever I need to use a stock Vim
nnoremap Q <Nop>

" why do I care about top/bottom of screen?
nnoremap H ^
nnoremap L $

" automatically break undo cycle at certain keys --
" better granularity for undoing insert mode work
inoremap <C-W>   <C-G>u<C-W>

" make cmdwin a little nicer to use
autocmd CmdwinEnter * nnoremap <buffer> <C-c> <C-c><C-c>
autocmd CmdwinEnter * inoremap <buffer> <C-c> <C-c><C-c>
autocmd CmdwinEnter * set nonumber

" get spelling suggestions in a completion menu, easily
nnoremap <Leader>s a<C-X><C-S>

function s:toggle_greek_keymap()
	let &keymap = len(&keymap) ? '' : 'greek_utf-8'
	return ''
endfunction
" option-/ on Mac US layout
nnoremap <expr> ÷ <SID>toggle_greek_keymap()
inoremap <expr> ÷ <SID>toggle_greek_keymap()

" press Ctrl-R twice to insert the value of the VimL expr currently yanked
inoremap <C-R><C-R> <C-R>=eval(substitute(@","\n$",'',''))<C-M>

" fill in closing tags automatically
function! BeforeCursor(char)
	return a:char == getline('.')[col('.')-2]
endfunction
autocmd FileType * if strlen(&indentexpr) | exe 'inoremap <buffer> <expr> / BeforeCursor("<") ? "/\<C-X>\<C-O>" : "/"' | endif
