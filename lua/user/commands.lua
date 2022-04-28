local add_command = require("nebula.helpers.nvim").add_user_command

add_command("C", "nohlsearch")

local neovim_config = vim.fn.stdpath("config")
add_command("EditInit", string.format("edit %s", neovim_config .. "/init.lua"))

local edit_file = function(folder)
	return function(file)
		local config_path = vim.fn.stdpath("config")
		if file == "" or file == "init" then
			file = config_path .. "/init.lua"
			vim.api.nvim_command("edit " .. file)
			return
		end
		local config_path = vim.fn.stdpath("config")
			.. "/lua/"
			.. folder
			.. "/"
			.. file
			.. ".lua"
		vim.api.nvim_command("edit " .. config_path)
	end
end

add_command("EditPluginConfig", edit_file("user/config"), {
	"-nargs=1",
	[[-complete=customlist,v:lua.require'user.functions'.edit_plugin_config_completelist]],
	cmd_args = { "<q-args>" },
})

add_command("EditConfig", edit_file("user"), {
	"-nargs=1",
	[[-complete=customlist,v:lua.require'user.functions'.edit_config_completelist]],
	cmd_args = { "<q-args>" },
})

add_command("EditPlugin", edit_file("user/plugins"), {
	"-nargs=1",
	[[-complete=customlist,v:lua.require'user.functions'.edit_plugin_completelist]],
	cmd_args = { "<q-args>" },
})
