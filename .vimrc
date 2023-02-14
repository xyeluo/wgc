"----------------------------------------"
"--------- ==> Base config  <== ---------"
"----------------------------------------"
set laststatus=2
syntax enable
set statusline=%f\ %m%=[%{&ff}]\ [%{&fenc}]\ [%Y]\ [%l,%v][%L(%p%%)]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}\ 
set nocompatible                "Disable vi compatibility mode"
set autoread                    "Automatically update the file when it is modified externally"
if version >= 603
	set helplang=cn
endif
set foldenable
set foldmethod=manual
set novisualbell                "Turn off Use visual bell instead of call"
set termencoding=utf-8
set clipboard+=unnamed
set nobackup
set noswapfile

"----------------------------------------"
"- ==> Complies with autocompletion <== -"
"----------------------------------------"
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
inoremap < <><ESC>i
inoremap > <c-r>=ClosePair('>')<CR>
function! ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endfunction

"----------------------------------------"
"------------ ==> Other  <== ------------"
"----------------------------------------"
map <F4> :tabnew .<CR>
set autoindent
set expandtab                   "use spaces instead of indents"
set tabstop=4
set softtabstop=4
set shiftwidth=2
set wrap
set cursorline
set mouse=c
set number
set background=dark
