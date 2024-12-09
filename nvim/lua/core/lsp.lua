-- Override location handler to open lsp related stuff in a new tab instead of the same buffer
-- source https://github.com/neovim/neovim/blob/f006313e95022340b2b0ae28e8223e6e548f0826/runtime/lua/vim/lsp/handlers.lua#L362
-- see https://pastebin.com/8PSML239
-- see https://github.com/neovim/neovim/pull/12966
-- see https://neovim.discourse.group/t/how-to-customize-lsp-actions/349/5

local api = vim.api
local util = require('vim.lsp.util')
local log = require('vim.lsp.log')

local custom_location_handler = function(_, result, ctx, config)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')
    return nil
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)

  config = config or {}

  if result[1]["uri"] ~= ctx["params"]["textDocument"]["uri"] then
    -- source and target file are the same, jump in same tab
    api.nvim_command('tab split')  -- Add tab split to open commands in a new tab
  end

  if vim.islist(result) then
    local title = 'LSP locations'
    local items = util.locations_to_items(result, client.offset_encoding)

    if config.on_list then
      assert(type(config.on_list) == 'function', 'on_list is not a function')
      config.on_list({ title = title, items = items })
    else
      if #result == 1 then
        util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
        return
      end
      vim.fn.setqflist({}, ' ', { title = title, items = items })
      api.nvim_command('botright copen')
    end
  else
    util.jump_to_location(result, client.offset_encoding, config.reuse_win)
  end

end

-- set location handler for lsp functions
vim.lsp.handlers['textDocument/declaration'] = custom_location_handler
vim.lsp.handlers['textDocument/definition'] = custom_location_handler
vim.lsp.handlers['textDocument/typeDefinition'] = custom_location_handler
vim.lsp.handlers['textDocument/implementation'] = custom_location_handler
