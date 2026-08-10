local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
  vim.notify "nvim-treesitter not found"
  return
end

treesitter.setup {}

local ensure_installed = {
  "bash",
  -- "c_sharp",
  -- "cmake",
  "comment",
  "css",
  "csv",
  -- "dart",
  "dockerfile",
  "dtd",
  -- "eex",
  -- "elixir",
  -- "erlang",
  "git_config",
  "gitignore",
  "go",
  "gomod",
  "gotmpl",
  "gowork",
  -- "graphql",
  -- "haskell",
  "html",
  "http",
  -- "java",
  "javascript",
  -- "jsdoc",
  "json",
  -- "kotlin",
  "ledger",
  "lua",
  -- "make",
  "markdown",
  "markdown_inline",
  -- "ninja",
  -- "nix",
  "nu",
  -- "perl",
  -- "php",
  -- "proto",
  -- "python",
  -- "r",
  "regex",
  "ruby",
  -- "rust",
  -- "scala",
  "scss",
  "sql",
  "ssh_config",
  "svelte",
  "tmux",
  "toml",
  "typescript",
  -- "vim",
  "vimdoc",
  -- "vue",
  "xml",
  "yaml",
}

local installed = require("nvim-treesitter.config").get_installed()
local to_install = {}
for _, parser in ipairs(ensure_installed) do
  if not vim.tbl_contains(installed, parser) then
    table.insert(to_install, parser)
  end
end
if #to_install > 0 then
  treesitter.install(to_install)
end

-- Treesitter-based highlighting and indentation by buffer
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Autotag config
local autotag_status_ok, autotag = pcall(require, "nvim-ts-autotag")
if not autotag_status_ok then
  vim.notify "nvim-ts-autotag not found"
else
  autotag.setup()
end

-- Textobjects config
local textobjects_status_ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
if not textobjects_status_ok then
  vim.notify "nvim-treesitter-textobjects not found"
else
  textobjects.setup {
    select = {
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      include_surrounding_whitespace = false,
    },
    move = {
      set_jumps = true,
    },
  }

  local select = require "nvim-treesitter-textobjects.select"
  local swap = require "nvim-treesitter-textobjects.swap"

  local select_keymaps = {
    ["ap"] = { query_group = "textobjects", query = "@parameter.outer", desc = "Select parameter" },
    ["af"] = { query_group = "textobjects", query = "@function.outer", desc = "Select function outer" },
    ["if"] = { query_group = "textobjects", query = "@function.inner", desc = "Select function inner" },
    ["ac"] = { query_group = "textobjects", query = "@class.outer", desc = "Select class outer" },
    ["ic"] = { query_group = "textobjects", query = "@class.inner", desc = "Select class inner" },
    ["al"] = { query_group = "textobjects", query = "@loop.outer", desc = "Select loop outer" },
    ["il"] = { query_group = "textobjects", query = "@loop.inner", desc = "Select loop inner" },
    ["aC"] = { query_group = "textobjects", query = "@conditional.outer", desc = "Select conditional outer" },
    ["iC"] = { query_group = "textobjects", query = "@conditional.inner", desc = "Select conditional inner" },
    -- locals
    ["as"] = { query_group = "locals", query = "@scope", desc = "Select scope" },
    -- nushell
    ["aP"] = { query_group = "textobjects", query = "@pipeline.outer", desc = "Select pipeline outer" },
    ["iP"] = { query_group = "textobjects", query = "@pipeline.inner", desc = "Select pipeline inner" },
  }

  for lhs, keymap in pairs(select_keymaps) do
    vim.keymap.set({ "x", "o" }, lhs, function()
      select.select_textobject(keymap.query, keymap.query_group)
    end, { desc = keymap.desc })
  end

  vim.keymap.set("n", "<leader>+", function()
    swap.swap_next "@parameter.inner"
  end, { desc = "Swap next parameter" })

  vim.keymap.set("n", "<leader>-", function()
    swap.swap_previous "@parameter.inner"
  end, { desc = "Swap previous parameter" })
end

local comment_status_ok, commentstring = pcall(require, "ts_context_commentstring")
if not comment_status_ok then
  vim.notify "nvim-ts-context-commentstring not found"
  return
end

commentstring.setup {}
