":set autoindent
:set number
:set showmode
:set title
:set showcmd
:set showmatch
:set laststatus=2


:syntax on
":set smartindent
:set expandtab
:set ts=4 sw=4 sts=0
:set ignorecase
:set smartcase
:set wrapscan

"myconf
"ruby
function! s:Run()
    exe "!" . &ft . " %"
:endfunction
command! Run call <SID>Run()
map <F5>    :call <SID>Run()<CR>

"vim-ruby
set expandtab
set nocompatible
filetype on
filetype indent on
filetype plugin on
set autoindent
