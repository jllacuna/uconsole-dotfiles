-- TypeScript 7 LSP (`tsc --lsp --stdio`)
-- Not managed by mason
-- Typescript must be installed manually
--   `npm install -g typescript` 
--   or add typescript v7 as a dev dependency on the project
-- If Typescript 7 is missing, nvim will warn that the language server failed
--
-- Taken from nvim-lspconfig tsgo:
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/tsgo.lua
-- nvim-lspconfig support the official Typescript 7 release is still open
-- see https://github.com/neovim/nvim-lspconfig/issues/4467).

local opts = {
  cmd = function(dispatchers, config)
    local cmd = "tsc"
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
  end,

  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },

  root_dir = function(bufnr, on_dir)
    local root_markers = {
      "package-lock.json",
      "yarn.lock",
      "pnpm-lock.yaml",
      "bun.lockb",
      "bun.lock",
    }
    root_markers = vim.fn.has "nvim-0.11.3" == 1 and { root_markers, { ".git" } }
      or vim.list_extend(root_markers, { ".git" })

    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
    local project_root = vim.fs.root(bufnr, root_markers)
    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
      return
    end
    if deno_root and (not project_root or #deno_root >= #project_root) then
      return
    end
    on_dir(project_root or vim.fn.getcwd())
  end,

  settings = {
    typescript = {
      inlayHints = {
        parameterNames = {
          enabled = "literals",
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes           = { enabled = true },
        variableTypes            = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes  = { enabled = true },
        enumMemberValues         = { enabled = true },
      },
    },
  },
}

return opts
