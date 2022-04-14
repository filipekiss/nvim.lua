local safe_require = require("nebula.helpers.require").safe_require
local cmp = safe_require("cmp")
if not cmp then
	return
end

local smart_completion = require("nebula.helpers.completion").smart_completion

local inoremap = require("nebula.helpers.mappings").inoremap
inoremap("<C-n>", "<cmd>lua require('cmp').complete()<CR>")

return {
	completion = {
		autocomplete = false,
	},
	mapping = {
		["<C-n>"] = cmp.mapping(smart_completion("next"), { "i", "s" }),
		["<C-p>"] = cmp.mapping(smart_completion("previous"), { "i", "s" }),
		["<C-e>"] = cmp.mapping(smart_completion("previous"), { "i", "s" }),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-u>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},
}
