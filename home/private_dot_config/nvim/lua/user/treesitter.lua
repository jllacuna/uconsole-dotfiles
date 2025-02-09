local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify "nvim-treesitter not found"
  return
end

configs.setup {
  ensure_installed = {
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
    -- "vue",
    "xml",
    "yaml"
  }, -- one of "all" (not recommended), or a list of languages

  modules = {},
  auto_install = true,
  sync_install = false,
  ignore_install = {}, -- List of parsers to ignore installing

  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    -- disable = {}, -- list of language that will be disabled
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    -- disable = { "yaml" }
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      scope_incremental = "<C-s>",
      node_decremental = "<BS>",
    },
  },
  autotag = {
    enable = true,
  },
  playground = {
    enable = true,
    -- disable = {},
    updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["ap"] = { query = "@parameter.outer", desc = "Select parameter" },
        ["af"] = { query = "@function.outer", desc = "Select function outer" },
        ["if"] = { query = "@function.inner", desc = "Select function inner" },
        ["ac"] = { query = "@class.outer", desc = "Select class outer" },
        ["ic"] = { query = "@class.inner", desc = "Select class inner" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select scope" },
        -- nushell
        ["aP"] = "@pipeline.outer",
        ["iP"] = "@pipeline.inner",
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      -- selection_modes = {
      --   ['@parameter.outer'] = 'v', -- charwise
      --   ['@function.outer'] = 'V', -- linewise
      --   ['@class.outer'] = '<c-v>', -- blockwise
      -- },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = false,
    },
    swap = {
      enable = true,
      swap_next = { ["<leader>+"] = "@parameter.inner", },
      swap_previous = { ["<leader>-"] = "@parameter.inner", },
    },
    -- Don't need this. Already have "K" in lsp keybindings
    -- lsp_interop = {
    --   enable = true,
    --   border = 'none',
    --   floating_preview_opts = {},
    --   peek_definition_code = {
    --     ["<leader>df"] = "@function.outer",
    --     ["<leader>dF"] = "@class.outer",
    --   },
    -- },
  },
}

local comment_status_ok, commentstring = pcall(require, "ts_context_commentstring")
if not comment_status_ok then
  vim.notify "nvim-ts-context-commentstring not found"
  return
end

commentstring.setup {}
