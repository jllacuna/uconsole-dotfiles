local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  vim.notify "gitsigns not found"
  return
end

gitsigns.setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = '[git] Next hunk' })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = '[git] Previous hunk' })

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk, { desc = '[git] Stage hunk' })
    map('n', '<leader>hr', gs.reset_hunk, { desc = '[git] Reset hunk' })
    map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, { desc = '[git] Stage hunk(s)' }) -- Stage all hunks in the selection
    map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, { desc = '[git] Reset hunk(s)' }) -- Reset all hunks in the selection
    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[git] Undo stage hunk' })
    map('n', '<leader>hS', gs.stage_buffer, { desc = '[git] Stage buffer' })
    map('n', '<leader>hR', gs.reset_buffer, { desc = '[git] Reset buffer' })
    map('n', '<leader>hp', gs.preview_hunk, { desc = '[git] Preview hunk' })
    map('n', '<leader>hB', function() gs.blame_line{full=true} end, { desc = '[git] Blame line' })
    map('n', '<leader>hb', gs.toggle_current_line_blame, { desc = '[git] Toggle blame current line' })
    map('n', '<leader>hd', gs.diffthis, { desc = '[git] Diff unstaged' })
    map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = '[git] Diff last commit'})
    map('n', '<leader>ht', function() gs.toggle_word_diff(); gs.toggle_deleted() end, { desc = '[git] Toggle inline diff' })

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = '[git] inner hunk' })
  end,
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true,      -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame` (See <leader>hB above)
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 0,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "  [<abbrev_sha>] <author_time> <author>: <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
}
