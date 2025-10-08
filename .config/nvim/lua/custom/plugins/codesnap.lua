return {
  'mistricky/codesnap.nvim',
  build = 'make build_generator',
  cmd = { 'CodeSnap', 'CodeSnapSave', 'CodeSnapHighlight', 'CodeSnapASCII' },
  keys = {
    { '<leader>cc', '<cmd>CodeSnap<cr>', mode = 'x', desc = 'Save selected code snapshot into clipboard' },
    { '<leader>cs', '<cmd>CodeSnapSave<cr>', mode = 'x', desc = 'Save selected code snapshot in ~/Pictures' },
  },
  opts = {
    bg_theme = 'sea',
    has_breadcrumbs = true,
    show_workspace = true,
    has_line_number = true,
    watermark = '',
    title = '',
    bg_x_padding = 20,
    bg_y_padding = 20,
  },
}
