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
set foldmethod=indent
set foldnestmax=10
set foldenable
set foldlevelstart=10
" Save folds and cursor position when closing buffer
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview
" Fix coc.nvim buffer issue
set splitkeep=screen
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
" Close netrw after opening file
let g:netrw_fastbrowse = 0
" Allows moving between buffers without having to save
set hidden
" Enable creation of backup file
set backup
" Where backups will go
set backupdir=~/.vim/backups
" Where temporary files will go
set directory=~/.vim/tmp
cnoremap w!! w !sudo tee > /dev/null %
set clipboard=unnamed
set rnu
runtime! macros/matchit.vim

packloadall

"vim-slime
" https://github.com/jpalardy/vim-slime
let g:slime_target = "tmux"
let g:slime_paste_file = expand("$HOME/.slime_paste")
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}

" vim-airline
" https://github.com/vim-airline/vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" tender.vim
" https://github.com/jacoborus/tender.vim
if (has("termguicolors"))
  set termguicolors
endif

colorscheme tender

let g:airline_theme='tenderplus'

" vim-test
" https://github.com/vim-test/vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>f :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
let test#strategy = "dispatch_background"
let test#ruby#bundle_exec = 0
let test#ruby#rspec#executable = 'bundle exec rspec'
" if filereadable("docker-compose.yml")
"   let test#ruby#rspec#executable = 'docker-compose exec app bundle exec rspec'
" else
"   let test#ruby#rspec#executable = 'bundle exec rspec'
" endif

nmap <silent> <leader>ru :Dispatch! bundle exec rubocop %<CR>
nmap <silent> <leader>re :Dispatch! bundle exec reek %<CR>

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

" codeium.vim
" https://github.com/prabirshrestha/vim-codeium
let g:codeium_disable_bindings = 1
imap <script><silent><nowait><expr> <C-g> codeium#Accept()
imap <Left>   <Cmd>call codeium#CycleCompletions(1)<CR>
imap <Right>   <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <C-x>   <Cmd>call codeium#Clear()<CR>
nmap <silent> <leader>c <Cmd>call codeium#Chat()<CR>

" Dash.vim
nmap <silent> <leader>d :Dash<CR>

" Handle whitespace for markdown files
autocmd FileType md setlocal shiftwidth=2 tabstop=2
