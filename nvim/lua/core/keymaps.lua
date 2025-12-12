vim.g.mapleader = " "

-- local keymap = vim.keymap
-- local cmd = vim.cmd
local expr_opts = {noremap = true, expr = true, silent = true}

vim.keymap.set("n", "<leader>l", ":bnext<CR>")
vim.keymap.set("n", "<leader>h", ":bprevious<CR>")
vim.keymap.set("n", "<leader>q", ":bp <BAR> bd #<CR>")

vim.keymap.set("n", "x", '"_x')
vim.keymap.set({"n", "v"}, "<DEL>", '"_x', {noremap = true})
vim.keymap.set({"n", "v"}, "d", '"_x', {noremap = true})
vim.keymap.set("n", "dd", '"_dd', {noremap = true})
vim.keymap.set("x", "p", 'pgvy', {noremap = true})
vim.keymap.set({"n", "v"}, "y", '"+y', {noremap = true})


vim.keymap.set("n", "<Leader>1", '<Plug>lightline#bufferline#go(1)')
vim.keymap.set("n", "<Leader>2", '<Plug>lightline#bufferline#go(2)')
vim.keymap.set("n", "<Leader>3", '<Plug>lightline#bufferline#go(3)')
vim.keymap.set("n", "<Leader>4", '<Plug>lightline#bufferline#go(4)')
vim.keymap.set("n", "<Leader>5", '<Plug>lightline#bufferline#go(5)')
vim.keymap.set("n", "<Leader>6", '<Plug>lightline#bufferline#go(6)')
vim.keymap.set("n", "<Leader>7", '<Plug>lightline#bufferline#go(7)')
vim.keymap.set("n", "<Leader>8", '<Plug>lightline#bufferline#go(8)')
vim.keymap.set("n", "<Leader>9", '<Plug>lightline#bufferline#go(9)')
vim.keymap.set("n", "<Leader>0", '<Plug>lightline#bufferline#go(10)')
