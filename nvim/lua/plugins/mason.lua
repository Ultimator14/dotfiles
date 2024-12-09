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
      automatic_installation = false
    }
  end,
  build = ':MasonUpdate'
}
