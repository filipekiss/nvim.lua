return {
	"https://github.com/folke/neoconf.nvim",
	cmd = "Neoconf",
	opts = {},
	config = function(_, opts)
		require("neoconf").setup(opts)
		pcall(function()
			require("neoconf.plugins").register({
				on_schema = function(schema)
					schema:import("user", {
						lsp = {
							autoformat = true,
						},
					})
				end,
			})
		end)
	end,
}
