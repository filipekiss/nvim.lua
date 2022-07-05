local safe_require = require("nebula.helpers.require").safe_require
local luasnip = safe_require("luasnip")
if not luasnip then
	return
end
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local r = luasnip.restore_node
local types = require("luasnip.util.types")
local fmt = require("luasnip.extras.fmt").fmt

return {
	s({ trig = "@cua", dscr = "Add created_at and updated_at fields" }, {
		t("created_at DateTime @default(now())"),
		t(" "),
		t("updated_at DateTime @updatedAt"),
	}),
	-- relation ship
	s(
		{ trig = "@rel", dscr = "Add a relationship field" },
		c(1, {
			sn(nil, {
				i(1, "field"),
				t(" "),
				i(2, "Model"),
				t(' @relation("'),
				d(3, function(args)
					return sn(nil, {
						i(1, args[1][1]),
					})
				end, { 1 }),
				t('", fields: ['),
				d(4, function(args, _, _, suffix)
					return sn(nil, {
						i(1, args[1][1] .. suffix),
					})
				end, { 1 }, { user_args = { "_id" } }),
				t("], references: ["),
				i(5, "id"),
				t({ "])", "" }),
				f(function(args, _, user_arg_1)
					return { args[1][1] .. user_arg_1 }
				end, { 1 }, { user_args = { "_id" } }),
				t(" "),
				i(6, "Int"),
			}),
			sn(nil, {
				i(1, "field"),
				t(" "),
				i(2, "Model"),
				t(' @relation("'),
				d(3, function(args)
					return sn(nil, {
						i(1, args[1][1]),
					})
				end, { 1 }),
				t('")'),
			}),
		})
	),
}
