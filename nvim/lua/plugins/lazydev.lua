-- Completion for (lua) neovim config
local table_contains = function(table, value)
  for i = 1,#table do
    if (table[i] == value) then
      return true
    end
  end
  return false
end

return {
  'folke/lazydev.nvim',
  ft = {'lua'},
  opts = {
    enabled = function(root_dir)
      -- enable for nvim dirs
      local supported_dirs = {
        "/usr/local/dotfiles/nvim",
        "~/.config/nvim"
      }
      return table_contains(supported_dirs, root_dir)
    end
  }
}
