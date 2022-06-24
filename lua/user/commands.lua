local add_command = require("nebula.helpers.nvim").add_user_command

add_command("C", "nohlsearch")

local neovim_config = vim.fn.stdpath("config")
add_command("EditInit", string.format("edit %s", neovim_config .. "/init.lua"))

local edit_user_file = function(folder, extension)
	extension = extension or "lua"
	return function(file)
		local config_path = vim.fn.stdpath("config")
		if file == "" or file == "init" then
			file = config_path .. "/init." .. extension
			vim.api.nvim_command("edit " .. file)
			return
		end
		config_path = config_path
			.. "/"
			.. folder
			.. "/"
			.. file
			.. "."
			.. extension
		vim.api.nvim_command("edit " .. config_path)
	end
end

add_command("EditPluginConfig", edit_user_file("lua/user/config"), {
	"-nargs=1",
	[[-complete=customlist,v:lua.require'user.functions'.edit_plugin_config_completelist]],
	cmd_args = { "<q-args>" },
})

add_command("EditConfig", edit_user_file("lua/user"), {
	"-nargs=1",
	[[-complete=customlist,v:lua.require'user.functions'.edit_config_completelist]],
	cmd_args = { "<q-args>" },
})

add_command("EditPlugin", edit_user_file("lua/user/plugins"), {
	"-nargs=1",
	[[-complete=customlist,v:lua.require'user.functions'.edit_plugin_completelist]],
	cmd_args = { "<q-args>" },
})

add_command("FormatJson", "%!python3 -m json.tool")
