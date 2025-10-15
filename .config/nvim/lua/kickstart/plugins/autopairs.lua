-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  dependencies = { 'saghen/blink.cmp' },
  config = function()
    local npairs = require 'nvim-autopairs'
    local Rule = require 'nvim-autopairs.rule'
    local cond = require 'nvim-autopairs.conds'

    npairs.setup {
      check_ts = true,
      ts_config = {
        lua = { 'string' },
        javascript = { 'template_string' },
        typescript = { 'template_string' },
        javascriptreact = { 'template_string' },
        typescriptreact = { 'template_string' },
        java = false,
        clojure = { 'string' },
      },
      disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
      enable_check_bracket_line = true,
      fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,%s]]=],
        end_key = '$',
        before_key = 'h',
        after_key = 'l',
        cursor_pos_before = true,
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        manual_position = true,
        highlight = 'Search',
        highlight_grey = 'Comment',
      },
    }

    -- Add spaces between parentheses
    local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
    npairs.add_rules {
      Rule(' ', ' ')
        :with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({
            brackets[1][1] .. brackets[1][2],
            brackets[2][1] .. brackets[2][2],
            brackets[3][1] .. brackets[3][2],
          }, pair)
        end),
    }
    for _, bracket in pairs(brackets) do
      npairs.add_rules {
        Rule(bracket[1] .. ' ', ' ' .. bracket[2])
          :with_pair(function()
            return false
          end)
          :with_move(function(opts)
            return opts.prev_char:match '.%' .. bracket[2] ~= nil
          end)
          :use_key(bracket[2]),
      }
    end

    -- Add arrow function for TypeScript/JavaScript
    npairs.add_rules {
      Rule('%(.*%)%s*%=>$', ' {  }', { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' })
        :use_regex(true)
        :set_end_pair_length(2),
    }

    -- Clojure-specific autopairs
    npairs.add_rules {
      Rule('(', ')', { 'clojure', 'fennel' }):with_pair(cond.not_after_regex '[%w_]'),
      Rule('[', ']', { 'clojure', 'fennel' }):with_pair(cond.not_after_regex '[%w_]'),
      Rule('{', '}', { 'clojure', 'fennel' }):with_pair(cond.not_after_regex '[%w_]'),
      Rule('"', '"', { 'clojure', 'fennel' }):with_pair(cond.not_after_regex '[%w_]'),
    }

    -- Integration with blink.cmp is automatic when blink.cmp is installed
  end,
}
