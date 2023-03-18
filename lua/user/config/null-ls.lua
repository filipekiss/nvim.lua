local safe_require = require("nebula.helpers.require").safe_require
local null_ls = safe_require("null-ls")
if not null_ls then
	return
end

return {
	debug = true,
	on_attach = require("user.plugins.lsp.handlers").on_attach,
	sources = {},
}
