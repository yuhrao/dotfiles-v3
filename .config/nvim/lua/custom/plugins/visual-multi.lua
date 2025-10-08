return {
  'mg979/vim-visual-multi',
  keys = {
    { '<C-n>', mode = { 'n', 'v' }, desc = 'Visual Multi - Select word' },
    { '<C-Up>', mode = { 'n', 'v' }, desc = 'Visual Multi - Add cursor up' },
    { '<C-Down>', mode = { 'n', 'v' }, desc = 'Visual Multi - Add cursor down' },
    { '_', mode = { 'n', 'v' }, desc = 'Visual Multi - Leader key' },
  },
  init = function()
    vim.g.VM_leader = '_'
  end,
}
