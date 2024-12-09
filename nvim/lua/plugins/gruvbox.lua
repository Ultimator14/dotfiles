-- Color schemes
return {
  'ellisonleao/gruvbox.nvim',
  config = function()
    require("gruvbox").setup({
      italic = {
        strings = false,
        emphasis = true,
        comments = false,
        operators = false,
        folds = false
      }
    })
    vim.cmd("colorscheme gruvbox")
  end
}
