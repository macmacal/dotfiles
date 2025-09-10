return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- TODO Remote nvim server

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
        "bash",
        "c", "cpp", "make", "cmake",
        "dockerfile",
        "git_config", "gitignore",
        "markdown", "markdown_inline",
        "python",
        "query",
        "ssh_config",
        "tmux",
        "xml",
        "yaml", "json",
  		},
      highlight = { enable = true },
  	},
  },
}
