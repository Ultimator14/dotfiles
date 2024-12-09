-- File tree
return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Initial open if in dir
      -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
      local function open_nvim_tree_if_dir(data)
        -- buffer is a directory
        local directory = vim.fn.isdirectory(data.file) == 1

        if not directory then
          return
        end

        -- change to the directory
        vim.cmd.cd(data.file)

        -- open the tree
        require("nvim-tree.api").tree.open()
      end

      local on_attach = function(bufnr)
        -- Map all default key bindings
        require("nvim-tree.api").config.mappings.default_on_attach(bufnr)
        -- Remove key binding from defaults
        vim.keymap.del('n', '<Tab>', { buffer = bufnr })
      end

      vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree_if_dir })

      -- Setup
      require("nvim-tree").setup {
        on_attach = on_attach,
        disable_netrw = true,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        hijack_directories = {
          enable = true
        },
        tab = {
          sync = {
            open = true,    -- open tree in new tab
            close = true,   -- close tree in all tabs
          },
        },
        update_focused_file = {
          enable = true,
          update_root = true
        }
      }

      -- F6 to toggle nvim tree
      vim.keymap.set('n', '<F6>', ':NvimTreeToggle<CR>', { desc = 'Toggle Nvim-Tree', silent = true })
    end
  },
}
