local Util = require("idle.util")
local buffer_table = require("idle.helpers.table").buffer_table
local M = {}

local LspBuffer = buffer_table({
	autoformat = "autoformat",
})

---Toggle autoformat on or off
---@param next_autoformat? boolean If true, enable autoformat. If false, disable it. If nil, toggle
function M.set_autoformat(next_autoformat)
	local current_autoformat = LspBuffer.autoformat
	if next_autoformat == true then
		current_autoformat = false
	elseif next_autoformat == false then
		current_autoformat = true
	end
	if current_autoformat == nil or current_autoformat == true then
		LspBuffer.autoformat = false
		Util.warn("Disabled format on save", { title = "Format" })
	else
		LspBuffer.autoformat = true
		Util.info("Enabled format on save", { title = "Format" })
	end
end

---Format the current file using LSP
---@param force boolean If true, will run format even if autoformat is disabled
function M.format(force)
	if LspBuffer.autoformat == false and force ~= true then
		return
	end
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.bo[buf].filetype
	local have_nls = #require("null-ls.sources").get_available(
		ft,
		"NULL_LS_FORMATTING"
	) > 0

	vim.lsp.buf.format(vim.tbl_deep_extend("force", {
		async = false,
		bufnr = buf,
		filter = function(client)
			if have_nls then
				return client.name == "null-ls"
			end
			return client.name ~= "null-ls"
		end,
	}, {}))
	if force then
		Util.info("File formatted", { title = "LSP" })
	end
end

function M.on_attach(client, buf)
	-- dont format if client disabled it
	if
		client.config
		and client.config.capabilities
		and client.config.capabilities.documentFormattingProvider == false
	then
		return
	end

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
			buffer = buf,
			callback = function()
				M.format(false)
			end,
		})
	end

	local create_commands =
		require("idle.helpers.command").create_commands_from_spec_list
	---@type IdleCommandSpecList
	local commands = {
		Format = {
			command = function()
				M.format(true)
			end,
			desc = "[LSP] Format current file",
		},
		FormatToggle = {
			command = function()
				M.set_autoformat()
			end,
			desc = "[LSP] Toggle autoformat for current buffer",
		},
	}
	local format_commands_state = {
		On = true,
		Off = false,
	}
	for state, value in pairs(format_commands_state) do
		commands["Format" .. state] = {
			command = function()
				M.set_autoformat(value)
			end,
			desc = "[LSP] Turn autoformat " .. string.lower(state),
		}
	end
	create_commands(commands)
end

return M
