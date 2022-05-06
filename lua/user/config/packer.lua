return {
	display = {
		open_fn = function()
			-- configure packer to use a floating window
			return require("packer.util").float({ border = "rounded" })
		end,
	},
}
