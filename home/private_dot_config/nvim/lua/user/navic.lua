local status_ok, navic = pcall(require, "nvim-navic")
if not status_ok then
  vim.notify "nvim-navic not found"
  return
end

navic.setup {
  lsp = {
    auto_attach = true,
  },
  highlight = true,
  separator = " ",
}
