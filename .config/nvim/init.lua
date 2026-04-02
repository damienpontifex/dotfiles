-- Enable the new experimental command-line features.
require("vim._core.ui2").enable({ msg = { target = "cmd" } })

require("winbar")

require("config.options")

require("plugins")
require("core.lsp")

require("config.autocmds")
require("config.keymaps")
require("config.user_commands")
