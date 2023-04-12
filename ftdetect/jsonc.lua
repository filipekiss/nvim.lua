local augroup = require("idle.helpers.autocmd").augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufNewFile", "BufRead" }, {
	group = augroup("jsoncFtDetect"),
	pattern = { ".eslintrc.json", "tsconfig.json", "tsconfig.*.json" },
	callback = function()
		vim.bo.filetype = "jsonc"
	end,
})
