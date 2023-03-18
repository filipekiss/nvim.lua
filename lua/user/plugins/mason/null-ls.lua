return {
	"https://github.com/jay-babu/mason-null-ls.nvim",
	after = "mason.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local mason_nullls = safe_require("mason-null-ls")
		if not mason_nullls then
			return
		end
		mason_nullls.setup(Nebula.get_config("mason_nullls"))

		mason_nullls.setup_handlers({
			function(source_name, methods)
				require("mason-null-ls.automatic_setup")(source_name, methods)
			end,
		})
	end,
}
