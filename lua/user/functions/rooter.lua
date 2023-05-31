local Util = require("idle.util")
local M = {}

local get_git_dir = require("user.functions.git").get_git_dir

local function find_root_folder(filename)
	local current_folder = vim.fn.expand("%:p:h")
	if filename == ".git" then
		local git_dir = get_git_dir(current_folder)
		if git_dir then
			return {
				path = git_dir,
				is_git = true,
			}
		end
		return {
			path = current_folder,
			is_git = false,
		}
	end
	local found = vim.fn.findfile(
		filename,
		vim.fn.expand("%:p") .. ";" .. vim.fn.getenv("HOME")
	)
	if found ~= "" then
		return { path = vim.fn.fnamemodify(found, ":p:h"), is_git = false }
	end
	return nil
end

local function is_valid_path(path)
	return path:find("^/")
end

function M.get_project_dir()
	for _, pattern in pairs(Idle.options.rooter.root_pattern) do
		local result = find_root_folder(pattern)
		if result and result.path and is_valid_path(result.path) then
			return result
		end
	end
	return nil
end

local table_has = require("idle.helpers.table").table_has

local buffer_table = require("idle.helpers.table").buffer_table
local window_table = require("idle.helpers.table").window_table

local RooterBuffer = buffer_table({
	current_root = "rooter_current_root",
	excluded = "rooter_buffer_excluded",
	notify_once = "rooter_notify_once",
})

local RooterWindow = window_table({
	previous_root = "rooter_previous_root",
})

local function notify_if_changed(previous, current)
	if
		previous ~= current
		and Idle.options.rooter.silent ~= true
		and RooterBuffer.notify_once ~= true
	then
		Util.info(current, { title = "rooter" })
		if Idle.options.rooter.notify_once then
			RooterBuffer.notify_once = true
		end
	end
end

function M.set_project_dir()
	local change_root = vim.api.nvim_set_current_dir
	local excluded_filetypes = Idle.options.rooter.exclude or { "" }
	local is_excluded_filetype = table_has(excluded_filetypes, vim.bo.filetype)
	-- if we already excluded this buffer, just skip
	if RooterBuffer.excluded then
		return
	end
	-- if we are excluding the buffer for the first time, add the variable and
	-- then skip
	if is_excluded_filetype then
		RooterBuffer.excluded = true
		return
	end
	-- if we already set it for this buffer, use the set value
	if RooterBuffer.current_root then
		change_root(RooterBuffer.current_root)
		notify_if_changed(RooterWindow.previous_root, RooterBuffer.current_root)
		if RooterWindow.previous_root ~= RooterBuffer.current_root then
			RooterWindow.previous_root = RooterBuffer.current_root
		end
		return
	end

	-- this is the first time we are here, let's update the root dir
	local project_dir = M.get_project_dir()
	if project_dir then
		RooterBuffer.current_root = project_dir.path
		if RooterBuffer.current_root then
			change_root(RooterBuffer.current_root)
			notify_if_changed(
				RooterWindow.previous_root,
				RooterBuffer.current_root
			)
			if RooterWindow.previous_root ~= RooterBuffer.current_root then
				RooterWindow.previous_root = RooterBuffer.current_root
			end
		end
	end
end

return M
