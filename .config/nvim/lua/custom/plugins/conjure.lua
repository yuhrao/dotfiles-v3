return {
  'Olical/conjure',
  ft = { 'clojure', 'fennel', 'lua' },
  lazy = true,
  dependencies = { 'm00qek/baleia.nvim' },
  init = function()
    vim.g['conjure#mapping#prefix'] = '<leader>m'
    vim.g['conjure#mapping#doc_word'] = 'K'
    vim.g['conjure#client#clojure#nrepl#mapping#connect'] = "<leader>m'"
    vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false
    vim.g['conjure#client#clojure#nrepl#connection#auto_repl#hidden'] = true
    vim.g['conjure#client#clojure#nrepl#connection#auto_repl#cmd'] = nil
    vim.g['conjure#client#clojure#nrepl#eval#auto_require'] = false
    vim.g['conjure#extract#context_header_lines'] = 0
    vim.g['conjure#log#strip_ansi_escape_sequences_line_limit'] = 1
  end,
  config = function()
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = '*.clj,*.cljs,*.cljc',
      callback = function()
        vim.b['conjure#client#clojure#nrepl#connection#auto_connect#enabled'] = false
      end,
    })

    vim.api.nvim_create_autocmd('BufWinEnter', {
      pattern = 'conjure-log-*',
      callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        vim.diagnostic.enable(false, { bufnr = buffer })
        if vim.g.conjure_baleia then
          vim.g.conjure_baleia.automatically(buffer)
        end
      end,
    })
  end,
}
