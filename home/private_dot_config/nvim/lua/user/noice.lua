local status_ok, noice = pcall(require, "noice")
if not status_ok then
  vim.notify "noice not found"
  return
end

noice.setup {
  lsp = {
    -- Suggested setup: https://github.com/folke/noice.nvim?tab=readme-ov-file#-installation
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  presets = {
    inc_rename = true,     -- Use noice for inc-rename.nvim
    lsp_doc_border = true, -- Add border to lsp hover and signature help
  },
}
