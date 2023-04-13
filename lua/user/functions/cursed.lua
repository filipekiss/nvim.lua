local M = {}
local IDLE = "IDLE"
local MOVING = "MOVING"
M.timer_id = nil

local function run_user_autocmd(pattern, opts)
	opts.pattern = pattern
	return vim.api.nvim_exec_autocmds("User", opts)
end

local buffer_table = require("idle.helpers.table").buffer_table

local Cursed = buffer_table({
	is_ex_mode = "cursed_ex_mode",
	disabled = "cursed_disabled",
	status = "cursed_cursor_status",
})

local function should_activate(status)
	-- if the cursed is disabled for the current buffer
	if Cursed.disabled == true then
		return false
	end

	-- if this is an ex cmd buffer
	if Cursed.is_ex_mode then
		return false
	end

	-- check against the current status
	if status ~= nil and Cursed.status ~= nil then
		-- if status match, activate
		if Cursed.status == status then
			return true
		else
			-- otherwise, don't
			return false
		end
	end

	-- otherwise always activate
	return true
end

local function cursed_callback()
	if not should_activate(MOVING) then
		return
	end
	run_user_autocmd("CursedStop", { modeline = false })
	Cursed.status = IDLE
	M.timer:stop()
	M.timer = nil
end

local function cursor_moved(delay)
	if not should_activate() then
		return
	end

	if M.timer then
		M.timer:stop()
		M.timer:close()
	end

	M.timer = vim.loop.new_timer()
	M.timer:start(delay, delay, vim.schedule_wrap(cursed_callback))
	if should_activate(IDLE) then
		run_user_autocmd("CursedStart", { modeline = false })
		Cursed.status = MOVING
	end
end

function M.setup()
	if vim.g.cursed_loaded then
		return
	end
	vim.g.cursed_loaded = true
	local cursed_delay = Idle.options.cursed and Idle.options.cursed.delay
		or vim.o.updatetime
	local augroup = require("idle.helpers.autocmd").augroup
	local autocmd = vim.api.nvim_create_autocmd

	autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = augroup("cursed"),
		pattern = { "*" },
		callback = function()
			cursor_moved(cursed_delay)
		end,
	})

	autocmd({ "CmdWinEnter", "CmdWinLeave" }, {
		group = augroup("cursed_cmdmode"),
		pattern = { "*" },
		callback = function(opts)
			if opts.event == "CmdWinEnter" then
				Cursed.is_ex_mode = true
			else
				Cursed.is_ex_mode = false
			end
		end,
	})
end

function M.setup_smart_cursorline()
	M.setup()
	local autocmd = vim.api.nvim_create_autocmd

	-- enable cursorline when moving windows
	autocmd({ "WinEnter" }, {
		pattern = "*",
		callback = function()
			if should_activate() then
				vim.wo.cursorline = true
			end
		end,
	})

	-- setup the smart cursorline events
	autocmd("User", {
		pattern = "CursedStart",
		callback = function()
			vim.wo.cursorline = false
		end,
	})

	autocmd("User", {
		pattern = "CursedStop",
		callback = function()
			vim.wo.cursorline = true
		end,
	})
end

return M
