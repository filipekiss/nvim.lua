local rooter = require("user.functions.rooter")

return function(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts or {}
		local cwd = opts.cwd or rooter.get_project_dir()
		opts = vim.tbl_deep_extend(
			"force",
			{ cwd = cwd and cwd.path },
			opts or {}
		)
		if builtin == "files" then
			if cwd and cwd.is_git then
				opts.show_untracked = true
				builtin = "git_files"
			else
				builtin = "find_files"
			end
		end
		require("telescope.builtin")[builtin](opts)
	end
end
