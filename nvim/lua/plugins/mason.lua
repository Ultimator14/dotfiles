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
  end,
  build = ':MasonUpdate'
}
