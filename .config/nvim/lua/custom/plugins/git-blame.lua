return {
  {
    'f-person/git-blame.nvim',
    event = 'BufReadPre',
    config = function()
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_message_template = '<summary> • <date> • <author>'
      vim.g.gitblame_date_format = '%r'
      vim.g.gitblame_delay = 1000
      vim.g.gitblame_highlight_group = 'Comment'
      vim.g.gitblame_virtual_text_column = 80
      vim.g.gitblame_display_virtual_text = 1
      vim.g.gitblame_ignored_filetypes = { 'help', 'fugitive', 'alpha', 'dashboard' }
    end,
    keys = {
      { '<leader>gb', '<cmd>GitBlameToggle<cr>', desc = '[G]it [B]lame toggle' },
      { '<leader>gB', '<cmd>GitBlameOpenCommitURL<cr>', desc = '[G]it [B]lame open commit URL' },
      { '<leader>gf', '<cmd>GitBlameOpenFileURL<cr>', desc = '[G]it blame open [F]ile URL' },
      { '<leader>gc', '<cmd>GitBlameCopyCommitURL<cr>', desc = '[G]it blame [C]opy commit URL' },
    },
  },
}