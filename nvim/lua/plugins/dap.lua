-- Debugging
return {
  'mfussenegger/nvim-dap',
  -- ft = { "c", "cpp", "haskell", "python" },  -- dap is dependency of mason, lazy loading is useless
  dependencies = {
    'rcarriga/nvim-dap-ui',               -- ui for debugging
    'theHamsta/nvim-dap-virtual-text',    -- virtual text annotations while debugging
    'mfussenegger/nvim-dap-python',       -- preconfigured settings for python
    'nvim-neotest/nvim-nio'               -- library for async io
  },
  config = function()
    local dap = require('dap')
    local dappy = require('dap-python')
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

    -- DAP Python (requires debugpy installation via mason)
    if vim.fn.executable(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python') == 1 then
      dappy.setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')
      -- resolve global python if no virtualenv is found
      dappy.resolve_python = function()
        return '/usr/bin/python'
      end
    end
    --[
    --table.insert(dap.configurations.python, {
    --  type = 'python',
    --  request = 'launch',
    --  name = 'Launch (no debugging)',
    --  program = '${file}',
    --  -- additional config options here, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
    --})
    --]


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

    -- DAP Haskell (requires haskell-debug-adapter installation via mason)
    dap.adapters.haskell = {
      type = 'executable';
      command = 'haskell-debug-adapter';
      args = {};  --{'--hackage-version=0.0.33.0'};
    }
    dap.configurations.haskell = {
      {
        type = 'haskell',
        request = 'launch',
        name = 'Debug',
        workspace = '${workspaceFolder}',
        startup = "${file}",
        stopOnEntry = true,
        logFile = vim.fn.stdpath('cache') .. '/haskell-dap.log',
        logLevel = 'WARNING',
        ghciEnv = vim.empty_dict(),
        ghciPrompt = "λ > ",
        -- Adjust the prompt to the prompt you see when you invoke the stack ghci command below
        ghciInitialPrompt = "λ > ",
        ghciCmd= "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show --ghci-options -ghci-script=/usr/local/dotfiles/ghci/ghci-nocolor.conf",
      },
    }

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
}
