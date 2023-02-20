"----------------------------------------"
"--------- ==> Base config  <== ---------"
"----------------------------------------"
syntax enable
set autoread                        "Automatically update the file when it is modified externally"
if version >= 603
	set helplang=cn
endif
set foldenable
set foldmethod=manual
set novisualbell                    "Turn off Use visual bell instead of call"
set termencoding=utf-8
set clipboard+=unnamed
set nobackup
set noswapfile
set completeopt=longest,menu

function! ElelineFsize(f) abort
  "copied at https://github.com/liuchengxu/eleline.vim/blob/8d9b381089c0285f97601b494264e85bc5b4ce8d/plugin/eleline.vim#L42"
  let l:size = getfsize(expand(a:f))
  if l:size == 0 || l:size == -1 || l:size == -2
    return ''
  endif
  if l:size < 1024
    let size = l:size.' bytes'
  elseif l:size < 1024*1024
    let size = printf('%.1f', l:size/1024.0).'k'
  elseif l:size < 1024*1024*1024
    let size = printf('%.1f', l:size/1024.0/1024.0) . 'm'
  else
    let size = printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g'
  endif
  return '  '.size.' '
endfunction

colorscheme desert                   "set theme"
set statusline=%1*%<%.15F%{ElelineFsize(@%)}%=
set statusline+=%2*%{strftime(\"%d/%m/%y-%H:%M\")}\ 
set statusline+=%3*%Y\ \|\ %{&fenc}\ 
set statusline+=%4*[%l:%v]\ %p%%\ 

hi User1 cterm=none ctermfg=white ctermbg=238
hi User2 cterm=bold ctermfg=darkgrey ctermbg=238
hi User3 cterm=none ctermfg=white ctermbg=238
hi User4 cterm=none ctermfg=yellow ctermbg=darkgray


"----------------------------------------"
"---- ==> Symbol auto-completion <== ----"
"----------------------------------------"
:inoremap ( ()<Left>
:inoremap { {}<Left>
:inoremap [ []<Left>
:inoremap < <><Left>
:inoremap " ""<Left>
:inoremap ' ''<Left>
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap > <c-r>=ClosePair('>')<CR>
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
noremap <F4> :tabnew .<CR>
noremap s :x <CR>
noremap q :q <CR>
noremap ; :
noremap v <C-v>
:inoremap <C-s> <ESC>:x <CR>
:inoremap <C-q> <ESC>:q! <CR>
set autoindent
set expandtab                        "use spaces instead of indents"
set tabstop=4
set softtabstop=4
set shiftwidth=2
set wrap
set cursorline
set mouse=c
set number
