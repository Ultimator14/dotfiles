-- LSP
return {
  'neovim/nvim-lspconfig',                              -- (default) configs for different lsp servers
  dependencies = { "hrsh7th/cmp-nvim-lsp" },            -- cmp must be initialized first to enable capabilities
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

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require('lspconfig')
    local utils = require('utils')


    -- Lsp related keymaps (global)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostics', silent = true })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev , { desc = 'Go to previous diagnostic', silent = true })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next , { desc = 'Go to next diagnostic', silent = true })

    -- Lsp related keymaps (per buffer)
    local on_attach = function(client, bufnr)
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
      on_attach(client, bufnr)
      vim.keymap.set('n', '<localleader>b', ':TexlabBuild<cr>', { desc = 'Build tex file', silent = true })
    end

    local on_attach_clangd = function(client, bufnr)
      on_attach(client, bufnr)

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

    -- configure lsp servers
    -- emerge -a dev-python/python-lsp-server
    -- emerge -a dev-python/python-lsp-ruff
    -- emerge -a dev-python/pylsp-mypy
    -- emerge -a dev-python/pylint-venv  (don't require pylint to be installed in each venv)
    if vim.fn.executable("pylsp") == 1 then
      lspconfig.pylsp.setup {
        capabilities = capabilities,
        on_attach = on_attach,
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
                enabled = true        -- disabled by default
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
      }
    end

    -- emerge -a dev-haskell/haskell-language-server
    if vim.fn.executable("haskell-language-server-wrapper") == 1 then
      lspconfig.hls.setup {
        capabilities = capabilities,
        on_attach = on_attach
      }
    end

    -- sys-devel/clang
    if vim.fn.executable("clangd") == 1 then
      lspconfig.clangd.setup{
        capabilities = capabilities,
        on_attach = on_attach_clangd
      }
    end

    -- dev-tex/texlab
    if vim.fn.executable("texlab") == 1 then
      lspconfig.texlab.setup{
        capabilities = capabilities,
        on_attach = on_attach_texlab,
        settings = {
          texlab = {
            chktex = {
              onOpenAndSave = true    -- run chktex on save
            }
          }
        }
      }
    end

    -- lua-language-server (installed by mason)
    if vim.fn.executable('lua-language-server') == 1 then
      lspconfig.lua_ls.setup{
        capabilities = capabilities,
        on_attach = on_attach
      }
    end

    -- ruby language server (installed by mason)
    if vim.fn.executable('ruby-lsp') == 1 then
      lspconfig.ruby_lsp.setup{
        capabilities = capabilities,
        on_attach = on_attach
      }
    end
  end
}