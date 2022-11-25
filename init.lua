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
plugin("aerial")
plugin("ufo")
plugin("firenvim")
plugin("winbar")
plugin("sandwich")
plugin("abolish")
plugin("doge")
plugin("copilot")
plugin("lsp_signature")
plugin("unception")
plugin("fidget")
colorscheme("spaceduck")

Nebula.init({
	colorscheme = "spaceduck",
	display_line_numbers = {
		disabled = { "", "alpha", "gitcommit", "toggleterm" },
		enabled = {},
		enabled_relative = {},
	},
	enable_nebula_commands = true,
	filter_lsp_servers = { "null-ls" },
})
