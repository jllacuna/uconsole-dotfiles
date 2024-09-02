local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  vim.notify "lualine not found"
  return
end

local navic_status_ok, navic = pcall(require, "nvim-navic")
if not navic_status_ok then
  vim.notify "nvim-navic not found"
  return
end

local jellybeans_status_ok, jellybeans = pcall(require, "lualine.themes.jellybeans")
if not jellybeans_status_ok then
  vim.notify "lualine.themes.jellybeans not found"
  return
end

-- Display relative path of node under cursor in NvimTree
local nvim_tree_extension = {
  sections = {
    lualine_b = {
      function()
        local tree_status_ok, nvim_tree_api = pcall(require, "nvim-tree.api")
        if not tree_status_ok then
          vim.notify "nvim-tree.api not found"
          return ''
        end
        local node = nvim_tree_api.tree.get_node_under_cursor()
        return vim.fn.fnamemodify(node.absolute_path, ":~:.")
      end
    },
  },
  filetypes = { "NvimTree"}
}

lualine.setup {
  options = {
    disabled_filetypes = {
      winbar = {
        "NvimTree",
      },
    },
    theme = jellybeans,
  },

  extensions = {
    nvim_tree_extension,
  },

  tabline = {
    lualine_a = { "buffers" },
    lualine_z = { "tabs" },
  },

  winbar = {
    lualine_b = {
      {
        "filetype",
        icon_only = true,
      },
    },
    lualine_c = {
      {
        function()
          return navic.get_location()
        end,
        cond = function()
          return navic.is_available()
        end
      },
    },
  },

  inactive_winbar = {
    lualine_b = {
      {
        "filetype",
        icon_only = true,
      },
      "filename",
    },
  }
}
