return {
  'ray-x/go.nvim',
  dependencies = {
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('go').setup()
    -- local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
    -- vim.api.nvim_create_autocmd('BufWritePre', {
    --   pattern = '*.go',
    --   callback = function()
    --     require('go.format').gofmt()
    --     require('go.format').goimports()
    --   end,
    --   group = format_sync_grp,
    -- })
  end,
  ft = { 'go', 'gomod' },
  -- Only load in Go projects
  cond = function()
    return vim.fn.filereadable('go.mod') == 1 or vim.fn.filereadable('go.work') == 1
  end,
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
