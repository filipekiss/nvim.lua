local Util = require("idle.util")
local yesno = require("user.functions.yesno")
local buffer_table = require("idle.helpers.table").buffer_table
local global_table = require("idle.helpers.table").global_table
local M = {}

local LspBuffer = buffer_table({
	autoformat = "autoformat",
})

local LspGlobal = global_table({
	autoformat = "autoformat",
})

---Toggle autoformat on or off
---@param next_autoformat? boolean If true, enable autoformat. If false, disable it. If nil, toggle
---@param global? boolean If true, toggle the option globally instead of locally
function M.set_autoformat(next_autoformat, global)
	global = global ~= false and global ~= nil
	local current_autoformat = global and LspGlobal.autoformat
		or LspBuffer.autoformat
	if next_autoformat == true then
		current_autoformat = false
	elseif next_autoformat == false then
		current_autoformat = true
	end
	if current_autoformat == nil or current_autoformat == true then
		if global then
			LspGlobal.autoformat = false
		else
			LspBuffer.autoformat = false
		end
		Util.warn(
			"Disabled format on save "
				.. yesno("globally", "for the current buffer", global),
			{ title = "Format" }
		)
	else
		if global then
			LspGlobal.autoformat = true
		else
			LspBuffer.autoformat = true
		end
		Util.info(
			"Enabled format on save "
				.. yesno("globally", "for the current buffer", global),
			{ title = "Format" }
		)
	end
end

---Format the current file using LSP
---@param force boolean If true, will run format even if autoformat is disabled
function M.format(force)
	if
		(LspBuffer.autoformat == false or LspGlobal.autoformat == false)
		and force ~= true
	then
		return
	end
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.bo[buf].filetype
	local have_nls = package.loaded["null-ls"]
		and (
			#require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING")
			> 0
		)

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
				M.set_autoformat(nil, true)
			end,
			desc = "[LSP] Toggle autoformat globally",
		},
		FormatToggleBuffer = {
			command = function()
				M.set_autoformat()
			end,
			desc = "[LSP] Toggle autoformat for current buffer",
		},
		FormatStatus = {
			command = function()
				local project_autoformat_status = nil
				pcall(function()
					project_autoformat_status = require("neoconf").get(
						"user.lsp.autoformat"
					)
					if project_autoformat_status ~= nil then
						Util.info({
							string.format(
								"Auto format is **%s** for the project. Other settings ignored.",
								yesno(
									"enabled",
									"disabled",
									project_autoformat_status
								)
							),
						}, { title = "LSP Autoformat" })
						return
					end
				end)
				if project_autoformat_status == nil then
					Util.info({
						"",
						"**Global Format:** `" .. yesno(
							"enabled",
							"disabled",
							LspGlobal.autoformat ~= false
						) .. "`",
						"**Buffer Format:** `" .. yesno(
							"enabled",
							"disabled",
							LspBuffer.autoformat ~= false
						) .. "`",
					}, { title = "LSP Autoformat" })
				end
			end,
			desc = "[LSP] Show current autoformat status",
		},
	}
	local format_commands_state = {
		On = true,
		Off = false,
	}
	for state, value in pairs(format_commands_state) do
		commands["Format" .. state] = {
			command = function()
				M.set_autoformat(value, true)
			end,
			desc = "[LSP] Turn autoformat "
				.. string.lower(state)
				.. " globally",
		}
		commands["FormatBuffer" .. state] = {
			command = function()
				M.set_autoformat(value)
			end,
			desc = "[LSP] Turn autoformat "
				.. string.lower(state)
				.. "for current buffer",
		}
	end
	create_commands(commands)
end

return M
