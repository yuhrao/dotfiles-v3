return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- Optimized configuration - disabled unused modules for performance
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = { enabled = true }, -- Disabled for faster startup
    explorer = { enabled = false }, -- Using Neo-tree
    indent = { enabled = false }, -- Using indent_line plugin
    input = { enabled = true }, -- Required for opencode.nvim
    lazygit = { enabled = true },
    notifier = { enabled = true }, -- Disabled for performance
    picker = { enabled = false }, -- Using Telescope
    quickfile = { enabled = true },
    scope = { enabled = false }, -- Disabled for performance
    scroll = { enabled = false }, -- Smooth scroll disabled
    statuscolumn = { enabled = false }, -- Disabled for performance
    words = { enabled = true },
    rename = { enabled = true },
  },
  keys = {
    {
      '<leader>bd',
      mode = { 'n', 'x', 'o' },
      function()
        require('snacks').bufdelete.delete()
      end,
      desc = '[B]uffer [D]elete Current',
    },
    {
      ']]',
      function()
        require('snacks').words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        require('snacks').words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
    {
      '<leader>lg',
      function()
        require('snacks').lazygit.open()
      end,
      desc = '[L]azy [G]it',
      mode = { 'n', 't' },
    },
  },
}
