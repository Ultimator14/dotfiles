-- Pseudo lsp server to get diagnostics from non-lsp software
return {
  'nvimtools/none-ls.nvim',
  event = { "BufReadPre", "BufNewFile", "BufNew" },  -- load on file open, new file and in memory editing
  dependencies = {
    'nvimtools/none-ls-extras.nvim',                 -- Extra sources for none-ls
    'gbprod/none-ls-php.nvim',                       -- Extra php sources for none-ls
  },
  config = function()
    local nls = require('null-ls')

    nls.setup {
      sources = {
        -- Builtin sources
        nls.builtins.diagnostics.zsh,
        nls.builtins.formatting.gofmt,
        -- Extra sources using other plugins
        require("none-ls-php.diagnostics.php"),
        require('none-ls.formatting.jq'),
      }
    }
  end
}
