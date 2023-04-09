local M = {}

function M.display_line_numbers(mode)
	local filetype = vim.bo.filetype
	if vim.tbl_contains(Idle.options.nonumber or {}, filetype) then
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
		return
	end
	if vim.tbl_contains(Idle.options.number or {}, filetype) then
		vim.opt_local.relativenumber = false
		vim.opt_local.number = true
		return
	end
	if vim.tbl_contains(Idle.options.relativenumber or {}, filetype) then
		vim.opt_local.relativenumber = true
		vim.opt_local.number = true
		return
	end
	if mode == "i" then
		vim.opt_local.relativenumber = false
		vim.opt_local.number = true
		return
	end
	vim.opt_local.relativenumber = true
	vim.opt_local.number = true
end

function M.toggle_fold_method()
	local foldmethod = vim.wo.foldmethod
	local is_marker_toggle = foldmethod == "marker"
	local Util = require("idle.util")
	if is_marker_toggle then
		vim.wo.foldmethod = vim.b.previous_fold_method
		Util.info(
			"Fold method set to "
				.. vim.b.previous_fold_method
				.. " (was marker)"
		)
		return
	end
	vim.b.previous_fold_method = foldmethod
	vim.wo.foldmethod = "marker"
	Util.info(
		"Fold method set to "
			.. vim.wo.foldmethod
			.. " (was "
			.. foldmethod
			.. ")"
	)
end

return M
