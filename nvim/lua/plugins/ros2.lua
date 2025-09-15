return {
	"ErickKramer/nvim-ros2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("nvim-ros2").setup({})
	end
}
