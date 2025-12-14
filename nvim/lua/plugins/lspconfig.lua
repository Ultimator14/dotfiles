-- LSP
return {
  {
    'mason-org/mason-lspconfig.nvim',
    lazy = true,                                   -- load as dependency of nvim-lspconfig
    dependencies = { 'mason-org/mason.nvim' },     -- must come after mason
    config = function()
      -- This MUST load before nvim-lspconfig
      -- This is not guaranteed by just using dependencies
      -- mason-lspconfig setup is done BEFORE nvim-lspconfig has loaded in that config function
    end
  },
  {
    'neovim/nvim-lspconfig',                              -- (default) configs for different lsp servers
    event = { "BufReadPre", "BufNewFile", "BufNew" },     -- load on file open, new file and in memory editing
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",                             -- cmp must be initialized first to enable capabilities
      'mason-org/mason-lspconfig.nvim'                    -- nvim-lspconfig must come after mason-lspconfig
    },
    config = function()
      -- Mason lspconfig, load BEFORE nvim-lspconfig has loads
      require('mason-lspconfig').setup({
        automatic_enable = true,
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
      -- Helper function for resolving executables
      function check_cmd(server_name)
        local conf = vim.lsp.config[server_name]

        if conf.cmd and type(conf.cmd) == 'table' and not vim.tbl_isempty(conf.cmd) then
          return conf.cmd[1]
        elseif server_name == "csharp_ls" then
          -- csharp has a function as cmd to read sln files for the project
          -- handle separately here
          return "csharp-ls"
        end

        return nil
      end

      -- Default config for lsp servers
      vim.lsp.config("*", {
        capabilities = default_capabilities,
        on_attach = default_on_attach
      })

      -- Special handling for some servers
      vim.lsp.config("clangd", {
        on_attach = on_attach_clangd
      })
      vim.lsp.config("texlab", {
        on_attch = on_attach_texlab
      })

      -- LSP servers we support
      local servers = {
        "pylsp",
        "hls",
        "clangd",
        "texlab",
        "ruby_lsp",
        "gopls",
        "csharp_ls",
        "cssls",
        "html",
        "jsonls",
        "eslint"
      }

      -- Enable configured and installed lsp servers
      for _, server_name in ipairs(servers) do
        local executable = check_cmd(server_name)
        if vim.fn.executable(executable) == 1 then
          vim.lsp.enable(server_name)
        end
      end

      --Set on_attach function for rustaceanvim
      --Superseeds the rust-analyzer config above
      --{"rust-analyzer", lspconfig.rust_analyzer,  {}},  -- dev-lang/rust +rust-analyzer
      vim.g.rustaceanvim = {server = {on_attach = default_on_attach}}

    end
  }
}
