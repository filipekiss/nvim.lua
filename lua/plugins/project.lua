return {
	{
		"telescope.nvim",
		dependencies = {
			-- project management
			{
				"https://github.com/ahmedkhalf/project.nvim",
				opts = {},
				event = "VeryLazy",
				config = function(_, opts)
					require("project_nvim").setup(opts)
					require("telescope").load_extension("projects")
				end,
				keys = {
					{
						"<leader>fp",
						"<Cmd>Telescope projects<CR>",
						desc = "Projects",
					},
				},
			},
		},
	},
	{
		"mini.starter",
		optional = true,
		opts = {

			items = {
				{
					name = "Projects",
					action = "Telescope projects",
					section = string.rep(" ", 22) .. "Telescope",
				},
			},
		},
	},
}
