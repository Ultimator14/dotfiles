-- Prompt for expression to evaluate
local function dapui_prompt_eval()
  local expr = vim.fn.input('Expression: ')
  if vim.fn.empty(expr) ~= 0 then
    return
  end
  require('dapui').eval(expr, {})
end

-- DAP
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',             -- load ui when dap loads
      'theHamsta/nvim-dap-virtual-text'   -- virtual text annotations while debugging
    },
    keys = {
      -- breakpoints
      { '<leader>sb', function() require('dap').toggle_breakpoint() end, desc = "Toggle Breakopoint", mode = "n", silent = true },
      { '<leader>sB', function() require('dap').set_breakpoint() end, desc = "Set Breakopoint", mode = "n", silent = true },
      { '<leader>sl', function() require('dap').set_breakpoint(nil, nil, vim.fn.input("Log poing message: ")) end , desc = "Set Logpoint", mode = "n", silent = true },
      -- start/stop
      { '<leader>sc', function() require('dap').continue() end, desc = "Launch/Continue debug session", mode = 'n', silent = true },
      { '<leader>sr', function() require('dap').run_last() end, desc = "Run last debug session", mode = 'n', silent = true },
      { '<leader>st', function() require('dap').terminate() end, desc = "Terminate debug session", mode = 'n', silent = true },
      -- control flow
      { '<leader>si', function() require('dap').step_into() end, desc = "Step into", mode = 'n', silent = true },
      { '<leader>sn', function() require('dap').step_over() end, desc = "Step over", mode = 'n', silent = true },
      { '<leader>so', function() require('dap').step_out() end, desc = "Step out", mode = 'n', silent = true },
      -- information
      { '<leader>sh', function() require('dap.widgets').hover() end, desc = "Hover information", mode = {'n', 'v'}, silent = true },
      { '<leader>sp', function() require('dap.widgets').preview() end, desc = "Preview information", mode = {'n', 'v'}, silent = true },
      { '<leader>sf', function() require('dap.widgets').centered_float(require('dap.widgets').frames) end, desc = "Show frames", mode = 'n', silent = true },
      { '<leader>ss', function() require('dap.widgets').centered_float(require('dap.widgets').scopes) end, desc = "Show scopes", mode = 'n', silent = true }
    },
    config = function()
      local dap = require('dap')
      local daputils = require('dap.utils')
      local utils = require('utils')

      -- DAP
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

      -- Mason DAP
      local default_setup = function(config)
        require("mason-nvim-dap").default_setup(config)
      end

      -- Mason dap, load AFTER nvim-dap has loaded completely
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
  },
  {
    'rcarriga/nvim-dap-ui',                      -- ui for debugging
    dependencies = { 'nvim-neotest/nvim-nio' },  -- library for async io
    keys = {
      { '<F9>', function() require('dapui').toggle() end, desc = "Toggle DAP UI", mode = 'n', silent = true },
      { '<leader>se', function() require('dapui').eval() end, desc = "Evaluate", mode = {'n', 'v'}, silent = true },
      { '<leader>sE', dapui_prompt_eval, desc = "Evaluate expression", mode = 'n', silent = true }
    },
    config = function()
      local dap = require('dap')                 -- implicit cross dependency to nvim-dap to also toggle debugging on e.g. F9
      local dapui = require('dapui')

      dapui.setup()

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
    end
  },
  {
    'theHamsta/nvim-dap-virtual-text',    -- virtual text annotations while debugging
    lazy = true,                          -- load as dependency of nvim-dap
    config = true
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'mason-org/mason.nvim', },
    config = function()
      -- This MUST load after nvim-dap
      -- Nvim dap can be lazy loaded. Therefore this config is empty
      -- mason-nvim-dap setup is done AFTER nvim-dap has loaded in that config function
    end
  }
}
