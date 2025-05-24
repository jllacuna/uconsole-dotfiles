local status_ok, markdown = pcall(require, "render-markdown")
if not status_ok then
  vim.notify "render-markdown not found"
  return
end

markdown.setup {
  heading = {
    sign = false,
  },
  code = {
    sign = false,
    left_pad = 2,
    right_pad = 2,
    width = "block",
  },
  latex = {
    enabled = false,
  },
}
