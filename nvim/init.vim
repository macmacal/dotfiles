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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" YouCompleteMe autocompletion
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 ./install.py --clang-completer' }

"Automatic adding closing brackets
Plug 'jiangmiao/auto-pairs'

"Modify surroudings of sandwiched textobject
Plug 'machakann/vim-sandwich'

"Airline status tabline
Plug 'bling/vim-bufferline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Rainbow brackets
Plug 'frazrepo/vim-rainbow'

"Additonal Icons
" TODO fix conceal in neovim
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
call plug#end()

set encoding=utf8
set guifont=Fira_Code_Nerd_Font:h11
set conceallevel=3

" FZF
let g:loaded_python_provider = 1

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
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

" Rainbow brackets
let g:rainbow_active = 1

" Absolute row numbers and relative row numbers for active window
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" YCM settings
let g:ycm_max_num_candidates = 5
let g:ycm_warning_symbol = '>'
let g:ycm_confirm_extra_conf = 0
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_max_diagnostics_to_display = 0  " Reference: https://github.com/ycm-core/YouCompleteMe/issues/2392

" YCM Error & Warning Color Scheme
" https://jonasjacek.github.io/colors/
hi YcmErrorSection ctermbg=0 cterm=underline
hi YcmWarningSection ctermbg=0 cterm=underline

" KEYBINDINGS
" ###############################################

" Vanilla
"" Windows naviation
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
"" Insert empty line
nnoremap <C-o> :put _<CR>
"" Move lines with alt
nnoremap <A-j> :m+1<CR>
nnoremap <A-k> :m-2<CR>

" YCM
nnoremap <A-b> :YcmCompleter GoTo<CR>  " Go to definition

" NERDTree
nnoremap <C-g> :NERDTreeToggle<CR>

" FZF
nnoremap <C-n> :Files<CR>

" ###############################################
"Fix syntax matching issues (concealing brackets in NERDTree)
syntax enable
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif
autocmd VimEnter * source ~/.config/nvim/init.vim
