local Idle = require("idle")
local M = {}
local current_lcd = vim.fn.getcwd()

local function get_git_dir(path)
	local git_dir = vim.fn.system(
		"cd "
			.. path
			.. ' && git rev-parse --show-toplevel 2> /dev/null || echo ""'
	)
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
	-- TODO: replace this with lua stat api instead of vim filereadable
	local file_exists = vim.fn.filereadable(starting_path .. "/" .. filename)
	if file_exists == 1 then
		-- found the file we were looking for, return the path to the folder where it was
		return starting_path
	end
	-- if we didn't find the file, recursively search one folder up until we exhaust
	-- the options
	return find_file_in(
		filename,
		vim.fn.fnamemodify(starting_path, ":h"),
		search_until
	)
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
	local project_roots = vim.tbl_extend(
		"force",
		default_project_roots_files,
		user_project_roots or {}
	)
	for _, file in pairs(project_roots) do
		local result = find_file_in(file, starting_dir)
		if result then
			return result
		end
	end
end

function M.set_project_dir()
	local current_folder = vim.fn.expand("%:p:h")
	local project_dir = get_project_dir(current_folder)
	if project_dir and project_dir ~= current_lcd then
		-- change vim directory to the found project folder
		vim.fn.chdir(project_dir)
		current_lcd = project_dir
		local Util = require("idle.util")
		Util.info("Changed project folder to " .. project_dir)
		return
	end
end

function M.display_line_numbers(mode)
	local filetype = vim.bo.filetype
	if vim.tbl_contains(Idle.options.nonumber or {}, filetype) then
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
		return
	end
	if vim.tbl_contains(Idle.options.number or {}, filetype) then
		vim.opt_local.relativenumber = false
		vim.opt_local.number = true
		return
	end
	if vim.tbl_contains(Idle.options.relativenumber or {}, filetype) then
		vim.opt_local.relativenumber = true
		vim.opt_local.number = true
		return
	end
	if mode == "i" then
		vim.opt_local.relativenumber = false
		vim.opt_local.number = true
		return
	end
	vim.opt_local.relativenumber = true
	vim.opt_local.number = true
end

function M.toggle_fold_method()
	local foldmethod = vim.wo.foldmethod
	local is_marker_toggle = foldmethod == "marker"
	local Util = require("idle.util")
	if is_marker_toggle then
		vim.wo.foldmethod = vim.b.previous_fold_method
		Util.info(
			"Fold method set to "
				.. vim.b.previous_fold_method
				.. " (was marker)"
		)
		return
	end
	vim.b.previous_fold_method = foldmethod
	vim.wo.foldmethod = "marker"
	Util.info(
		"Fold method set to "
			.. vim.wo.foldmethod
			.. " (was "
			.. foldmethod
			.. ")"
	)
end

return M
