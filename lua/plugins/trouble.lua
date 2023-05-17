return {
	"https://github.com/folke/trouble.nvim",
	cmd = { "TroubleToggle", "Trouble" },
	opts = {
		use_diagnostic_signs = true,
		icons = false,
		action_keys = {
			jump = {},
			jump_close = { "<cr>" },
		},
	},
	keys = {
		{
			"<leader>xx",
			"<cmd>TroubleToggle document_diagnostics<cr>",
			desc = "[Trouble] Document Diagnostics",
		},
		{
			"<leader>xX",
			"<cmd>TroubleToggle workspace_diagnostics<cr>",
			desc = "[Trouble] Workspace Diagnostics",
		},
		{
			"<leader>xL",
			"<cmd>TroubleToggle loclist<cr>",
			desc = "[Trouble] Location List",
		},
		{
			"<leader>xQ",
			"<cmd>TroubleToggle quickfix<cr>",
			desc = "[Trouble] Quickfix List",
		},
		{
			"[q",
			function()
				if require("trouble").is_open() then
					require("trouble").previous({
						skip_groups = true,
						jump = true,
					})
				else
					vim.cmd.cprev()
				end
			end,
			desc = "Previous trouble/quickfix item",
		},
		{
			"]q",
			function()
				if require("trouble").is_open() then
					require("trouble").next({
						skip_groups = true,
						jump = true,
					})
				else
					vim.cmd.cnext()
				end
			end,
			desc = "Next trouble/quickfix item",
		},
	},
}
