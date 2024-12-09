-- Show marks
return {
  'chentoast/marks.nvim',
  opts = {
    default_mappings = true,                  -- default true, note: this will break which-key preview for m and dm
    builtin_marks = { '.', "<", ">", "^" },   -- which builtin marks to show. default {}
    refresh_interval = 100,                   -- redraw interval (default is 150)
    sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
    -- bookmarks groups
    bookmark_0 = {
      sign = "⚑",
      virt_text = "TODO",
      annotate = false,                       -- prompt for virtual text
    },
    bookmark_1 = {
      sign = "",
      virt_text = "Comment",
      annotate = false,                       -- prompt for virtual text
    },
    bookmark_2 = {
      sign = "",
      virt_text = "OK",
      annotate = false,                       -- prompt for virtual text
    },
    bookmark_3 = {
      sign = "",
      virt_text = "Warn",
      annotate = false,                       -- prompt for virtual text
    },
    bookmark_4 = {
      sign = "",
      virt_text = "Error",
      annotate = false,                       -- prompt for virtual text
    },
    bookmark_5 = {
      sign = "5",
      virt_text = "",
      annotate = false,                       -- prompt for virtual text
    },
    bookmark_6 = {
      sign = "6",
      virt_text = "",
      annotate = false,                       -- prompt for virtual text
    },
    bookmark_7 = {
      sign = "7",
      virt_text = "",
      annotate = false,                       -- prompt for virtual text
    },
    bookmark_8 = {
      sign = "8",
      virt_text = "",
      annotate = false,                       -- prompt for virtual text
    },
    bookmark_9 = {
      sign = "9",
      virt_text = "",
      annotate = false,                       -- prompt for virtual text
    },
    mappings = {}                             -- additional custom mappings
    }
}
