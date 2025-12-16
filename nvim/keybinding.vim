" remap lead key, bei default '\'
let mapleader = ","

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

"Move to the next buffer
nmap <leader>l :bnext<CR>
"Move to the previous buffer
nmap <leader>h :bprevious<CR>
"Close the current buffer and move to the previous one. This replicates the idea of closing a tab
nmap <leader>q :bp <BAR> bd #<CR>
"Show all open buffers and their status.

vmap <Tab> >gv
vmap <S-Tab> <gv

"Turn highlighting off till next search
map <silent> <leader>/ :nohlsearch<cr>

"map <leader>f :Files<CR>

nnoremap <space> za
nnoremap <DEL> "_x
vnoremap <DEL> "_x

nnoremap d "_d
vnoremap d "_d
nnoremap dd "_dd

xnoremap p pgvy

noremap <Leader>y "+y
noremap <Leader>x "+x

nmap <F8> :TagbarToggle<CR>
nmap <F12> :NERDTreeToggle<CR>

noremap - :Telescope<CR>
"map <C-f> :Telescope find_files<CR>
noremap <Leader>tf :Telescope find_files<CR>
noremap <Leader>tg :Telescope live_grep<CR>
noremap <Leader>tb :Telescope buffers<CR>
