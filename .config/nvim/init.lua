vim.filetype.add({
  filename = {
    ['.Brewfile'] = 'ruby',
  },
  extension = {
    bicep = 'bicep',
    bicepparam = 'bicep-params',
    gotmpl = 'yaml',
  }
})

require('config.options')

require('core.lazy')
require('core.lsp')

require('config.autocmds')
require('config.keymaps')
