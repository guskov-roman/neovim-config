return {
    'preservim/nerdtree',
    config = function()
        vim.keymap.set("n", "<F12>", ':NERDTreeToggle<CR>')
    end
}
