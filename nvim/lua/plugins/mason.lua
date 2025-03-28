-- LSP/DAP installation
return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  config = function()
    -- Mason
    require('mason').setup()

    -- Mason lspconfig
    require('mason-lspconfig').setup{
      ensure_installed = { "lua_ls" },
      automatic_installation = false
    }

    -- Mason dap
    require("mason-nvim-dap").setup{
      ensure_installed = { "python" },
      automatic_installation = false,
      handlers = {
        function(config)
          -- Disable default setup for all available plugins. This makes configuration in dap.lua obsolete
          -- Note: This function is implicitly defined as soon as handlers is not nil
          -- We explicitly define it here to disable interfering with plugins that should not be touched
          --require("mason-nvim-dap").default_setup(config)
        end,
        python = function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
        haskell = function(config)
          -- Requires haskell-debug-adapter installation via mason
          require("mason-nvim-dap").default_setup(config)
        end
      },
    }
  end,
  build = ':MasonUpdate'
}
