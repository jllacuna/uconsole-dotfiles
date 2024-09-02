local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
  vim.notify "colorizer not found"
  return
end

colorizer.setup {
  filetypes = {
    "*",
    -- Colorize all css color values including rgb and hsl functions for these filetypes
    css = { css = true },
    html = { css = true },
    md = { css = true },
    sass = { css = true },
    scss = { css = true },
    svelte = { css = true },
  },
}
