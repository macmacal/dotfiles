" Using Vim-Plug manager https://github.com/junegunn/vim-plug
call plug#begin()
"Minimalistc configuration
Plug 'tpope/vim-sensible'

"Tool for commenting out lines
Plug 'preservim/nerdcommenter'

"NERDTree with extenions
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'hankchiutw/nerdtree-ranger.vim'

"Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" YouCompleteMe autocompletion
"Plug 'ycm-core/YouCompleteMe' 

"Automatic adding closing brackets
Plug 'jiangmiao/auto-pairs'

"Modify surroudings of sandwiched textobject
Plug 'machakann/vim-sandwich'

"Airline status tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Rainbow brackets
Plug 'frazrepo/vim-rainbow'

"Additonal Icons
Plug 'ryanoasis/vim-devicons'
call plug#end()

set encoding=utf8
set guifont=JetBrainsMono\ Nerd\ Font\ 11

"Airline setup
let g:airline_powerline_fonts = 1
let g:airline_theme='badwolf'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

"NERDCommenter
let leader = '\'
filetype plugin on
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1
let g:NERDDefaultAlign = 'left'

"Configure NERDTree
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeShowHidden = 1

" Rainbow brackets
let g:rainbow_active = 1

" Absolute row numbers and relative row numbers for active window
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END


" KEYBINDINGS
" ###############################################

" Vanilla
"" Windows naviation
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" NERDTree
nnoremap <C-g> :NERDTreeToggle<CR>

" FZF
nnoremap <C-n> :Files<CR>
