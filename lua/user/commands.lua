local add_command = require("nebula.helpers.nvim").add_user_command

add_command("C", "nohlsearch")

local neovim_config = vim.fn.stdpath("config")
add_command("EditInit", string.format("edit %s", neovim_config .. "/init.lua"))
