local safe_require = require("nebula.helpers.require").safe_require
local schemastore = safe_require("schemastore")

if not schemastore then
	return {}
end

return {
	on_attach = function(client)
		-- disabled so I can use prettier/d
		client.server_capabilities.document_formatting = false
	end,
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
