-- DAP
return {
  {
    'mfussenegger/nvim-dap',
    -- ft = { "c", "cpp", "haskell", "python" },  -- dap is dependency of mason-nvim-dap which always loads (e.g. due to ensure_installed), lazy loading is useless
    dependencies = {
      'rcarriga/nvim-dap-ui',               -- ui for debugging
      'theHamsta/nvim-dap-virtual-text',    -- virtual text annotations while debugging
      'nvim-neotest/nvim-nio'               -- library for async io
    },
    config = function()
      local dap = require('dap')
      local dapvt = require('nvim-dap-virtual-text')
      local dapui = require('dapui')

      local daputils = require('dap.utils')
      local dapwidgets = require('dap.ui.widgets')

      local utils = require('utils')

      -- DAP

      -- breakpoints
      vim.keymap.set('n', '<leader>sb', dap.toggle_breakpoint, { desc = "Toggle Breakopoint", silent = true})
      vim.keymap.set('n', '<leader>sB', dap.set_breakpoint, { desc = "Set Breakopoint", silent = true})
      vim.keymap.set('n', '<leader>sl', function() dap.set_breakpoint(nil, nil, vim.fn.input("Log poing message: ")) end , { desc = "Set Logpoint"})
      -- start/stop
      vim.keymap.set('n', '<leader>sc', dap.continue, { desc = "Launch/Continue debug session", silent = true})
      vim.keymap.set('n', '<leader>sr', dap.run_last, { desc = "Run last debug session", silent = true})
      vim.keymap.set('n', '<leader>st', dap.terminate, { desc = "Terminate debug session", silent = true})
      -- control flow
      vim.keymap.set('n', '<leader>si', dap.step_into, { desc = "Step into", silent = true})
      vim.keymap.set('n', '<leader>sn', dap.step_over, { desc = "Step over", silent = true})
      vim.keymap.set('n', '<leader>so', dap.step_out, { desc = "Step out", silent = true})
      -- information
      vim.keymap.set({'n', 'v'}, '<leader>sh', dapwidgets.hover, { desc = "Hover information", silent = true })
      vim.keymap.set({'n', 'v'}, '<leader>sp', dapwidgets.preview, { desc = "Preview information", silent = true })
      vim.keymap.set('n', '<leader>sf', function() dapwidgets.centered_float(dapwidgets.frames) end, { desc = "Show frames", silent = true })
      vim.keymap.set('n', '<leader>ss', function() dapwidgets.centered_float(dapwidgets.scopes) end, { desc = "Show scopes", silent = true })

      -- Debugging
      --require('dap').set_log_level('TRACE')

      -- DAP C (requires gdb 14+)
      -- Note: the executable must be compiled with the '-g' flag to enable references to make breakpoints work
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--quiet", "--interpreter=dap" }
      }
      dap.configurations.c = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            local filename = utils.filename()
            local name, _ = utils.splitextension(filename)

            -- use compiled binary without asking
            if utils.file_exists(name) then
              return name
            end

            return daputils.pick_file({
              filter = function(exec)
                -- Filter out shared libraries
                return not exec:match('%.so([.0-9]*)')
              end,
              executables = true,
            })
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c

      -- DAP Virtual Text
      dapvt.setup()

      -- DAP UI
      dapui.setup()

      -- Prompt for expression to evaluate
      local function dapui_prompt_eval()
        local expr = vim.fn.input('Expression: ')
        if vim.fn.empty(expr) ~= 0 then
          return
        end
        dapui.eval(expr, {})
      end

      vim.keymap.set({'n', 'v'}, '<leader>se', dapui.eval, { desc = "Evaluate", silent = true })
      vim.keymap.set('n', '<leader>sE', dapui_prompt_eval, { desc = "Evaluate expression", silent = true })

      -- Automatically open/close debugging windows on debug start/end
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Toggle DAP UI
      vim.keymap.set('n', '<F9>', dapui.toggle, { desc = "Toggle DAP UI", silent = true})
    end
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap'      -- must come after nvim-dap
  },
    config = function()
      local default_setup = function(config)
        require("mason-nvim-dap").default_setup(config)
      end

      -- Mason dap
      require("mason-nvim-dap").setup{
        ensure_installed = { "python" },
        automatic_installation = false,
        handlers = {
          function(config)
            -- This function is implicitly defined as soon as handlers is not nil
            -- We explicitly define it here to disable interfering with plugins that should not be touched
            --require("mason-nvim-dap").default_setup(config)
          end,
          python = default_setup,
          -- Requires haskell-debug-adapter installation via mason
          -- Installation likely requires `mount -o remount,exec /tmp`
          haskell = default_setup,
          delve = default_setup,  -- go
          node2 = default_setup   -- nodejs/javascript
        },
      }
    end
  }
}
