-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    's1n7ax/nvim-window-picker',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = function(_, opts)
    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end
    local events = require("neo-tree.events")
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })
    return {
    window = {
      position = 'right',
      mappings = {
        ['\\'] = 'close_window',
        ['Y'] = function(state)
          -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
          -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local results = {
            modify(filepath, ':.'),
            modify(filepath, ':~'),
            filepath,
            filename,
            modify(filename, ':r'),
            modify(filename, ':e'),
          }

          vim.ui.select({
            '1. Path relative to CWD: ' .. results[1],
            '2. Path relative to HOME: ' .. results[2],
            '3. Absolute path: ' .. results[3],
            '4. Filename: ' .. results[4],
            '5. Filename without extension: ' .. results[5],
            '6. Extension of the filename: ' .. results[6],
          }, { prompt = 'Choose to copy to clipboard:' }, function(choice)
            if not choice then
              return
            end
            local i = tonumber(choice:sub(1, 1))
            local result = results[i]
            vim.fn.setreg('+', result)
            vim.notify('Copied: ' .. result)
          end)
        end,
        ['y'] = {
          'copy_to_clipboard',
          config = {
            show_path = 'relative',
          },
        },
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = {
          '.git',
          '.DS_Store',
        },
        always_show = {
          '.env',
        },
      },
    },
    }
  end,
}
