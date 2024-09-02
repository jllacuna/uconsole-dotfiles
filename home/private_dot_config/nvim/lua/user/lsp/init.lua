local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  vim.notify "mason not found"
  return
end

mason.setup {
  ui ={
    icons = {
      package_installed = "",
      package_pending = "",
      package_uninstalled = ""
    }
  }
}

require "user.lsp.configs"
require("user.lsp.handlers").setup()
