if ! has( 'wildmenu' ) | finish | endif

set wildmenu
set wildmode=longest:full,list:full
set wildignore+=*.a,*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp
