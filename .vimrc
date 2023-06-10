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
" Allows moving between buffers without having to save
set hidden
" Enable creation of backup file
set backup
" Where backups will go
set backupdir=~/.vim/backups
" Where temporary files will go
set directory=~/.vim/tmp
cnoremap w!! w !sudo tee > /dev/null %
set rnu
syntax enable
runtime! macros/matchit.vim

packloadall

" syntastic
" https://github.com/vim-syntastic/syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': ['ruby', 'javascript'] }
let g:syntastic_filetype_map = {"javascriptreact": "javascript", "typescriptreact": "typescript"}
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exe= '[ -f $(npm bin)/eslint ' . expand('%:p') . ' && $(npm bin)/eslint ' . expand('%:p') . ' || eslint ' . expand('%:p')
let g:syntastic_sass_checkers = ['stylelint']

" vim-slime
" https://github.com/jpalardy/vim-slime
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"

colorscheme sorbet

" vim-airline
" https://github.com/vim-airline/vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" vim-airline-themes
" https://github.com/vim-airline/vim-airline-themes
let g:airline_theme='molokai'

" vim-test
" https://github.com/vim-test/vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>f :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
let test#strategy = "dispatch"
let test#ruby#bundle_exec = 0
if filereadable("docker-compose.yml")
  let test#ruby#rspec#executable = 'docker-compose exec web bundle exec rspec'
else
  let test#ruby#rspec#executable = 'bundle exec rspec'
endif

" vim-rails
" https://github.com/tpope/vim-rails
let g:rails_projections = {
      \ "app/controllers/*_controller.rb": {
      \   "command": "controller",
      \   "test": [
      \     "spec/requests/{}_controller_spec.rb"
      \   ]
      \ }}

" vim-fugitive
" https://github.com/tpope/vim-fugitive
hi DiffAdd guifg=NONE ctermfg=46 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiffChange guifg=NONE ctermfg=190  guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiffDelete guifg=NONE ctermfg=203 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiffText guifg=NONE ctermfg=190 guibg=NONE ctermbg=NONE gui=NONE cterm=REVERSE

" vim-ags
" https://github.com/gabesoft/vim-ags
