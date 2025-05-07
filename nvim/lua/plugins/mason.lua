-- Mason
return {
  'mason-org/mason.nvim',
  config = true,
  build = ':MasonUpdate',
  -- pin for now (see https://github.com/mason-org/mason-lspconfig.nvim/issues/545)
  -- remove this along with the lspconfig transition to vim.lsp.enable()
  version = "1.11.0"
}
