-- Advanced code highlighting
return {
  'nvim-treesitter/nvim-treesitter',
  event = { "BufReadPre", "BufNewFile" },
  build = ':TSUpdate',
  lazy = false,               -- :TSUpdate should be available at all times
  dependencies = {
    'windwp/nvim-ts-autotag', -- auto close html tags
  },
  config = function()
    -- A list of parser names to install
    -- Do not add 'latex' as it requires node to compile which is not available on all hosts
    local parsers = { "bash", "c", "cpp", "css", "dockerfile", "haskell", "vimdoc", "http", "java", "json", "lua", "make",
      "markdown", "markdown_inline", "php", "python", "regex", "vim", "yaml" }

    require("nvim-treesitter").install(parsers)

    -- Auto enalbe for all known filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        vim.treesitter.start()
      end
    })

    --disable highlighting for large files
    vim.api.nvim_create_autocmd("BufReadPre", {
      callback = function(args)
        local max_filesize = 1024 * 1024   -- 1 MB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then
          vim.treesitter.stop(args.buf)
        end
      end
    })
  end
}
