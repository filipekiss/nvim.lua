local functions = Idle.load("functions")
local rooter = Idle.load("functions.rooter")
local augroup = require("idle.helpers.autocmd").augroup
local autocmd = vim.api.nvim_create_autocmd
local check_file_changed = require("user.functions.checktime")

check_file_changed()

autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

autocmd({ "VimResized" }, {
	desc = "resize splits if window got resized",
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

autocmd("BufReadPost", {
	desc = "go to last loc when opening a buffer",
	group = augroup("last_loc"),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

autocmd("FileType", {
	desc = "close some filetypes with <q>",
	group = augroup("close_with_q"),
	pattern = {
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"startuptime",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set(
			"n",
			"q",
			"<cmd>close<cr>",
			{ buffer = event.buf, silent = true }
		)
	end,
})

autocmd("FileType", {
	desc = "wrap and check for spell in text filetypes",
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

autocmd({ "InsertLeave", "BufAdd", "BufEnter", "InsertEnter" }, {
	desc = "smart line numbers",
	group = augroup("relative_number"),
	callback = function(opts)
		if not functions then
			return
		end
		if opts.event == "InsertEnter" then
			functions.display_line_numbers("i")
		else
			functions.display_line_numbers("n")
		end
	end,
})

autocmd({ "VimEnter", "BufReadPost", "BufEnter" }, {
	desc = "set project directory",
	group = augroup("project_dir"),
	pattern = { "*" },
	callback = function()
		if not rooter then
			return
		end
		rooter.set_project_dir()
	end,
})

autocmd({ "BufWritePre", "FileWritePre" }, {
	desc = "create missing folders when writing a file",
	group = augroup("create_missing_folder"),
	pattern = { "*" },
	command = "call mkdir(expand('<afile>:p:h'), 'p')",
})
