local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Merge options. WARNING: Overwrites t1
local function merge(t1, t2)
  for k,v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        merge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   "n": normal_mode
--   "i": insert_mode
--   "v": visual_mode
--   "x": visual_block_mode
--   "t": term_mode
--   "c": command_mode
--   "": normal_mode, visual_mode, select_mode, operater_pending_mode
--   "!": insert_mode, command_mode

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", merge({ desc = 'File explorer' }, opts))

-- Disable arrow keys
keymap("", "<Up>", "", opts)
keymap("!", "<Up>", "", opts)
keymap("", "<Down>", "", opts)
keymap("!", "<Down>", "", opts)
keymap("", "<Left>", "", opts)
keymap("!", "<Left>", "", opts)
keymap("", "<Right>", "", opts)
keymap("!", "<Right>", "", opts)

-- Resize with arrows
keymap("n", "<Up>", ":resize -2<CR>", opts)
keymap("n", "<Down>", ":resize +2<CR>", opts)
keymap("n", "<Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)

-- Keep original copy string when pasting
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Telescope --
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", merge({ desc = 'Find files' }, opts))
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", merge({ desc = 'Search in files' }, opts))
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", merge({ desc = 'Find buffers' }, opts))
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", merge({ desc = 'Find help tags' }, opts))
keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", merge({ desc = 'Find diagnostics' }, opts))
keymap("n", "<leader>fc", "<cmd>Telescope git_status<cr>", merge({ desc = 'Find changes (git)' }, opts))
keymap("n", "<leader>fn", "<cmd>Telescope nerdy<cr>", merge({ desc = 'Search and insert Nerd fonts' }, opts))
keymap("n", "<leader>fo", "<cmd>Telescope notify<cr>", merge({ desc = 'Search notification history' }, opts))

vim.keymap.set("n", "<leader>fr", function()
  require('telescope.builtin').lsp_references()
end, { desc = "Find references under cursor" })

vim.keymap.set("n", "<leader>fw", function()
  local word = vim.fn.expand("<cword>");
  local status_ok, tb = pcall(require, "telescope.builtin")
  if status_ok then
    tb.live_grep { default_text = word }
  end
end, { desc = "Find word under cursor" })

-- noice/nvim-notify --
keymap("n", "<Esc>", "<cmd>Noice dismiss<cr>", merge({ desc = 'Dismiss notifications' }, opts))

-- Cheatsheet --
keymap("n", "<leader>cs", "<cmd>Cheatsheet<cr>", opts)

-- inc-rename --
vim.keymap.set("n", "<leader>rn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { desc = 'Rename symbol', expr = true })

-- Treesitter Playground --
keymap("n", "<leader>s", "<cmd>TSHighlightCapturesUnderCursor<cr>", merge({ desc = 'Show syntax highlight groups' }, opts))
keymap("n", "<leader>p", "<cmd>TSPlaygroundToggle<cr>", merge({ desc = 'Toggle treesitter playground' }, opts))

-- treesj --
keymap("n", "<leader>J", "<cmd>TSJToggle<cr>", merge({ desc = 'Toggle join/split arrays, objects, statements' }, opts))

-- render-markdown.nvim --
keymap("n", "<leader>m", "<cmd>RenderMarkdown toggle<cr>", merge({ desc = 'Toggle Markdown Render' }, opts))

-- Glow (Markdown Preview) --
keymap("n", "<leader>mp", "<cmd>Glow<cr>", merge({ desc = 'Show Markdown Preview' }, opts))

-- Todo Comments --
keymap("n", "<leader>t", "<cmd>TodoQuickFix<cr>", merge({ desc = 'Show TODOs in quickfix' }, opts))
keymap("n", "<leader>ft", "<cmd>TodoTelescope<cr>", merge({ desc = 'Find TODOs' }, opts))

-- Bbye --
keymap("n", "<leader>bd", "<cmd>Bdelete<cr>", merge({ desc = 'Delete buffer keep window' }, opts))
keymap("n", "<leader>ba", "<cmd>bufdo Bdelete<cr>", merge({ desc = 'Delete all buffers keep window' }, opts))

-- outline.nvim --
keymap("n", "<leader>o", "<cmd>Outline<cr>", merge({ desc = 'Toggle symbol outline' }, opts))

-- colorizer --
keymap("n", "<leader>co", "<cmd>ColorizerToggle<cr>", merge({ desc = 'Toggle colorizing color values' }, opts))

-- Toggle line numbers
keymap("n", "<leader>l", ":set nonumber!<CR>", merge({ desc = 'Toggle line numbers' }, opts))

-- Add lines above and below
keymap("n", "OO", "O<ESC>", opts)
keymap("n", "oo", "o<ESC>", opts)

-- Open new tab
keymap("n", "tt", ":tabnew<CR>", opts)

-- Go to next and previous tab
keymap("n", "tj", ":tabp<CR>", opts)
keymap("n", "tk", ":tabn<CR>", opts)

-- Reformat
keymap("n", "fff", "gg=G", merge({ desc = 'Fix indents' }, opts))

-- Convert tabs to spaces and remove extra whitespace
keymap("n", "sss", ':retab<CR>:%s/\\s\\+$//c<CR>', merge({ desc = 'Fix whitespace' }, opts))
