local add_command = vim.api.nvim_create_user_command

add_command("C", "nohlsearch", { desc = "Clear highlight search" })

add_command(
	"ToggleFoldMethod",
	require("user.functions").toggle_fold_method,
	{ desc = "Toggle fold method" }
)

-- I usually misstype these
add_command("W", "w", { desc = "Save current buffer" })
add_command("X", "x", { desc = "Save current buffer and quit neovim" })
add_command("Q", "q", { desc = "Quit" })

-- :Config to edit any file under the nvim config dir
-- If an argument is passed an matches a path exactly, opens the file directly
-- otherwise, opens a Telescope git_files prompt in stdpath("config")
add_command("Config", require("user.functions.config").open_or_find, {
	desc = "Browse $CONFIG files",
	nargs = "?",
	complete = require("user.functions.config").complete_files({
		ignore = {
			".DS_Store",
			".git",
			"node_modules",
			"lazy-lock.json",
		},
	}),
})

local add_config_command =
	require("user.functions.config").register_config_command

add_config_command("Config", {
	path = vim.fn.stdpath("config") .. "/lua/" .. Idle.options.namespace,
	desc = "Browse files in lua/" .. Idle.options.namespace,
	open_vimrc = true,
})

add_config_command("Plugin", {
	path = vim.fn.stdpath("config") .. "/lua/plugins",
	desc = "Browse plugin files",
})

add_command("VSCode", require("user.functions").open_vscode, {
	desc = "Open current file in VSCode",
	nargs = "?",
	complete = function()
		return { "file", "project" }
	end,
})

add_command("Git", function(params)
	local cwd = params.bang and vim.loop.cwd()
		or require("user.functions.rooter").get_project_dir().path
	require("user.functions").float_term({ "lazygit" }, {
		cwd = cwd,
		esc_esc = false,
	})
end, { desc = "Open Lazygit", bang = true })

add_command("Term", function(params)
	local cwd = params.bang and vim.loop.cwd()
		or require("user.functions.rooter").get_project_dir().path
	require("user.functions.terminal").float(nil, {
		cwd = cwd,
		esc_esc = false,
		border = "single",
	})
end, { desc = "Open Terminal", bang = true })
