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

  -- Remote nvim server
  {
     "amitds1997/remote-nvim.nvim",
     version = "v0.3.12", -- Pin to GitHub releases
     dependencies = {
         "nvim-lua/plenary.nvim", -- For standard functions
         "MunifTanjim/nui.nvim", -- To build the plugin UI
         -- "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
     },
     config = true,
  },

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
