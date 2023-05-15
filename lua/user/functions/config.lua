local M = {}

local function file_exists(filepath)
	local stat = vim.loop.fs_stat(filepath)
	return stat and stat.type == "file"
end

local function ensure_file_extension(file_path, extension)
	if string.sub(file_path, -#extension) ~= extension then
		file_path = file_path .. "." .. extension
	end
	return file_path
end

local function remove_file_extension(file_path, extension)
	local extensionPattern = "%." .. extension .. "$"
	local dotIndex = file_path:find(extensionPattern)
	if dotIndex then
		file_path = file_path:sub(1, dotIndex - 1)
	end
	return file_path
end

local function normalize_user_command(command)
	local firstLetter = command:sub(1, 1)
	local restOfCommand = command:sub(2)
	return firstLetter:upper() .. restOfCommand
end

M.open_or_find = function(starting_path, open_vimrc)
	open_vimrc = open_vimrc or false
	return function(params)
		local args = params.fargs
		local query = args[1]
		local file_path = starting_path
			.. "/"
			.. (
				ensure_file_extension(query or "", "lua") or "non-existingf.ile"
			)
		if open_vimrc and params.bang and not query then
			vim.api.nvim_command("edit $MYVIMRC")
			return
		end
		local query_last_char = string.sub(query or "--", -1)
		local force_telescope = (
				query_last_char == " " or query_last_char == "!"
			) and not params.bang
		if file_exists(file_path) or (params.bang and query) then
			vim.api.nvim_command("edit " .. file_path)
			return
		end
		if params.bang and not query then
			vim.api.nvim_echo({
				{ ":" .. params.name .. "!", "Keyword" },
				{ " requires a file name.", "None" },
				{ " Try just ", "None" },
				{ ":" .. params.name, "Keyword" },
				{ " to open the file picker", "None" },
			}, false, {})
			return
		end
		if force_telescope then
			query = string.sub(query, 1, -2)
		end
		local telescope = require("user.functions.telescope")
		telescope("files", { cwd = starting_path, default_text = query or "" })()
	end
end

M.complete_files = function(opts)
	return function(query, _)
		local function ls(path, fn)
			local handle = vim.loop.fs_scandir(path)
			local filtered_results = {} -- create a new table to hold the filtered results
			while handle do
				local name, t = vim.loop.fs_scandir_next(handle)
				if not name then
					break
				end
				local file_path = path .. "/" .. name
				if t == "directory" then -- if the file is a directory
					if name ~= "." and name ~= ".." and name ~= ".git" then -- ignore current and parent directories
						local sub_results = ls(file_path, fn) -- recursively call ls on the subdirectory
						for _, sub_result in ipairs(sub_results) do -- append the subdirectory results to the filtered results table
							table.insert(
								filtered_results,
								name .. "/" .. sub_result
							)
						end
					end
				else -- if the file is not a directory
					if fn(file_path, name, t) then -- if the file matches the search criteria
						table.insert(filtered_results, name) -- append the file path to the filtered results table
					end
				end
			end
			return filtered_results -- return the filtered results table
		end

		local files = ls(opts.path, function(_, name)
			if require("idle.helpers.table").table_has(opts.ignore, name) then
				return false
			end
			return string.find(name, "^" .. query)
				or string.find(_, opts.path .. "/" .. query)
		end)
		local file_names = {}
		for _, file in ipairs(files) do
			table.insert(file_names, remove_file_extension(file, "lua"))
		end
		return file_names
	end
end

M.register_config_command = function(command, opts)
	if not opts or not opts.path then
		vim.print("opts.path is required to register " .. command .. " config")
		return
	end
	local default_ignored_patterns = {
		".DS_Store",
		".git",
		"node_modules",
		"lazy-lock.json",
	}
	local add_command = vim.api.nvim_create_user_command
	add_command(
		normalize_user_command(command),
		M.open_or_find(opts.path, opts.open_vimrc or false),
		{
			desc = opts.desc or ("Browse " .. opts.path),
			nargs = "?",
			bang = true,
			complete = M.complete_files({
				path = opts.path,
				ignore = vim.tbl_deep_extend(
					"force",
					default_ignored_patterns,
					opts.ignore or {}
				),
			}),
		}
	)
end

return M
