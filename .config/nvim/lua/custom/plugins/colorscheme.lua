return {
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    opts = function(_, opts)
      opts.transparent = true
      opts.italic_comments = true
    end,
    config = function()
      require('cyberdream').setup {
        transparent = true,
        italic_comments = true,
      }
      vim.cmd.colorscheme 'cyberdream'
    end,
  },

  -- modicator (auto color line number based on vim mode)
  {
    'mawkler/modicator.nvim',
    dependencies = 'scottmckendry/cyberdream.nvim',
    event = 'VeryLazy',
    init = function()
      -- These are required for Modicator to work
      vim.o.cursorline = false
      vim.o.number = true
      vim.o.termguicolors = true
    end,
    opts = {},
  },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
}
