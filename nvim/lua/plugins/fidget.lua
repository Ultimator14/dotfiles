-- Show lsp progress in lower right corner
return {
  'j-hui/fidget.nvim',
  opts = {
    notification = {
      window = {
        avoid = {
          -- Avoid nvim-tree file explorer
          "NvimTree"
        }
      }
    }
  }
}
