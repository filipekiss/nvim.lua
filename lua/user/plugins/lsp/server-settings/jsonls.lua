local safe_require = require("nebula.helpers.require").safe_require
local schemastore = safe_require("schemastore")

if not schemastore then
	return {}
end

return {
	capabilities = {
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = true,
				},
			},
		},
	},
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
		},
	},
}
