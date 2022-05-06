return {
	"https://github.com/danymat/neogen",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local neogen = safe_require("neogen")

		if not neogen then
			return
		end

		local nnoremap = require("nebula.helpers.mappings").nnoremap

		nnoremap("<leader>dg", "<cmd>lua require('neogen').generate()<CR>")

		neogen.setup(Nebula.get_config("neogen"))
	end,
}
