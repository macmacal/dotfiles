" Using Vim-Plug manager https://github.com/junegunn/vim-plug
call plug#begin()
"Tool for commenting out lines
Plug 'tpope/vim-sensible'
Plug 'preservim/nerdcommenter'

"NERDTree with extenions
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'hankchiutw/nerdtree-ranger.vim'

"Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"Automatic adding closing brackets
Plug 'jiangmiao/auto-pairs'

"Modify surroudings of sandwiched textobject
Plug 'machakann/vim-sandwich'

call plug#end()

set encoding=utf8
set guifont=JetBrainsMono\ Nerd\ Font\ 11

"Configure NERDTree
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeShowHidden = 1

"Absolute row numbers and relative row numbers for active window
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END


" KEYBINDINGS
" ###############################################

" NERDTree
nnoremap <C-g> :NERDTreeToggle<CR>

" FZF
nnoremap <C-h> :Files<CR>
