return {
	"https://github.com/famiu/bufdelete.nvim",
	cmd = { "Bdelete", "Bwipeout" },
	keys = "<leader>c",
	config = function()
		local nnoremap = require("nebula.helpers.mappings").nnoremap
		nnoremap("<leader>cc", "<cmd>Bdelete<CR>")
		nnoremap("<leader>q", "<cmd>Bdelete!<CR>")
	end,
}
