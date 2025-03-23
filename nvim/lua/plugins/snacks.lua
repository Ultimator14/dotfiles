-- Various QoL improvements
-- Relaces dessing.lua for better looking Input/Select Windows via input and picker
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  --@type snacks.Config
  opts = {
    --bigfile = { enabled = true },
    --dashboard = { enabled = true },
    --explorer = { enabled = true },
    --indent = { enabled = true },
    input = { enabled = true },   -- pretty vim.ui.input
    picker = { enabled = true },  -- pretty vim.ui.select
    --notifier = { enabled = true },
    --quickfile = { enabled = true },
    --scope = { enabled = true },
    --scroll = { enabled = true },
    --statuscolumn = { enabled = true },
    --words = { enabled = true },
  },
}
