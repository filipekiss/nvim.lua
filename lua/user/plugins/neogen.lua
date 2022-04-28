return {
	"https://github.com/danymat/neogen",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local get_config = require("nebula.helpers.require").get_user_config
		local neogen = safe_require("neogen")

		if not neogen then
			return
		end

		local nnoremap = require("nebula.helpers.mappings").nnoremap

		nnoremap("<leader>ng", "<cmd>lua require('neogen').generate()<CR>")

		neogen.setup(get_config("neogen"))
	end,
}
