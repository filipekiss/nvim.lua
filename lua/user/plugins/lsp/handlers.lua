local safe_require = require("nebula.helpers.require").safe_require
local common = { capabilities = nil }
local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
		local augroup = require("nebula.helpers.autocmd").augroup
		local fn_cmd = require("nebula.helpers.nvim").fn_cmd
		augroup("LspHighlight", {
			{
				events = { "CursorHold" },
				command = fn_cmd(vim.lsp.buf.document_highlight),
			},
			{
				events = { "CursorMoved" },
				command = fn_cmd(vim.lsp.buf.clear_references),
			},
		}, { buffer = true })
	end
end

local function lsp_mappings(bufnr)
	local nnoremap = require("nebula.helpers.mappings").nnoremap
	local make_opts = require("nebula.helpers.mappings").opts
	local description = make_opts.desc
	local opts = make_opts.silent({ buffer = bufnr })
	nnoremap(
		"gD",
		vim.lsp.buf.declaration,
		description("[LSP] Go to Declaration")(opts)
	)
	nnoremap(
		"gd",
		vim.lsp.buf.definition,
		description("[LSP] Go to Definition")(opts)
	)
	nnoremap(
		"K",
		"<cmd>lua vim.lsp.buf.hover()<CR>",
		description("[LSP] Show Hover")(opts)
	)
	nnoremap(
		"gi",
		"<cmd>lua vim.lsp.buf.implementation()<CR>",
		description("[LSP] Go to Implementation")(opts)
	)
	nnoremap(
		"<leader>K",
		vim.lsp.buf.signature_help,
		description("[LSP] Show Signature Help")(opts)
	)
	nnoremap(
		"<leader>rn",
		vim.lsp.buf.rename,
		description("[LSP] Rename symbol")(opts)
	)
	nnoremap(
		"gr",
		vim.lsp.buf.references,
		description("[LSP] Show References")(opts)
	)
	nnoremap("[d", function()
		vim.diagnostic.goto_prev({ float = { border = "rounded" } })
	end, description("[LSP] Go to Previous Diagnostic")(opts))
	nnoremap("]d", function()
		vim.diagnostic.goto_next({ float = { border = "rounded" } })
	end, description("[LSP] Go to Next Diagnostic")(opts))
	nnoremap("gl", function()
		vim.diagnostic.open_float(0, { border = "rounded", scope = "line" })
	end, description("[LSP] Show Line Diagnostics")(opts))
	nnoremap(
		"<leader>l",
		vim.diagnostic.setloclist,
		description("[LSP] Show Diagnostics List")(opts)
	)
	nnoremap(
		"<leader>ca",
		vim.lsp.buf.code_action,
		description("[LSP] Code Actions")(opts)
	)
	local add_user_command = require("nebula.helpers.nvim").add_user_command
	add_user_command("CodeActions", vim.lsp.buf.code_action)
	add_user_command("Format", vim.lsp.buf.format)
end

local format_on_save = function()
	local global_save = vim.g.lsp_format_on_save
	local buffer_save = vim.b.lsp_format_on_save
	if global_save == true or buffer_save == true then
		vim.lsp.buf.format()
	end
end

local function lsp_format(client)
	local fn_cmd = require("nebula.helpers.nvim").fn_cmd
	if client.server_capabilities.document_formatting then
		local augroup = require("nebula.helpers.autocmd").augroup
		augroup("NebulaLspFormatting", {
			{
				events = { "BufWritePre" },
				targets = { "<buffer>" },
				command = fn_cmd(format_on_save),
			},
		}, { buffer = true })
	end
end

function common.on_attach(client, bufnr)
	lsp_mappings(bufnr)
	lsp_highlight_document(client)
	lsp_format(client)
end

-- https://github.com/hrsh7th/cmp-nvim-lsp#setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp = safe_require("cmp_nvim_lsp")
-- if cmp is not installed, return the common config up until this point
if not cmp_lsp then
	return common
end

local cmp_lsp_capabilities = cmp_lsp.default_capabilities(capabilities) or {}
common.capabilities = cmp_lsp_capabilities

return common
