-- Autopairs
return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = function()
    require('nvim-autopairs').setup({
      disable_filetype = { "TelescopePrompt" }
    })
    require('nvim-ts-autotag').setup()
  end
}
