local plugin = require("nebula.helpers.plugins").plugin

return {
	"https://github.com/neovim/nvim-lspconfig",
	requires = {
		plugin("lsp.installer"),
		"https://github.com/b0o/schemastore.nvim", -- to use schemas from schemastore.org
	},
	config = function()
		local lsp_config = Nebula.get_config("lsp")

		for _, sign in ipairs(lsp_config.signs) do
			vim.fn.sign_define(
				sign.name,
				{ texthl = sign.name, text = sign.text, numhl = "" }
			)
		end

		vim.diagnostic.config(lsp_config.config)
	end,
}
