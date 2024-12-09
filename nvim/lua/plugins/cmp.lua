-- Completion
return {
  'hrsh7th/nvim-cmp',               -- completion plugin
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',                 -- complete using language servers
    'hrsh7th/cmp-nvim-lsp-signature-help',  -- highlight current parameter in completion
    'hrsh7th/cmp-buffer',                   -- complete words in current buffer
    'hrsh7th/cmp-path',                     -- complete filepaths
    'hrsh7th/cmp-cmdline',                  -- complete cmdline
    'saadparwaiz1/cmp_luasnip',             -- complete luasnip snippets
    'onsails/lspkind.nvim',                 -- show symbols in completion menu
    'L3MON4D3/LuaSnip',                     -- snippet plugin
    'rafamadriz/friendly-snippets',         -- snippets
    'mrcjkb/haskell-snippets.nvim'          -- haskell snippets
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require('lspkind')

    --[
    -- the mapping needs the structure: [key] = {<mode> = function}
    --  cmp.mapping is a wrapper around cmp that returns the corresponding function (and contains some erorr handling/defaults)
    --  Using cmp.mapping here would result in the structure : [key] = {<mode> = function = function {}} which will not work
    -- -> Don't use cmp.mapping here
    --
    -- see https://github.com/hrsh7th/nvim-cmp/blob/cfafe0a1ca8933f7b7968a287d39904156f2c57d/lua/cmp/config/mapping.lua
    --
    -- Note: in the following, a and b is shorthand for if a: if b: ...
    -- Note: additionally, this structure falls back to the fallback option if the command fails
    --       (e.g. required for a working <cr> if no text is selected)
    --
    --]

    -- select next item or fallback
    local next_item = function(fallback)
      if cmp.visible() and cmp.select_next_item() then
        return
      end
      fallback()
    end

    -- select previous item or fallback
    local previous_item = function(fallback)
      if cmp.visible() and cmp.select_prev_item() then
        return
      end
      fallback()
    end

    -- confirm or fallback
    local confirm = function(fallback)
      if cmp.visible() and cmp.confirm() then
        return
      elseif cmp.visible() then
        if vim.api.nvim_get_mode()['mode'] == 'c' then
          -- command mode, text should be kept
          cmp.close()
        else
          -- any other mode, text should be deleted
          cmp.abort()
        end
        -- fallthrough
      end
      fallback()
    end

    -- abort or fallback
    local abort = function(fallback)
      if cmp.visible() and cmp.abort() then
        return
      end
      fallback()
    end

    -- luasnip next
    local next_snippet = function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
        return
      end
      fallback()
    end

    -- luasnip previous
    local previous_snippet = function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
        return
      end
      fallback()
    end

    local default_mapping = function()
      return {
        ['<C-space>'] = { i = function(fallback) return next_item(cmp.complete) end },
        ['<Tab>'] = { i = next_item },
        ['<S-Tab>'] = { i = previous_item },
        ['<Down>'] = { i = next_item },
        ['<Up>'] = { i = previous_item },
        ['<A-l>'] = { i = next_snippet, s = next_snippet },
        ['<A-h>'] = { i = previous_snippet, s = previous_snippet },
        ['<cr>'] = { i = confirm },
        ['<C-e>'] = { i = abort }
      }
    end

    local cmdline_mapping = function()
      -- functionally identical to 'cmp.mapping.preset.cmdline()'
      return {
        ['<Tab>'] = { c = function(fallback) return next_item(cmp.complete) end },
        ['<S-Tab>'] = { c = previous_item },
        ['<cr>'] = { c = confirm },
        ['<C-n>'] = { c = next_item },
        ['<C-p>'] = { c = previous_item },
        ['<C-e>'] = { c = abort }
      }
    end


    -- autocomplete writing
    cmp.setup {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end
      },
      window = {},
      mapping = default_mapping(),
      sources = cmp.config.sources(
        {
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' }
        }
      ),

      -- lspkind config
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...'
        })
      }
    }

    -- autocomplete search
    cmp.setup.cmdline( { '/', '?' }, {
      mapping = cmdline_mapping(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- autocomplete commands
    cmp.setup.cmdline( ':', {
      mapping = cmdline_mapping(),
      sources = {
        { name = 'cmdline' },
        { name = 'path' }
      }
    })

    -- load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- load haskell snippets
    local haskell_snippets = require("haskell-snippets").all
    luasnip.add_snippets('haskell', haskell_snippets, { key = 'haskell' })
  end
}
