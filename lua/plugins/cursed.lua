return {
	"https://github.com/filipekiss/cursed.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		delay = 500,
		smart_cursorline = true,
	},
}
