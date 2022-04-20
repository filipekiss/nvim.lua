-- Customize the LSP signs
local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = "" },
}

local config = {
	-- disable virtual text
	virtual_text = true,
	-- show signs
	signs = {
		active = signs,
	},
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}

-- Format file when saving. Disable by setting vim.b.lsp_format_on_save = false
-- for the current buffer or vim.g.lsp_format_on_save = false for global
vim.g.lsp_format_on_save = true

return {
	signs = signs,
	config = config,
}
