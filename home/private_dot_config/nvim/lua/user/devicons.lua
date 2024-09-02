local status_ok, devicons = pcall(require, "nvim-web-devicons")
if not status_ok then
  vim.notify "nvim-web-devicons not found"
  return
end

devicons.setup {
  -- your personnal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  --[[
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh"
    }
  },
  ]]--
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = false,
  -- globally enable "strict" selection of icons - icon will be looked up in
  -- different tables, first by filename, and if not found by extension; this
  -- prevents cases when file doesn't have any extension but still gets some icon
  -- because its name happened to match some extension (default to false)
  strict = true,
}
