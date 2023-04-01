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

local function find_root_folder(filename)
	if filename == ".git" then
		return get_git_dir(vim.fn.fnamemodify(filename, ":h"))
	end
	local found = vim.fn.findfile(
		filename,
		vim.fn.expand("%:p") .. ";" .. vim.fn.getenv("HOME")
	)
	if found ~= "" then
		return vim.fn.fnamemodify(found, ":p:h")
	end
	return nil
end

local function get_project_dir()
	local default_project_root_files = {
		"package.json",
		"nx.json",
		".git",
	}
	local project_root_files = _.TableConcat(
		vim.g.project_root_files or {},
		default_project_root_files
	)
	for _, file in pairs(project_root_files) do
		local result = find_root_folder(file)
		if result then
			return result
		end
	end
end

function M.set_project_dir()
	local project_dir = get_project_dir()
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
