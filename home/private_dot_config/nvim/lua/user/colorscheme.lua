vim.cmd [[
try
  colorscheme jellybeans-nvim
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
