set nocompatible
scriptencoding utf-8

" see also: plugin/commands.vim plugin/mappings.vim


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" editor behaviour
"

set autoindent        " can't live without it
if exists( '&copyindent' )
	set copyindent    " stick to the file's existing indentation format for new indented lines
endif
set tabstop=4         " tabs displayed at 4 columns
set softtabstop=4     " tab key shifts by 4 columns
set shiftwidth=4      " indentation at 4 columns
if exists( '&shiftround' )
	set shiftround    " always in-/outdent to next tabstop
endif
set backspace=2       " allow backspacing over indent,eol,start
set nojoinspaces      " don't treat [.?!] specially when joining lines.
set nostartofline     " don't jump to start of line on paging motions
set spelllang=el,de,en_gb
set autowrite         " auto-save prior to :! :make and others
set hidden            " don't throw away changes when :edit'ing another file
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

if has( 'digraphs' )
	digraphs *.   183 " centered dot
	digraphs **  8226 " bullet
	digraphs ?!  8253 " interrobang
	digraphs !?  8253 " interrobang
	digraphs <3  9829 " black heart suit
	digraphs :(  9785 " white frowning face
	digraphs :)  9786 " white smiling face
endif

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

if has( 'syntax' ) | syntax enable | endif

if has( 'gui_running' )
	let colors_name='' " keep stock gvimrc from loading a colorscheme
elseif exists( ':colorscheme' )
	set background=dark
	colorscheme PaperColor
	hi Normal ctermbg=NONE
endif

if exists( '&breakindent' )
	set breakindent     " visually indent continuation lines to match the wrapped line
endif
set linebreak           " word wrap mode
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
if exists( '&sidescrolloff' )
	set sidescrolloff=2 " ... or to other edge of window
endif
set winminheight=0      " don't try to keep windows visible
set laststatus=2        " always show status line
set title               " show filename in window title
set mouse=a             " be mouse-aware, in all modes
set nomousehide         " hidden pointer = disorienting
set lazyredraw          " speed up macros
set noerrorbells        " shut up
set visualbell          " shut up
set t_vb=               " no really, shut up

if exists( ':filetype' )
	filetype plugin indent on
	" ... and now the filetypedetect augroup is filled, so this will go last:
	autocmd filetypedetect BufNewFile,BufRead,StdinReadPost * setfiletype unknown
	" ... which makes this reliable:
	exe 'autocmd FileType text,mail,markdown,xml,xhtml,html,unknown setlocal wrap'
		\ exists( '&breakindent' ) ? '' : 'nolist'
		" setting &list breaks &linebreak in Vims that do not have &breakindent
endif

" set up bookmarks menu
if has( 'menu' ) | exe 'anoremenu Book&marks.&Settings :e' expand( '<sfile>' ) . '<CR>' | endif

" when switching buffers, preserve window view
autocmd BufWinLeave * if !&diff | let b:winview = winsaveview() | endif
autocmd BufWinEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | endif

" not needed there
autocmd CmdwinEnter * set nonumber


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin loading setup (must be done before Vim starts its scan for plugins)
"

call runtimepath#setup() " add plugin bundles to &runtimepath
call stockless#auto() " suppress the stock Vim plugins
