return {
  {
      "kdheepak/lazygit.nvim",
      lazy = true,
      cmd = {
          "LazyGit",
          "LazyGitConfig",
          "LazyGitCurrentFile",
          "LazyGitFilter",
          "LazyGitFilterCurrentFile",
      },
      -- optional for floating window border decoration
      dependencies = {
          "nvim-lua/plenary.nvim",
      },
      -- setting the keybinding for LazyGit with 'keys' is recommended in
      -- order to load the plugin when the command is run for the first time
      keys = {
          { "<leader>gl", "<cmd>LazyGit<cr>", desc = "LazyGit" }
      }
  },
	{
		"f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
        enabled = true,
        message_template = " <summary> • <date> • <author> • <<sha>>",
        date_format = "%Y-%m-%d %H:%M",
        virtual_text_column = 1,
    },
    keys = {
          { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "GitBlame toggle" }
    }
	}
}
