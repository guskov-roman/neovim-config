return {
    'itchyny/lightline.vim',
    config = function()
         vim.g['lightline#bufferline#show_number'] = 2
         vim.g['lightline#bufferline#shorten_path'] = 0
         vim.g['lightline#bufferline#unnamed'] = '[NONE]'

         vim.g['lightline'] = {
          colorscheme = 'ayu_dark',
          active = {
            left = {{'mode', 'paste'}, {'readonly', 'filename', 'modified'}},
            right = {{'lineinfo'}, {'percent'}, {'fileformat', 'fileencoding', 'filetype'}}
          },
          tabline = {
            left = {{'buffers'}},
            right = {{'close'}}
          },
          component_expand = {
            buffers = 'lightline#bufferline#buffers'
          },
          component_type = {
            buffers = 'tabsel'
          },
          component_function = {
                fugitive = 'LightlineFugitive',
                filename = 'LightlineFilename'
          }
        }
    end
}
