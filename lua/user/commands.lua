local add_command = vim.api.nvim_create_user_command

add_command("C", "nohlsearch", { desc = "Clear highlight search" })

add_command(
	"ToggleFoldMethod",
	require("user.functions").toggle_fold_method,
	{ desc = "Toggle fold method" }
)
