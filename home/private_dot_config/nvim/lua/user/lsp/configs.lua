local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
  vim.notify "mason-lspconfig not found"
  return
end

local servers = {
  "bashls",
  "cssls",
  "dockerls",
  "docker_compose_language_service",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  -- "pyright",
  -- "rnix",
  -- "solargraph",
  "svelte",
  "taplo",
  "vtsls",
  "yamlls",
}

mason_lspconfig.setup {
  ensure_installed = servers,
  automatic_enable = false,
}

local lsp_status_ok, lspconfig = pcall(require, "lspconfig")
if not lsp_status_ok then
  vim.notify "lspconfig not found"
  return
end

require("lspconfig.configs").vtsls = require("vtsls").lspconfig

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }
  local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
  end

  lspconfig[server].setup(opts)
end
