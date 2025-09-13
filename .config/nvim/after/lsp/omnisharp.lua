return {
  cmd = { vim.fn.stdpath('data') .. '/mason/packages/omnisharp/omnisharp' },
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = true,
  handlers = {
    -- ['textDocument/definition'] = require('omnisharp_extended').handler,
  },
}
