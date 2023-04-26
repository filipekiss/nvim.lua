local M = {}

local function file_exists(filepath)
	local stat = vim.loop.fs_stat(filepath)
	return stat and stat.type == "file"
end

M.open_or_find = function(starting_path)
	return function(params)
		local args = params.fargs
		local query = args[1]
		local file_path = starting_path .. "/" .. (query or "non-existingf.ile")
		if file_exists(file_path) then
			vim.api.nvim_command("edit " .. file_path)
			return
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
			return string.find(name, query)
		end)
		return files
	end
end

return M
