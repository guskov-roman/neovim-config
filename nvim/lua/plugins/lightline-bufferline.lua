return {
    'mengelbrecht/lightline-bufferline',
    config = function()
         vim.g['lightline#bufferline#show_number'] = 2
         vim.g['lightline#bufferline#shorten_path'] = 0
         vim.g['lightline#bufferline#unnamed'] = '[NONE]'        
    end
}
