return {
   "m4xshen/hardtime.nvim",
   dependencies = { "MunifTanjim/nui.nvim" },
   lazy = false,
   config = function ()
     require("hardtime").setup()
   end
}
