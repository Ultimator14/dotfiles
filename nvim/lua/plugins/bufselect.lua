-- Buffer navigation
return {
  'PhilRunninger/bufselect',
  cmd = "ShowBufferList",
  keys = {
    -- Set keymap to display buffer list
    { '<leader>bs', ':ShowBufferList<cr>', desc = 'Show Buffer List', mode = "n", silent = true }
  },
  init = function()
    -- Use colors matching colorscheme
    vim.g.BufSelectHighlightCurrent = 'Identifier'
    vim.g.BufSelectHighlightAlt     = 'Label'
    vim.g.BufSelectHighlightUnsaved = 'Error'
    vim.g.BufSelectHighlightSort    = 'Function'
  end
}
