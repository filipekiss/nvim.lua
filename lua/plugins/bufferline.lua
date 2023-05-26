return {
	"https://github.com/akinsho/bufferline.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>bs",
			"<Cmd>BufferLineTogglePin<CR>",
			desc = "Toggle sticky buffer",
		},
		{
			"<leader>bS",
			"<Cmd>BufferLineGroupClose ungrouped<CR>",
			desc = "Delete non-sticky buffers",
		},
	},
	opts = {
		options = {
			close_command = function(n)
				require("mini.bufremove").delete(n, false)
			end,
			right_mouse_command = function(n)
				require("mini.bufremove").delete(n, false)
			end,
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			diagnostics_indicator = function(_, _, diag)
				local icons = require("idle.config").icons.diagnostics
				local ret = (
						diag.error and icons.Error .. diag.error .. " " or ""
					)
					.. (diag.warning and icons.Warn .. diag.warning or "")
				return vim.trim(ret)
			end,
			offsets = {
				{
					filetype = "neo-tree",
					text = "Neo-tree",
					highlight = "Directory",
					text_align = "left",
				},
			},
		},
	},
}
