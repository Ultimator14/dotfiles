-- Rename variables
return {
  'smjonas/inc-rename.nvim',
  cmd = "IncRename",
  keys = {
    { '<leader>rn', ':IncRename ', desc = 'Rename Symbol', mode = "n" }
  },
  opts = {}
}
