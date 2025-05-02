-- LSP/DAP
return {
  -- Mason
  {
    'williamboman/mason.nvim',
    opts = {},
    build = ':MasonUpdate'
  },
  -- Mason lspconfig (must come after mason)
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = { "lua_ls" },
      automatic_installation = false
    }
  },
 -- LSP (must come after mason-lspconfig)
  {
    'neovim/nvim-lspconfig',                              -- (default) configs for different lsp servers
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",                             -- cmp must be initialized first to enable capabilities
      'williamboman/mason-lspconfig.nvim'                 -- nvim-lspconfig must come after mason-lspconfig
    },
    config = function()
      --[
      -- Completion needs a language server (separate 3rd party program per language e.g. jedi-language-server)
      -- Nvim needs a language server client to talk to language server (built in feature of neovim)
      -- Nvim needs configuration for the server client to be able to locate and start the corresponding language server
      -- Nvim uses the omnifunc by default to support arbitrary completions
      --
      -- - lspconfig contains default configs for various language servers
      -- - cmp-nvim-cmp supports more features than the builtin omnifunc of neovim
      -- - therefore nvim-cmp capabilities must be passed additionally to the lspconfig capabilities when configuring language servers
      --
      -- - also pass keymaps as specified in README of nvim-lspconfig to make certain ide functions
      --   e.g. jump-to-source work
      --
      -- List of supported language servers
      -- https://microsoft.github.io/language-server-protocol/implementors/servers/
      --]

      local default_capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require('lspconfig')
      local utils = require('utils')

      --[
      -- Lsp related keymaps (global)
      --]
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostics', silent = true })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev , { desc = 'Go to previous diagnostic', silent = true })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next , { desc = 'Go to next diagnostic', silent = true })
      vim.keymap.set('n', '<leader>i', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = 'Toggle inlay hints', silent = true })

      --[
      -- Lsp related keymaps (per buffer)
      --]
      local default_on_attach = function(client, bufnr)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration', silent = true, buffer = bufnr })
        vim.keymap.set('n', 'gR', vim.lsp.buf.implementation, { desc = 'Show implementations', silent = true, buffer = bufnr })
        vim.keymap.set('n', '<C-q>', vim.lsp.buf.hover, { desc = 'Preview hover information', silent = true, buffer = bufnr })
        vim.keymap.set('n', '<leader>rf', function() vim.lsp.buf.format { async = true } end, { desc = 'Reformat file', silent = true, buffer = bufnr })
        vim.keymap.set('n', '<leader>rc', vim.lsp.buf.code_action, { desc = 'Code action', silent = true, buffer = bufnr })

        --handled by Trouble
        --vim.keymap.set('n', 'gd', vim.lsp.buf.definition , { desc = 'Go to definition', silent = true, buffer = bufnr })
        --vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition , { desc = 'Go to type definition', silent = true, buffer = bufnr })
        --vim.keymap.set('n', 'gr', vim.lsp.buf.references , { desc = 'Show references', silent = true, buffer = bufnr })
      end

      local on_attach_texlab = function(client, bufnr)
        default_on_attach(client, bufnr)
        vim.keymap.set('n', '<localleader>b', ':TexlabBuild<cr>', { desc = 'Build tex file', silent = true })
      end

      local on_attach_clangd = function(client, bufnr)
        default_on_attach(client, bufnr)

        local build_file = function()
          local src_name = utils.filename()
          local name, extension = utils.splitextension(src_name)

          -- Custom output file
          local o_flag = ""
          if extension == "c" or extension == "cpp" then
            o_flag = ' -o ' .. name
          end

          -- Compile file
          -- Note: This is very basic and does not support library linking etc.
          --       Compile manually for anything a little more complex
          local result
          if extension == "c" then
            result = vim.fn.system("gcc -g" .. o_flag .. ' ' .. src_name)
          else
            result = vim.fn.system("g++ -g " .. o_flag .. ' ' .. src_name)
          end

          -- Display result to user
          vim.notify(result)
        end

        vim.keymap.set('n', '<localleader>b', build_file, { desc = 'Build c/cpp file', silent = false })
      end

      --[
      -- Additional settings (per lsp)
      -- Add a new server via its lspconfig name
      -- add the respective executable in the server_executable_mapping table
      --]
      local servers = {
        --[
        -- Language: Python
        -- Server: pylsp
        -- dev-python/{python-lsp-{server,ruff},pylsp-{mypy,rope},pylint-venv}
        --]
        pylsp = {
          --cmd = { "pylsp", "-vvv", "--log-file", "/home/jbreig/nvim_lsp.log"}, -- Debug log , remove in production
          settings = {
            pylsp = {
              plugins = {
                -- extensive code linting
                pylint = {
                  enabled = true,
                  args = {"--max-line-length 120", "--init-hook='import pylint_venv; pylint_venv.inithook(quiet=True)'"}
                },
                -- very fast linter, replaces flake8 and others
                ruff = {
                  enabled = true,       -- 3rd party
                  executable = "/usr/bin/ruff", -- Manually set executable to ditch ruff python binding dependencies (which are not installed by gentoo and must be manually installed via pip install)
                  lineLength = 120,
                  -- list of all rules https://beta.ruff.rs/docs/rules/
                  select = {
                    "F",                        -- pyflakes
                    "E", "W",                   -- pycodestyle (error, warning)
                    "C90",                      -- mccabe (complexty)
                    "I",                        -- isort (import sorting)
                    "N",                        -- pep8-naming
                    --"D",                      -- pydocstyle
                    "UP",                       -- pyupgrade (newer syntax)
                    "YTT",                      -- sys.version misuse
                    --"ANN",                    -- missing function annotations
                    "S",                        -- bandit (security)
                    "BLE",                      -- blind except
                    "FBT",                      -- boolean trap
                    "B",                        -- bugbear
                    "A",                        -- name shadowing
                    "COM",                      -- commas
                    "C4",                       -- unnecessary stuff
                    "DTZ",                      -- datetime
                    "DJ",                       -- django
                    "EM",                       -- errmsg
                    --"EXE",                    -- shebang
                    "ISC",                      -- implicit string concat
                    "ICN",                      -- import conventions
                    "G",                        -- logging format
                    "INP",                      -- implicit namespace package
                    "PIE",                      -- unnecessary stuff
                    --"T20",                    -- find print statements
                    "PYI",                      -- typing
                    "PT",                       -- pytest
                    "Q",                        -- quotes
                    "RSE",                      -- unnecessary raise exception stuff
                    "RET",                      -- unnecessary return stuff
                    "SLF",                      -- self access
                    "SIM",                      -- simplify
                    "TID",                      -- tidy imports
                    "TCH",                      -- type checking
                    "INT",                      -- printf
                    "ARG",                      -- unused arguments
                    --"PTH",                    -- use pathlib
                    --"ERA",                    -- commented code
                    "PD",                       -- pandas code
                    "PGH",                      -- pygrep hooks
                    --"PLC", "PLE", "PLR", "PLW"-- pylint
                    "TRY",                      -- tryceratops (exception anti pattern)
                    "NPY",                      -- numpy
                    "RUF"                       -- ruf rules
                  },
                  formatEnabled = true,
                  format = { "I" }              -- autocorrect on reformat
                },
                -- completion and renaming
                rope_completion = {
                  enabled = false        -- disabled by default, 3rd party since v1.12.0
                                         -- causes pylsp to hang with 100% cpu, disable for now
                },
                -- type checker
                pylsp_mypy = {
                  enabled = true        -- 3rd party
                },

                -- error checking, replaced by ruff
                flake8 = { enabled = false },
                -- linter for docstring style checking (mostly included in pylint)
                pydocstyle = { enabled = false },
                -- linter for style checking (included in flake8/ruff)
                pycodestyle = { enabled = false },
                -- linter for complexity (included in flake8/ruff)
                mccabe = { enabled = false },
                -- linter for errors (included in flake8/ruff)
                pyflakes = { enabled = false },
                -- code formatting (disable in favor of yapf)
                autopep8 = { enabled = false },
                -- code formatting (disable in favor of black)
                yapf = { enabled = false }
                -- code formatter (replaced by ruff-format)
                --black = {
                --  enabled = true,       -- 3rd party
                --  line_length = 120
                --},
              }
            }
          }
        },
        --[
        -- Language: Haskell
        -- Server: haskell-language-server
        -- dev-haskell/haskell-language-server
        --]
        hls = {},
        --[
        -- Language: C/C++
        -- Server: clangd
        -- sys-devel/clang
        --]
        clangd = {
          on_attach = on_attach_clangd
        },
        --[
        -- Language: LaTeX
        -- Server: texlab
        -- dev-tex/texlab
        --]
        texlab = {
          on_attach = on_attach_texlab,
          settings = {
            texlab = {
              chktex = {
                onOpenAndSave = true    -- run chktex on save
              }
            }
          }
        },
        --[
        -- Language: Lua
        -- Server: lua_ls
        -- installed by mason
        --]
        lua_ls = {
          settings = {
            Lua = {
              hint = {
                enable = true
              },
              telemetry = {
                enable = false
              }
            }
          }
        },
        --[
        -- Language: Ruby
        -- Server: ruby_lsp
        -- installed by mason
        --]
        ruby_lsp = {},
        --[
        -- Language: Go
        -- Server: gopls
        -- installed by mason
        --]
        gopls = {},
        --[
        -- Language: C#
        -- Server: csharp_ls
        -- installed by mason
        --]
        csharp_ls = {}
      }

      -- Helper function for resolving executables
      function check_cmd(conf)
        if conf.cmd and type(conf.cmd) == 'table' and not vim.tbl_isempty(conf.cmd) then
          return conf.cmd[1]
        end
        return nil
      end

      -- Configure lsp servers
      for server_name, server_config in pairs(servers) do
        local executable = check_cmd(server_config) or check_cmd(lspconfig[server_name].config_def.default_config)

        if vim.fn.executable(executable) == 1 then
          server_config = vim.tbl_deep_extend('force', {capabilities = default_capabilities, on_attach = default_on_attach}, server_config)
          -- TODO replace lspconfig.setup with vim.lsp
          lspconfig[server_name].setup(server_config)
          --vim.lsp.config(server_name, server_config)
          --vim.lsp.enable(server_name)
        end
      end

      --Set on_attach function for rustaceanvim
      --Superseeds the rust-analyzer config above
      --{"rust-analyzer", lspconfig.rust_analyzer,  {}},  -- dev-lang/rust +rust-analyzer
      vim.g.rustaceanvim = {server = {on_attach = default_on_attach}}

    end
  },
  -- DAP (Debugging)
  {
    'mfussenegger/nvim-dap',
    -- ft = { "c", "cpp", "haskell", "python" },  -- dap is dependency of mason, lazy loading is useless
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
  -- Mason DAP (must come after nvim-dap)
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'mfussenegger/nvim-dap' },
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
