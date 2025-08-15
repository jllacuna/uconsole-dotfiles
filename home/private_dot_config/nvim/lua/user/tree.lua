local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify "nvim-tree not found"
  return
end

local preview_ok, preview = pcall(require, "nvim-tree-preview")
if not preview_ok then
  vim.notify "nvim-tree-preview not found"
  return
end

-- Following options are the default
-- Each of these are documented in `:help nvim-tree.OPTION_NAME`
nvim_tree.setup {
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Start with the default mappings
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open')) -- default is <CR>
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory')) -- default is <BS>
    vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split')) -- default is <C-v>
    vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split')) -- default is <C-x>
    vim.keymap.set('n', 't', api.node.open.tab, opts('Open: New Tab')) -- default is <C-t>
    vim.keymap.set('n', '<C-x>', api.fs.cut, opts('Cut')) -- default is x, <C-x> is default for split
    vim.keymap.set('n', '<C-c>', api.fs.copy.node, opts('Copy')) -- default is c
    vim.keymap.set('n', '<C-v>', api.fs.paste, opts('Paste')) -- default is p
    vim.keymap.set('n', '<C-d>', api.fs.remove, opts('Delete')) -- default is d, will prompt for confirmation
    vim.keymap.set('n', '<C-t>', api.fs.trash, opts('Trash')) -- default is D, will prompt for confirmation

    vim.keymap.del('n', 'x', { buffer = bufnr }) -- default is cut, replaced by <C-x>
    vim.keymap.del('n', 'c', { buffer = bufnr }) -- default is copy, replaced by <C-c>
    vim.keymap.del('n', 'd', { buffer = bufnr }) -- default is delete, replaced by <C-d>
    vim.keymap.del('n', 'D', { buffer = bufnr }) -- default is trash, replaced by <C-t>

    -- Disable mouse actions
    vim.keymap.del('n', '<2-LeftMouse>', { buffer = bufnr }) -- default is edit/open
    vim.keymap.del('n', '<2-RightMouse>', { buffer = bufnr }) -- default is cd

    -- Preview
    vim.keymap.set('n', 'p', function() -- default is paste, replaced by <C-v>
      if preview.is_open() or preview.is_watching() then
        preview.unwatch() -- Also closes preview window by default
      else
        preview.watch()
      end
    end, opts('Toggle Preview'))

    vim.keymap.set('n', '<Tab>', function()
      local ok, node = pcall(api.tree.get_node_under_cursor)
      if ok and node then
        if node.type == 'directory' then
          api.node.open.edit()
        else
          preview.node(node, { toggle_focus = true })
        end
      end
    end, opts('Preview'))
  end,
  renderer = {
    root_folder_label = false,
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          deleted = "",
          untracked = "U",
          ignored = "◌",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      },
    },
  },
  disable_netrw = true,
  hijack_netrw = false,  -- default
  open_on_tab = false,
  hijack_cursor = true, -- default false, when true, keeps cursor on first letter of filename
  update_cwd = false,   -- default
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true, -- update the focused file in nvim-tree to match buffer
    update_root = false, -- do not change root if opening a file outside the current root
    ignore_list = {}, -- default
  },
  system_open = {
    cmd = "",  -- default
    args = {}, -- default
  },
  filters = {
    dotfiles = false, -- do not filter/hide dot files
    custom = {
      "^\\.git$",
    },
  },
  git = {
    enable = true, -- highlight git attributes
    ignore = true, -- hide files in .gitignore
    timeout = 1000, -- default 400 ms
  },
  view = {
    width = 30, -- default
    adaptive_size = true,
    side = "left",
    number = false,
    relativenumber = false,
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  actions = {
    change_dir = {
      enable = false, -- do not change directory when changing directory in the tree
    },
    open_file = {
      quit_on_open = false, -- do not close nvim-tree when opening a file
      window_picker = {
        enable = false, -- when false, just open in last window to launch nvim-tree
      },
    },
  },
}
