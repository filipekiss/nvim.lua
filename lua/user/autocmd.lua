local augroup = require("nebula.helpers.autocmd").augroup

augroup("NebulaProjectRoot", {
	{
		events = { "BufAdd", "BufEnter" },
		targets = { "*" },
		command = 'lua require("user.functions").set_project_dir()',
	},
})

augroup("NebulaRelativeNumber", {
	{
		events = { "InsertLeave", "BufAdd", "BufEnter" },
		targets = { "*" },
		command = 'lua require("user.functions").display_line_numbers("n")',
	},
	{

		events = { "InsertEnter" },
		targets = { "*" },
		command = 'lua require("user.functions").display_line_numbers("i")',
	},
})

augroup("NebulaGitCommitInsert", {
	{
		events = { "FileType" },
		targets = { "gitcommit" },
		command = "startinsert",
	},
}, {
	buffer = true,
})

augroup("CreateMissingFolder", {
	{
		events = { "BufWritePre", "FileWritePre" },
		targets = { "*" },
		modifiers = { "silent!" },
		command = "call mkdir(expand('<afile>:p:h'), 'p')",
	},
})
