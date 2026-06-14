return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'mason-org/mason.nvim',
      'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      { '<leader>dc', function() require('dap').continue() end, desc = '[C]ontinue' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'Step [I]nto' },
      { '<leader>dn', function() require('dap').step_over() end, desc = 'Step [N]ext' },
      { '<leader>do', function() require('dap').step_out() end, desc = 'Step [O]ut' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle [U]I' },
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle [B]reakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Conditional [B]reakpoint' },
      { '<leader>dl', function() require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end, desc = '[L]og Point' },
      { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'Toggle [R]EPL' },
      { '<leader>dt', function() require('dap').terminate() end, desc = '[T]erminate Session' },
      { '<leader>ds', function() require('telescope').extensions.dap.configurations() end, desc = '[S]elect Config' },
      { '<leader>dp', function() require('telescope').extensions.dap.list_breakpoints() end, desc = 'List Break[p]oints' },
      { '<leader>df', function() require('telescope').extensions.dap.frames() end, desc = 'List [F]rames' },
      { '<leader>dv', function() require('telescope').extensions.dap.variables() end, desc = 'List [V]ariables' },
      { '<leader>dm', function() require('dap-python').test_method() end, desc = 'Debug Test [M]ethod' },
      { '<leader>dM', function() require('dap-python').test_class() end, desc = 'Debug Test [C]lass' },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('which-key').add { { '<leader>d', group = '[D]ebug' } }

      -- Install debugpy via Mason registry
      local registry = require 'mason-registry'
      registry.refresh(function()
        local pkg = registry.get_package 'debugpy'
        if not pkg:is_installed() then
          pkg:install()
        end
      end)

      -- Python adapter
      require('dap-python').setup(vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python')

      -- Inline variable values
      require('nvim-dap-virtual-text').setup {
        commented = false,
        highlight_changed_variables = true,
        show_stop_reason = true,
        virt_text_pos = 'eol',
      }

      -- Breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      for type, icon in pairs { Breakpoint = '', BreakpointCondition = '', LogPoint = '', Stopped = '' } do
        local hl = type == 'Stopped' and 'DapStop' or 'DapBreak'
        vim.fn.sign_define('Dap' .. type, { text = icon, texthl = hl, numhl = hl })
      end

      -- UI layout: left scopes/stack, right watches/breakpoints, bottom repl/console
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.6 },
              { id = 'stacks', size = 0.4 },
            },
            size = 40,
            position = 'left',
          },
          {
            elements = {
              { id = 'watches', size = 0.5 },
              { id = 'breakpoints', size = 0.5 },
            },
            size = 30,
            position = 'right',
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 15,
            position = 'bottom',
          },
        },
      }

      -- Auto-open/close UI with session lifecycle
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      require('telescope').load_extension 'dap'
    end,
  },
}
