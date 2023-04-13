local Util = require("idle.util")
local M = {}

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
	local current_folder = vim.fn.expand("%:p:h")
	if filename == ".git" then
		return get_git_dir(current_folder)
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

local function table_has(haystack, needle)
	for _, value in ipairs(haystack) do
		if value == needle then
			return true
		end
	end
	return false
end

local buffer_table = require("idle.helpers.table").buffer_table

local Rooter = buffer_table({
	root_dir = "rooter_dir",
	excluded = "rooter_excluded",
})

function M.set_project_dir()
	local change_root = vim.api.nvim_set_current_dir
	local excluded_filetypes = Idle.options.rooter
			and Idle.options.rooter.exclude
		or { "" }
	local is_excluded_filetype = table_has(excluded_filetypes, vim.bo.filetype)
	-- if we already excluded this buffer, just skip
	if Rooter.excluded then
		return
	end
	-- if we are excluding the buffer for the first time, add the variable and
	-- then skip
	if is_excluded_filetype then
		Rooter.excluded = true
		return
	end
	-- if we already set it for this buffer, use the set value
	if Rooter.root_dir then
		change_root(Rooter.root_dir)
		return
	end

	-- this is the first time we are here, let's update the root dir
	Rooter.root_dir = get_project_dir()
	if Rooter.root_dir then
		change_root(Rooter.root_dir)
		Util.info(Rooter.root_dir, { title = "rooter" })
	end
end

return M
