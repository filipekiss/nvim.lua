return {
	"https://github.com/antoinemadec/FixCursorHold.nvim",
	config = function()
		vim.g.cursorshold_updatetime = 100
	end,
	event = { "BufRead", "BufNewFile" },
}
