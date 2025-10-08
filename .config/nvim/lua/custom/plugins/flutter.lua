return {
  'akinsho/flutter-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  ft = { 'dart' },
  -- Only load in Flutter projects
  cond = function()
    return vim.fn.filereadable('pubspec.yaml') == 1
  end,
  config = function()
    -- Ensure asdf shims are in PATH
    local asdf_shims = vim.fn.expand '~/.asdf/shims'
    if vim.fn.isdirectory(asdf_shims) == 1 and not string.find(vim.env.PATH, asdf_shims, 1, true) then
      vim.env.PATH = asdf_shims .. ':' .. vim.env.PATH
    end
    
    -- Get LSP capabilities from blink.cmp if available
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local has_blink, blink_cmp = pcall(require, 'blink.cmp')
    if has_blink then
      capabilities = blink_cmp.get_lsp_capabilities()
    end
    
    -- Ensure proper text synchronization for Dart LSP to prevent RangeErrors
    capabilities.textDocument = capabilities.textDocument or {}
    capabilities.textDocument.synchronization = capabilities.textDocument.synchronization or {}
    capabilities.textDocument.synchronization.dynamicRegistration = false
    capabilities.textDocument.synchronization.willSave = false
    capabilities.textDocument.synchronization.willSaveWaitUntil = false
    capabilities.textDocument.synchronization.didSave = true
    
    require('flutter-tools').setup {
      -- Specify Flutter SDK path (using asdf shim which will resolve to the correct version)
      flutter_path = vim.fn.expand '~/.asdf/shims/flutter',
      
      -- UI settings
      ui = {
        border = 'rounded',
        notification_style = 'native',
      },
      
      decorations = {
        statusline = {
          app_version = false,
          device = true,
        },
      },
      
      widget_guides = {
        enabled = true,
      },
      
      closing_tags = {
        highlight = 'Comment',
        prefix = '// ',
        enabled = true,
      },
      
      dev_log = {
        enabled = false,
        open_cmd = 'tabedit',
      },
      
      dev_tools = {
        autostart = false,
        auto_open_browser = false,
      },
      
      outline = {
        open_cmd = '30vnew',
        auto_open = false,
      },
      
      lsp = {
        -- Explicitly specify the Dart LSP command to use asdf shims
        cmd = { vim.fn.expand '~/.asdf/shims/dart', 'language-server', '--protocol=lsp' },
        
        color = {
          enabled = true,
          background = false,
          foreground = false,
          virtual_text = true,
          virtual_text_str = '■',
        },
        
        capabilities = capabilities,
        
        on_attach = function(client, bufnr)
          -- Set up buffer-local keymaps here if needed
          -- Example: vim.keymap.set('n', '<leader>Fa', require('flutter-tools.commands').flutter_run, { buffer = bufnr })
        end,
        
        -- Dart LSP settings
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = 'prompt',
          enableSnippets = true,
          updateImportsOnRename = true,
          enableSdkFormatter = true,
          analysisExcludedFolders = {
            vim.fn.expand '~/.pub-cache',
            vim.fn.expand '~/.asdf',
            vim.fn.expand '~/flutter/.pub-cache',
            '.dart_tool',
            'build',
          },
        },
      },
      
      debugger = {
        enabled = false,
        run_via_dap = false,
      },
    }
    
    -- Set up Flutter-specific keymaps
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dart',
      callback = function()
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<leader>Fs', ':FlutterRun<CR>', opts)
        vim.keymap.set('n', '<leader>Fq', ':FlutterQuit<CR>', opts)
        vim.keymap.set('n', '<leader>Fr', ':FlutterReload<CR>', opts)
        vim.keymap.set('n', '<leader>FR', ':FlutterRestart<CR>', opts)
        vim.keymap.set('n', '<leader>Fd', ':FlutterDevices<CR>', opts)
        vim.keymap.set('n', '<leader>Fe', ':FlutterEmulators<CR>', opts)
        vim.keymap.set('n', '<leader>Fo', ':FlutterOutlineToggle<CR>', opts)
        vim.keymap.set('n', '<leader>Ft', ':FlutterDevTools<CR>', opts)
      end,
    })
  end,
}
