local status_ok, lightbulb = pcall(require, "nvim-lightbulb")
if not status_ok then
  vim.notify "nvim-lightbulb not found"
  return
end

lightbulb.setup {
  autocmd = {
    enabled = true,
  },
  status_text = {
    enabled = true,
  },
  float = {
    enabled = false,
  },
  virtual_text = {
    enabled = false,
  },
}
