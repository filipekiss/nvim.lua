-- NEBULA_LOG_LEVEL = "debug"
Nebula = require("nebula")
local plugin = Nebula.plugin
local colorscheme = Nebula.colorscheme

plugin("packer")
plugin("treesitter")
plugin("autopairs")
plugin("autotag")
plugin("comment")
plugin("telescope")
plugin("completion")
plugin("lsp")
plugin("filetype")
plugin("fix-cursor-hold")
plugin("rainbow")
plugin("alpha")
plugin("gitsigns")
plugin("neoscroll")
plugin("which-key")
plugin("indent-line")
plugin("colorizer")
plugin("null-ls")
plugin("toggleterm")
plugin("lualine")
plugin("bufferline")
plugin("devicons")
plugin("trouble")
plugin("todo-comments")
plugin("neo-tree")
plugin("neogen")
plugin("bufdelete")
colorscheme("catppuccin")

Nebula.init({
	colorscheme = "catppuccin",
	display_line_numbers = {
		disabled = { "", "alpha", "gitcommit", "toggleterm" },
		enabled = {},
		enabled_relative = {},
	},
	filter_lsp_servers = { "null-ls" },
})
