local types = require("luasnip.util.types")
return {
	store_selection_keys = "<Tab>",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "← Choice", "Todo" } },
			},
		},
		-- [types.insertNode] = {
		--   active = {
		--     virt_text = {{"← ...", "Todo"}},
		--   },
		-- },
	},
	region_check_events = "InsertEnter",
	delete_check_events = "TextChanged,InsertLeave",
}
