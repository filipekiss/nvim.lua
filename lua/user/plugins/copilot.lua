return {
	"https://github.com/zbirenbaum/copilot.lua",
	event = "InsertEnter",
	config = function()
		vim.schedule(function()
			require("copilot").setup()
		end, 100)
	end,
}
