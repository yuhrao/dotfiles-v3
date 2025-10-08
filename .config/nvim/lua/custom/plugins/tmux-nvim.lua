return {
  {
    'aserowy/tmux.nvim',
    config = function()
      return require('tmux').setup {
        copy_sync = {
          enable = true,
          redirect_to_clipboard = true,  -- Redirect to system clipboard
          sync_clipboard = false,  -- Don't override vim.g.clipboard
        },
        resize = {
          enable_default_keybindings = false,
        },
      }
    end,
  },
}
