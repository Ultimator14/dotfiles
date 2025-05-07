-- LSP
return {
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = true,                                   -- load as dependency of nvim-lspconfig
    dependencies = { 'williamboman/mason.nvim' },  -- must come after mason
    config = function()
      -- This MUST load before nvim-lspconfig
      -- This is not guaranteed by just using dependencies
      -- mason-lspconfig setup is done BEFORE nvim-lspconfig has loaded in that config function
    end,
  -- pin for now (see https://github.com/mason-org/mason-lspconfig.nvim/issues/545)
  -- remove this along with the lspconfig transition to vim.lsp.enable()
  version = "1.32.0"
  },
  {
    'neovim/nvim-lspconfig',                              -- (default) configs for different lsp servers
    event = { "BufReadPre", "BufNewFile", "BufNew" },     -- load on file open, new file and in memory editing
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",                             -- cmp must be initialized first to enable capabilities
      'williamboman/mason-lspconfig.nvim'                 -- nvim-lspconfig must come after mason-lspconfig
    },
    config = function()
      -- Mason lspconfig, load BEFORE nvim-lspconfig has loads
      require('mason-lspconfig').setup({
        ensure_installed = { "lua_ls" },
        automatic_installation = false
      })

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
        -- installed by mason
        --  :MasonInstall python-lsp-server
        --  :PylspInstall pylsp-mypy python-lsp-ruff pylint-venv
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
        csharp_ls = {},
        --[
        -- Language: HTML, Css, Json, Javascript
        -- Server: vscode-langservers-exracted (html, cssls, jsonls, eslint)
        -- installed by mason
        --]
        cssls = {},
        html = {},
        jsonls = {},
        eslint = {}
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
  }
}
