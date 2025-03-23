-- Various QoL improvements
-- Relaces dessing.lua for better looking Input/Select Windows via input and picker
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  --@type snacks.Config
  opts = {
    input = { enabled = true },     -- pretty vim.ui.input
    picker = { enabled = true },    -- pretty vim.ui.select
    notifier = {                    -- pretty vim.notify
      enabled = true,
      timeout = 5000,
    },
    scroll = { enabled = true },    -- smooth scrolling with Bildauf/Bildab
  },
  keys = {
    -- Notifier
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },

  }
}
