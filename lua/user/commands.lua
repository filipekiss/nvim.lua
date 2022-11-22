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

local edit_snippets = function(default_create_path)
	local Cache = require("luasnip.loaders._caches")
	local util = require("luasnip.util.util")
	local format = function(path, _)
		path = path:gsub(
			vim.fn.stdpath("data") .. "/site/pack/packer/start",
			"$PLUGINS"
		)
		if vim.env.HOME then
			path = path:gsub(vim.env.HOME .. "/.config/nvim", "$CONFIG")
		end
		return path
	end

	local create_new_snippets_in = default_create_path
		or vim.fn.stdpath("config") .. "/snippets/"

	local fts = util.get_snippet_filetypes()
	vim.ui.select(fts, {
		prompt = "Select filetype:",
	}, function(ft, _)
		if ft then
			local ft_paths = {}
			local items = {}

			-- concat files from all loaders for the selected filetype ft.
			for _, cache_name in ipairs({ "vscode", "snipmate", "lua" }) do
				for _, path in ipairs(Cache[cache_name].ft_paths[ft] or {}) do
					local is_plugin = false
					local pattern = "^" .. vim.fn.stdpath("data")
					if path:match(pattern) then
						is_plugin = true
					end
					local fmt_name = format(path, cache_name)
					if fmt_name and not is_plugin then
						table.insert(ft_paths, path)
						table.insert(items, fmt_name)
					end
				end
			end

			-- prompt user again if there are multiple files providing this filetype.
			if #ft_paths > 1 then
				vim.ui.select(items, {
					prompt = "Multiple files for this filetype, choose one:",
				}, function(_, indx)
					if indx and ft_paths[indx] then
						vim.cmd("edit " .. ft_paths[indx])
					end
				end)
			elseif ft_paths[1] then
				vim.cmd("edit " .. ft_paths[1])
			else
				vim.cmd("edit " .. create_new_snippets_in .. ft .. ".lua")
			end
		end
	end)
end

local function toggle_fold_marker()
	local foldmethod = vim.wo.foldmethod
	local is_marker_toggle = vim.b.marker_toggle
	if is_marker_toggle then
		vim.b.marker_toggle = false
		vim.wo.foldmethod = vim.b.previous_fold_method
		print(
			"Fold method set to "
				.. vim.b.previous_fold_method
				.. " (was "
				.. foldmethod
				.. ")"
		)
		return
	end
	vim.b.marker_toggle = true
	vim.b.previous_fold_method = foldmethod
	vim.wo.foldmethod = "marker"
	print("Fold method set to marker (was " .. foldmethod .. ")")
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

add_command("EditSnippets", edit_snippets)

add_command("FormatJson", "%!python3 -m json.tool")

add_command("FoldMethod", toggle_fold_marker)

add_command("Del", ":call delete(@%) | bdelete!")
