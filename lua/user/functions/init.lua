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

-- taken from LazyVim - https://github.com/LazyVim/LazyVim/blob/5d6f0d58d5daf2f87ea9f0a49170103925d1b528/lua/lazyvim/util/init.lua#L154
function M.lazy_notify()
	local notifs = {}
	local function temp(...)
		table.insert(notifs, vim.F.pack_len(...))
	end

	local orig = vim.notify
	vim.notify = temp

	local timer = vim.loop.new_timer()
	local check = vim.loop.new_check()

	local replay = function()
		---@diagnostic disable-next-line: need-check-nil
		timer:stop()
		---@diagnostic disable-next-line: need-check-nil
		check:stop()
		if vim.notify == temp then
			vim.notify = orig -- put back the original notify if needed
		end
		vim.schedule(function()
			---@diagnostic disable-next-line: no-unknown
			for _, notif in ipairs(notifs) do
				vim.notify(vim.F.unpack_len(notif))
			end
		end)
	end

	-- wait till vim.notify has been replaced
	---@diagnostic disable-next-line: need-check-nil
	check:start(function()
		if vim.notify ~= temp then
			replay()
		end
	end)
	-- or if it took more than 500ms, then something went wrong
	---@diagnostic disable-next-line: need-check-nil
	timer:start(500, 0, replay)
end

---@class HighlightGroup
---@field fg string # The fg color
---@field bg string # The bg color
---@field ctermfg string # fg color for cterm
---@field ctermbg string # bg color for cterm

---@param name string # The highlight group name you want the colors for
---@param fallback? HighlightGroup
---@return HighlightGroup | {} # A Table with the fg and bg colors for the highlight group or the fallback group if it's not found
function M.get_hlgroup(name, fallback)
	if vim.fn.hlexists(name) == 1 then
		local hl
		---@diagnostic disable: undefined-field
		if vim.api.nvim_get_hl then -- check for new neovim 0.9 API
			hl = vim.api.nvim_get_hl(0, { name = name, link = false })
			---@diagnostic enable: undefined-field
			if not hl.fg then
				hl.fg = "NONE"
			end
			if not hl.bg then
				hl.bg = "NONE"
			end
		else
			---@diagnostic disable-next-line undefined-field
			hl = vim.api.nvim_get_hl_by_name(name, vim.o.termguicolors)
			if not hl.foreground then
				hl.foreground = "NONE"
			end
			if not hl.background then
				hl.background = "NONE"
			end
			hl.fg, hl.bg = hl.foreground, hl.background
			hl.ctermfg, hl.ctermbg = hl.fg, hl.bg
			hl.sp = hl.special
		end
		return hl
	end
	return fallback or {}
end

function M.fg(name)
	local group = M.get_hlgroup(name)
	local fg = group.fg or group.ctermfg
	return fg and { fg = string.format("#%06x", fg) }
end

function M.bg(name)
	local group = M.get_hlgroup(name)
	local bg = group.bg or group.ctermbg
	return bg and { bg = string.format("#%06x", bg) }
end

function M.open_vscode(params)
	local args = params.fargs
	local file_or_project = args[1] == "file" and "file" or "project"
	local open_this = vim.fn.expand(
		file_or_project == "file" and "%:p" or "%:p:h"
	)
	vim.fn.system("code " .. open_this)
end

function M.float_term(cmd, opts)
	opts = vim.tbl_deep_extend("force", {
		size = { width = 0.9, height = 0.9 },
	}, opts or {})
	local float = require("lazy.util").float_term(cmd, opts)
	if opts.esc_esc == false then
		vim.keymap.set(
			"t",
			"<esc>",
			"<esc>",
			{ buffer = float.buf, nowait = true }
		)
	end
end

---Use this function to add a depency to any plugin that will modify the
---sections available in whichkey.nvim
---
---Example (options ommited for brevity):
---```lua
-- return {
-- 	"https://github.com/folke/persistence.nvim",
-- 	dependencies = {
-- 		add_to_whichkey("persistence.nvim", {
-- 			["<leader>q"] = { name = "+session" },
-- 		}),
-- 	}
-- }
---```
---@param plugin_name string
---@param sections table<string, table<string, string>>
---@return table
function M.add_to_whichkey(plugin_name, sections)
	return {
		"which-key.nvim",
		opts = function(_, opts)
			if Idle.has_plugin(plugin_name) then
				return vim.tbl_deep_extend("force", opts, {
					defaults = sections,
				})
			end
		end,
	}
end

return M
