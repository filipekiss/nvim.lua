return {
	"https://github.com/williamboman/mason-lspconfig.nvim",
	after = {
		"nvim-lspconfig",
		"mason.nvim",
	},
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local masonlsp = safe_require("mason-lspconfig")
		if not masonlsp then
			return
		end
		masonlsp.setup(Nebula.get_config("masonlsp"))

		masonlsp.setup_handlers({
			function(server_name)
				local opts = {}
				opts.on_attach = require("user.plugins.lsp.handlers").on_attach
				opts.capabilities =
					require("user.plugins.lsp.handlers").capabilitie
				-- check if we have custom configurations for this server
				local table_require =
					require("nebula.helpers.require").table_require
				local server_settings = table_require(
					"user.plugins.lsp.server-settings." .. server_name
				)

				if server_settings then
					opts = vim.tbl_deep_extend("force", opts, server_settings)
				end

				require("lspconfig")[server_name].setup(opts)
			end,
		})
	end,
}
