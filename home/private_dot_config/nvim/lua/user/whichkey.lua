local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  vim.notify "which-key not found"
  return
end

which_key.setup {
  ---@param ctx { mode: string, operator: string }
  defer = function(ctx)
    -- Messes with our "oo" and "OO" keymaps to add a line without going into insert mode
    if ctx and ctx.operator and vim.list_contains({ "o", "o" }, ctx.operator) then
      return true
    end
    return false
  end,
}
