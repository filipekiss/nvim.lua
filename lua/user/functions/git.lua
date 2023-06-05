local M = {}

function M.is_git_repo(path)
	return vim.loop.fs_stat((path or vim.loop.cwd()) .. "/.git")
end

function M.get_git_dir(path)
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

return M
