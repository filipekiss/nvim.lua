return {
	"https://github.com/kkoomen/vim-doge",
	run = "npm i --no-save && npm run build:binary:unix",
	config = function()
		vim.g.doge_enable_mappings = true
		vim.g.doge_mapping = "<Leader>dg"
		vim.g.doge_mapping_comment_jump_forward = "<C-n>"
		vim.g.doge_mapping_comment_jump_backward = "<C-p>"
	end,
}
