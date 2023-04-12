return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<Tab>", desc = "Increment selection" },
			{ "<S-Tab>", desc = "Decrement selection", mode = "x" },
		},
		opts = {
			highlight = { enable = true },
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
}
