local options = {
  backup         = false,                                -- creates a backup file
  clipboard      = "unnamed",                            -- allows neovim to access the system clipboard
  cmdheight      = 2,                                    -- more space in the neovim command line for displaying messages
  completeopt    = { "menuone", "preview", "noselect" }, -- mostly just for cmp
  conceallevel   = 0,                                    -- so that `` is visible in markdown files
  cursorline     = false,                                -- highlight the current line
  expandtab      = true,                                 -- convert tabs to spaces
  fileencoding   = "utf-8",                              -- the encoding written to a file
  hlsearch       = true,                                 -- highlight all matches on previous search pattern
  ignorecase     = true,                                 -- ignore case in search patterns
  inccommand     = "split",                              -- show results of rename in a split
  mouse          = "nvi",                                -- allow the mouse to be used in neovim
  mousehide      = true,                                 -- hide mouse when typing
  mousemodel     = "popup_setpos",                       -- specify mouse behavior
  number         = true,                                 -- set numbered lines
  numberwidth    = 1,                                    -- set minimum number column width (including space before code) { default 4 }
  pumheight      = 0,                                    -- pop up menu height. 0 => use available screen space
  regexpengine   = 0,                                    -- automatically select regular expression engine
  relativenumber = false,                                -- set relative numbered lines
  scrolloff      = 8,                                    -- min number of lines to keep above and below cursor when scrolling
  shiftwidth     = 2,                                    -- the number of spaces inserted for each indentation
  showmode       = false,                                -- we don't need to see things like -- insert -- anymore
  showtabline    = 1,                                    -- always show tabs
  sidescrolloff  = 8,                                    -- min number of columns to keep before and after cursor when scrolling
  signcolumn     = "auto",                               -- show sign column only when there are signs
  smartcase      = true,                                 -- smart case
  smartindent    = true,                                 -- make indenting smarter again
  splitbelow     = true,                                 -- force all horizontal splits to go below current window
  splitright     = true,                                 -- force all vertical splits to go to the right of current window
  swapfile       = true,                                 -- creates a swapfile
  tabstop        = 2,                                    -- insert 2 spaces for a tab
  termguicolors  = true,                                 -- set term gui colors (most terminals support this)
  timeoutlen     = 500,                                  -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile       = true,                                 -- enable persistent undo
  updatetime     = 300,                                  -- faster completion (4000ms default)
  wrap           = true,                                 -- display lines as one long line
  writebackup    = true,                                 -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword-=_]]
