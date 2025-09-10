require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Nvim-tree mappings
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local git_add = function()
      local node = api.tree.get_node_under_cursor()
      local gs = node.git_status.file

      -- If the current node is a directory get children status
      if gs == nil then
        gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
             or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
      end

      -- If the file is untracked, unstaged or partially staged, we stage it
      if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
        vim.cmd("silent !git add " .. node.absolute_path)

      -- If the file is staged, we unstage
      elseif gs == "M " or gs == "A " then
        vim.cmd("silent !git restore --staged " .. node.absolute_path)
      end

      api.tree.reload()
  end

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local function file_preview()
    api.node.open.edit()
    api.tree.focus()
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,    opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,              opts('Help'))
  vim.keymap.set("n", "l",     api.node.open.edit,                opts("Open & enter"))
  vim.keymap.set("n", "L",     file_preview,                      opts("Open"))
  vim.keymap.set("n", "h",     "<Nop>",                           opts("Disable h key"))
  vim.keymap.set("n", "H",     api.tree.collapse_all,             opts("Collapse All"))
  vim.keymap.set('n', 'ga',    git_add,                           opts('Git Add'))
end

-- pass to setup along with your other options
require("nvim-tree").setup {
  on_attach = my_on_attach,
}
