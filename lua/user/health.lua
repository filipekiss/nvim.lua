local M = {}

local start = vim.health.report_start
local ok = vim.health.report_ok
local error = vim.health.report_error
local warn = vim.health.report_warn

local function check_lazy_version(current, minimum)
	local Semver = require("lazy.manage.semver")
	return Semver.range(minimum):matches(current)
end

function M.check()
	start("Purrpleditor")

	if vim.fn.has("nvim-0.8.0") == 1 then
		ok("Using `Neovim` >= 0.8.0")
	else
		error("`Neovim` >= 0.8.0 is required")
	end

	local has_idle = pcall(require, "idle")

	if not has_idle then
		error("idle.nvim is required")
	else
		ok("`idle.nvim` installed ✔︎")
	end

	for _, cmd in ipairs({ "git", "rg", { "fd", "fdfind" }, "lazygit" }) do
		local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
		local commands = type(cmd) == "string" and { cmd } or cmd
		---@cast commands string[]
		local found = false

		for _, c in ipairs(commands) do
			if vim.fn.executable(c) == 1 then
				name = c
				found = true
			end
		end

		if found then
			ok(("`%s` is installed"):format(name))
		else
			warn(("`%s` is not installed"):format(name))
		end
	end
end

return M
