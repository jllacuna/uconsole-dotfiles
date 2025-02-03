local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  vim.notify "lazy not found"
  return
end

lazy.setup({

  -- Useful lua functions used by lots of plugins
  { "nvim-lua/plenary.nvim" },

  -- Be able to show icons from Nerd Fonts in plugins
  {
    "nvim-tree/nvim-web-devicons",
    config = function () require("user.devicons") end,
  },

  -- Colorschemes
  -- My fork of the jellybeans colorscheme
  {
    "jllacuna/jellybeans-nvim",
    dependencies = { "rktjmp/lush.nvim" }
  },

  -- A bunch of colorschemes you can try out
  -- { "lunarvim/colorschemes" },

  -- This is also a nice colorscheme. Just don't like that function names don't pop as much
  -- { "mhartington/oceanic-next" },

  -- Highlight other instances of the word under cursor
  { "RRethy/vim-illuminate" },

  -- JSON schemas from schemastore.org, for use with jsonls and yamlls
  { "b0o/schemastore.nvim" },

  -- Autopairs, integrates with both cmp and treesitter
  {
    "windwp/nvim-autopairs",
    config = function () require("user.autopairs") end,
  },

  -- Easily comment stuff
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function () require("user.comment") end,
  },

  -- Vertically align characters
  {
    "echasnovski/mini.align",
    version = "*",
    config = function() require("mini.align").setup() end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "b0o/nvim-tree-preview.lua",
    },
    config = function () require("user.tree") end,
  },

  -- Update code when performing file operations in nvim-tree
  -- e.g. updates imports when renaming a file
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function() require("lsp-file-operations").setup() end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function () require("user.lualine") end,
  },

  -- Add, change, or delete surrounding quotes, parens, braces, etc.
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function() require("nvim-surround").setup() end,
  },

  -- Popup window with key binding suggestions
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function () require("user.whichkey") end,
  },

  -- Markdown editing
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    config = function () require("user.markdown") end,
  },

  -- Markdown preview
  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("glow").setup {
        border = "rounded",
      }
    end,
  },

  -- Manage todos, fix, hack, etc.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require('todo-comments').setup() end,
  },

  -- Delete buffers without closing windows
  { "moll/vim-bbye" },

  -- Displays lightbulb in sign column when code actions are available
  {
    "kosayoda/nvim-lightbulb",
    config = function () require("user.lightbulb") end,
  },

  -- cmp plugins
  -- The completion plugin
  {
    "hrsh7th/nvim-cmp",
    config = function () require("user.cmp") end,
  },

  { "hrsh7th/cmp-nvim-lua" },                -- Neovim Lua runtime API
  { "saadparwaiz1/cmp_luasnip" },            -- Snippet completions
  { "hrsh7th/cmp-nvim-lsp" },                -- LSP completions
  { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- Signature help
  { "hrsh7th/cmp-buffer" },                  -- Buffer completions
  { "hrsh7th/cmp-path" },                    -- Path completions

  -- Command line completions
  {
    "hrsh7th/cmp-cmdline",
    commit = "e1ba818534a357b77494597469c85030c7233c16", -- https://github.com/hrsh7th/cmp-cmdline/issues/71
  },

  -- configures LuaLS for editing neovim config files
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = { "lazy.nvim" },
    },
  },

  -- snippets
  {
    "L3MON4D3/LuaSnip", -- Snippet engine
    version = "v2.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    build = "make install_jsregexp", -- install jsregexp (optional!).
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- LSP, DAP, linters, formatters
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      -- Reason NOT using typescript-language-server:
      -- https://github.com/jose-elias-alvarez/typescript.nvim/issues/80#issuecomment-1633410138
      "yioneko/nvim-vtsls",
    },
    config = function () require("user.lsp") end,
  },

  -- Jump to next/previous reference with LSP
  {
    "mawkler/refjump.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- Display code context in status line
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function () require("user.navic") end,
  },

  -- Outline symbols
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    opts = {},
  },

  -- Telescope
  -- Fast fuzzy finder for telescope
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },

  -- Fuzzy finder popup
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function () require("user.telescope") end,
  },

  -- UI hooks
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup {
        input = {
          -- Position input just above cursor
          override = function(conf)
            conf.col = 0
            conf.row = -3
            return conf
          end,
        },
      }
    end,
  },

  -- Rename symbol with previews
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup {
        input_buffer_type = "dressing",
      }
    end,
  },

  -- Displays a cheatsheet of commands, keymaps, nerd font icons, etc. in telescope
  {
    "sudormrfbin/cheatsheet.nvim",
    config = function () require("user.cheatsheet") end,
  },

  -- Treesitter: Syntax parsing for better code highlights, etc.
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- Complete SGML (XML, HTML, etc.) tags ]]
      "windwp/nvim-ts-autotag",
      -- Treesitter selections
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- Changes format of comments based on location within the file. Useful for JSX and svelte
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function () require("user.treesitter") end,
  },

  -- Allows you to inspect treesitter syntax trees
  { "nvim-treesitter/playground" },

  -- Git
  -- Displays git change indicators in the sign column and allows you to perform git operations inline
  {
    "lewis6991/gitsigns.nvim",
    config = function () require("user.gitsigns") end,
  },

  -- Search and insert Nerd fonts
  {
    '2kabhishek/nerdy.nvim',
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Nerdy',
  },

  -- Colorize color variables
  {
    "NvChad/nvim-colorizer.lua",
    config = function () require("user.colorizer") end,
  },

  -- Peek registers
  { "gennaro-tedesco/nvim-peekup" },

  { "ledger/vim-ledger", },
}, {
  rocks = {
    -- Disable hererocks for now
    -- If we install a plugin that needs it, we'll need to install luarocks (https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Unix)
    -- Run :checkhealth lazy for more info
    -- See also https://lazy.folke.io/packages
    hererocks = false,
  },
})
