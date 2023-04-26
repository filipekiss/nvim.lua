local function checktime()
	if vim.fn.mode() ~= "n" or vim.fn.getcmdwintype() ~= "" then
		return
	end
	vim.api.nvim_command("checktime")
end

return function()
	local augroup = require("idle.helpers.autocmd").augroup
	local autocmd = require("idle.helpers.autocmd").autocmd

	autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
		group = augroup("checktime", { clear = true }),
		pattern = "*",
		callback = checktime,
	})

	autocmd({ "FileChangedShellPost" }, {
		group = augroup("checktime", { clear = false }),
		pattern = "*",
		callback = function()
			local Util = require("idle.util")
			Util.warn("File changed on disk. Buffer reloaded.")
		end,
	})
end
