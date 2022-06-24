local functions = {}
local current_lcd = vim.fn.getcwd()

local function find_longest_string(strings)
	local longest = nil
	for _, string in pairs(strings) do
		if not longest or #string > #longest then
			longest = string
		end
	end
	return longest
end

local function get_git_dir(path)
	local git_dir = vim.fn.system("cd " .. path .. ' && git rev-parse --show-toplevel 2> /dev/null || echo ""')
	git_dir = git_dir:gsub(".$", "")
	if git_dir == "" then
		return nil
	end
	return git_dir
end

local function find_file_in(filename, starting_path, search_until)
	-- if search_until is empty, get the value for $HOME
	local end_search_at = search_until or vim.fn.getenv("HOME")
	-- if end_search_at is empty or is lenghtier than starting_path it it means that
	-- we couldn't find the file, so we return an empty string
	if end_search_at == vim.NIL or (#starting_path < #end_search_at) then
		return nil
	end
	if filename == ".git" then
		return get_git_dir(starting_path)
	end
	local file_exists = vim.fn.filereadable(starting_path .. "/" .. filename)
	if file_exists == 1 then
		-- found the file we were looking for, return the path to the folder where it was
		return starting_path
	end
	-- if we didn't find the file, recursively search one folder up until we exhaust
	-- the options
	return find_file_in(filename, vim.fn.fnamemodify(starting_path, ":h"), search_until)
end

local function get_project_dir(starting_dir)
	local is_dir = vim.fn.isdirectory(starting_dir)
	if is_dir == 0 then
		return nil
	end
	local default_project_roots_files = {
		".git",
		"nx.json",
		"package.json",
	}
	local user_project_roots = vim.g.project_roots_files
	local project_roots = vim.tbl_extend("force", default_project_roots_files, user_project_roots or {})
	local results = {}
	for _, file in pairs(project_roots) do
		local result = find_file_in(file, starting_dir)
		if result then
			table.insert(results, result)
			return result
		end
	end
	-- local project_path = find_longest_string(results)
	-- return project_path
end

function functions.set_project_dir()
	local current_folder = vim.fn.expand("%:p:h")
	local project_dir = get_project_dir(current_folder)
	if project_dir and project_dir ~= current_lcd then
		-- change vim directory to the found project folder
		vim.fn.chdir(project_dir)
		current_lcd = project_dir
		print("Changed project folder to " .. project_dir)
		return
	end
end

function functions.set_isgit_option()
	-- local project_dir = get_project_dir(vim.fn.expand("%:p:h"))
	local is_git = get_git_dir(vim.fn.expand("%:p:h"))
	if is_git then
		Nebula.user_options.is_git = true
		return
	end
	Nebula.user_options.is_git = false
end

function functions.display_line_numbers(mode)
	local change_setting = require("nebula.helpers.settings").change_setting
	local filetype = vim.bo.filetype
	if vim.tbl_contains(Nebula.user_options.display_line_numbers.disabled, filetype) then
		change_setting("relativenumber", false)
		change_setting("number", false)
		return
	end
	if vim.tbl_contains(Nebula.user_options.display_line_numbers.enabled, filetype) then
		change_setting("relativenumber", false)
		change_setting("number", true)
		return
	end
	if vim.tbl_contains(Nebula.user_options.display_line_numbers.enabled_relative, filetype) then
		change_setting("relativenumber", true)
		change_setting("number", true)
		return
	end
	if mode == "i" then
		change_setting("relativenumber", false)
		change_setting("number", true)
		return
	end
	change_setting("relativenumber", true)
	change_setting("number", true)
end

local edit_file_completelist = function(options)
	local recursive = options.recursive or true
	local folder = options.folder
	local ext = options.extension or "lua"
	return function(lead, _, _)
		local split_string = require("nebula.helpers.nvim").split_string
		local config_path = vim.fn.stdpath("config") .. "/" .. folder
		local glob_pattern = "**/*." .. ext
		if not recursive then
			glob_pattern = "*." .. ext
		end
		local available_paths = split_string("\n", vim.fn.globpath(config_path, glob_pattern))
		local available_completions = vim.tbl_map(function(path)
			return path:gsub(config_path .. "/", ""):gsub("." .. ext .. "$", "")
		end, available_paths)
		local completion_list = vim.tbl_filter(function(name)
			return vim.startswith(name, lead)
		end, available_completions)
		table.sort(completion_list)
		return completion_list
	end
end

functions.edit_plugin_config_completelist = edit_file_completelist({
	folder = "lua/user/config",
})

functions.edit_config_completelist = edit_file_completelist({
	folder = "lua/user",
	recursive = false,
})
functions.edit_plugin_completelist = edit_file_completelist({
	folder = "lua/user/plugins",
})

functions.edit_snippet_completelist = edit_file_completelist({
	folder = "snippets",
	extension = "json",
})

return functions
