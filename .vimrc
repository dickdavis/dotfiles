" Loads the installed plugins
execute pathogen#infect()
" Enables syntax highlighting
syntax enable
" Enables filetype detection and indentation
filetype on
filetype plugin on
filetype indent on
" Tells vim to recognize es6 files as javascript
autocmd BufRead,BufNewFile *.es6 setfiletype javascript
" Sets file to be used for ctags references
set tags=./tags;
" Lets vim know to expect a dark background
set background=dark
" Enable error files & error jumping.
set cf
" Number of things to remember in history.
set history=256
" Ruler on
set ruler
" Line numbers on
set nu
" Line wrapping off
set nowrap
" Time to wait after ESC (default causes an annoying delay)
set timeoutlen=250
" Tabs are 2 spaces
set ts=2
" Backspace over everything in insert mode
set bs=2
" Tabs under smart indent
set shiftwidth=2
" Disable compatibility mode; enables incremental search
set nocp incsearch
" Sets indentation options
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
set cindent
set autoindent
set smarttab
set expandtab
" Show matching brackets
set showmatch
" Bracket blinking.
set mat=5
" Makes whitespace characters visible
set list
" Show $ at end of line and trailing space as ~
set lcs=tab:\ \ ,trail:~,extends:>,precedes:<
" No blinking
set novisualbell
" No noise
set noerrorbells
" Always show status line
set laststatus=2
" Enables visual search and replace
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
" Maps buffer cycling to arrow keys
map <left> :bprevious<CR>
map <right> :bnext<CR>
" Enable creation of backup file
set backup
" Where backups will go
set backupdir=~/.vim/backups
" Where temporary files will go
set directory=~/.vim/tmp
cnoremap w!! w !sudo tee > /dev/null %
set rnu
runtime! macros/matchit.vim

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_javascript_checkers = ['eslint']

" Vim-Slime
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"

" Vim-Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='molokai'

" Vim-RSpec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
let g:rspec_command = "!bundle exec rspec --drb {spec}"
