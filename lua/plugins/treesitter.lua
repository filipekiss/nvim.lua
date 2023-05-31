return {
	{
		"https://github.com/nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		dependencies = {
			{
				"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- PERF: no need to load the plugin, if we only need its queries for mini.ai
					local plugin =
						require("lazy.core.config").spec.plugins["nvim-treesitter"]
					local opts = require("lazy.core.plugin").values(
						plugin,
						"opts",
						false
					)
					local enabled = false
					if opts.textobjects then
						for _, mod in ipairs({
							"move",
							"select",
							"swap",
							"lsp_interop",
						}) do
							if
								opts.textobjects[mod]
								and opts.textobjects[mod].enable
							then
								enabled = true
								break
							end
						end
					end
					if not enabled then
						require("lazy.core.loader").disable_rtp_plugin(
							"nvim-treesitter-textobjects"
						)
					end
				end,
			},
		},
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<Tab>", desc = "Increment selection" },
			{ "<S-Tab>", desc = "Decrement selection", mode = "x" },
		},
		opts = {
			highlight = {
				enable = true,
			},
			indent = { enable = true },
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					node_incremental = "<TAB>",
					scope_incremental = "<CR>",
					node_decremental = "<S-TAB>",
				},
			},
			ensure_installed = {
				"bash",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
			},
		},
		config = function(_, opts)
			local options = vim.tbl_deep_extend(
				"force",
				opts,
				Idle.options.treesitter or {}
			)
			require("nvim-treesitter.configs").setup(options)
			-- use treesitter for folding
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
		end,
	},
	{
		"https://github.com/nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
		dependencies = "nvim-treesitter",
		config = function(_, opts)
			require("nvim-treesitter.configs").setup({
				playgroung = opts,
			})
		end,
		opts = {
			enable = true,
		},
	},
}
