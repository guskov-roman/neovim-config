 " automatically downloads vim-plug to your machine if not found.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

    Plug 'tpope/vim-fugitive'
    "Plug 'tpope/vim-commentary'
    "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    "Plug 'junegunn/fzf.vim'
    Plug 'preservim/tagbar'
    Plug 'preservim/nerdtree'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Lightline status line and buffer
    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': 'v0.2.0' }

    " Color scheme
    " Plug 'morhetz/gruvbox'
    " Plug 'shinchu/lightline-gruvbox.vim'
     Plug 'jacoborus/tender.vim'
    " Plug 'kristijanhusak/vim-hybrid-material'
    " Plug 'sonph/onehalf', {'rtp': 'vim' }
    " Plug 'rakr/vim-one'
     Plug 'sainnhe/everforest'
    " Plug 'NLKNguyen/papercolor-theme'
     Plug 'altercation/vim-colors-solarized'
     Plug 'ayu-theme/ayu-vim'
     Plug 'nanotech/jellybeans.vim'
    " Plug 'adrian5/oceanic-next-vim'
    " Plug 'joshdick/onedark.vim'

call plug#end()


" ************************ NERDTree Settings ********************************* 

let $FZF_DEFAULT_COMMAND = "find . -type f -not -path '*/\.git/*'"

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the quickfix buffer 
autocmd WinEnter * if winnr('$') == 1 && &buftype == "quickfix"| quit |endif

let g:NERDTreeFileLines = 1

" ************************ LightLine Settings *********************************

let g:lightline#bufferline#show_number  = 2
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[NONE]'

" \ 'colorscheme': ayu_dark, ayu_mirage, wombat, Tomorrow_Night_Bright,
" materia, material, onehalfdark

let g:lightline = {
	\ 'colorscheme': 'ayu_dark',
	\ 'tabline' : {
	\	'left': [['buffers']], 'right': [['close']]
	\},
	\ 'active': {
	\	'left':  [[ 'mode', 'paste', 'readonly' ],
	\                ['fugitive', 'filename', 'modified' ]],
    	\	'right': [[ 'lineinfo' ],
    	\              	 [ 'percent' ],
    	\              	 [ 'fileformat', 'fileencoding', 'filetype', ]]
	\ },
	\ 'component_expand': {'buffers': 'lightline#bufferline#buffers'},
	\ 'component_type': {'buffers': 'tabsel'},
	\ 'component_function': {
	\   'fugitive': 'LightlineFugitive',
	\   'filename': 'LightlineFilename'
	\ }
	\ }
" Function to check if the file has been modified
function! LightlineModified()
	return &ft =~# 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction
" Function to check the read-only property
function! LightlineReadonly()
	return &ft !~? 'help\|vimfiler' && &readonly ? 'RO' : ''
endfunction
" Function to get the current branch from Fugitive
function! LightlineFugitive()
	if &ft !~? 'vimfiler' && exists('*FugitiveHead')
		return FugitiveHead()
	endif
	return ''
endfunction
