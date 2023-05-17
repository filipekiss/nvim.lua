return {
	"https://github.com/nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	dependencies = {
		{ "nui.nvim" },
	},
	keys = {
		{
			"<leader>fe",
			function()
				require("neo-tree.command").execute({
					toggle = true,
					dir = require("user.functions.rooter").get_project_dir().path,
				})
			end,
			desc = "Explorer NeoTree (root dir)",
		},
		{
			"<leader>fE",
			function()
				require("neo-tree.command").execute({
					toggle = true,
					dir = vim.loop.cwd(),
				})
			end,
			desc = "Explorer NeoTree (cwd)",
		},
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		vim.g.neo_tree_remove_legacy_commands = 1
		if vim.fn.argc() == 1 then
			---@diagnostic disable-next-line param-type-mismatch
			local stat = vim.loop.fs_stat(vim.fn.argv(0))
			if stat and stat.type == "directory" then
				require("neo-tree")
			end
		end
	end,
	opts = {
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = true,
			use_libuv_file_watcher = true,
		},
		window = {
			mappings = {
				["<space>"] = "none",
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
		},
		event_handlers = {
			{
				event = "file_opened",
				handler = function(_)
					require("neo-tree").close_all()
				end,
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
		vim.api.nvim_create_autocmd("TermClose", {
			pattern = "*lazygit",
			callback = function()
				if package.loaded["neo-tree.sources.git_status"] then
					require("neo-tree.sources.git_status").refresh()
				end
			end,
		})
	end,
}
