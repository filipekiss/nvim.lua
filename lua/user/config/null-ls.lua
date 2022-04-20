local safe_require = require("nebula.helpers.require").safe_require
local null_ls = safe_require("null-ls")
if not null_ls then
	return
end
local formatting = null_ls.builtins.formatting
return {
	debug = true,
	on_attach = require("user.plugins.lsp.handlers").on_attach,
	sources = {
		-- these sources require external tools that should be installed on the
		-- system and availbable in the $PATH
		-- Right next to each plugin I added a comment with the command that you
		-- can use to install these dependencies
		formatting.prettier, -- volta install prettier
		formatting.stylua, -- cargo install stylua
	},
}
