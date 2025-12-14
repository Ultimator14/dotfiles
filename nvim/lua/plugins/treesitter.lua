-- Advanced code highlighting
return {
  'nvim-treesitter/nvim-treesitter',
  event = { "BufReadPre", "BufNewFile" },
  build = ':TSUpdateSync',
  lazy = false,  -- :TSUpdate should be available at all times
  dependencies = {
    'windwp/nvim-ts-autotag', -- auto close html tags
  },
  main = "nvim-treesitter.configs",
  opts = {
    -- A list of parser names, or "all" (the four listed parsers should always be installed)
    -- Do not add 'latex' as it requires node to compile which is not available on all hosts
    ensure_installed = { "bash", "c", "cpp", "css", "dockerfile", "haskell", "vimdoc", "http", "java", "json", "lua", "make", "markdown", "markdown_inline", "php", "python", "regex", "vim", "yaml" },
    sync_install = false,   -- synchronous installation
    auto_install = true,    -- auto install missing
    --ignore_install = { "javascript" },  -- ignore if ensure_installed is 'all'

    highlight = {
      enable = true,

      --disable for large files
      disable = function(lang, buf)
        local max_filesize = 1024 * 1024     -- 1 MB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      -- alternatively: disable per parser
      --disable = { "c", "rust" },

      additional_vim_regex_highlighting = false,
    },
  }
}
