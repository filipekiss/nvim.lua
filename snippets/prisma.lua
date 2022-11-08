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
	-- create and update timestamps
	s({ trig = "@cua", dscr = "Add created_at and updated_at fields" }, {
		t("created_at DateTime @default(now())"),
		t({ "", "" }),
		t("updated_at DateTime @updatedAt"),
	}),
	-- id
	s({ trig = "@id", dscr = "Add and autoincrmenting id field" }, {
		t("id Int @id @default(autoincrement())"),
	}),
	-- one-to-one relationship
	s(
		{ trig = "@oto", dscr = "Add a one-to-one relationship field" },
		c(1, {
			sn(nil, {
				i(1, "field"),
				t(" "),
				i(2, "Model"),
				t(" "),
				t("@relation(fields: ["),
				d(3, function(args, _, _, suffix)
					return sn(nil, {
						i(1, args[1][1] .. suffix),
					})
				end, { 1 }, { user_args = { "Id" } }),
				t("], references: ["),
				i(4, "id"),
				t({ "])", "" }),
				f(function(args)
					return { args[1][1] }
				end, { 3 }),
				t(" "),
				i(5, "Int"),
				t(" @unique"),
			}),
			sn(nil, {
				i(1, "field"),
				t(" "),
				i(2, "Model"),
				t("?"),
			}),
		})
	),
	-- one-to-many relationship
	s(
		{ trig = "@otm", dscr = "Add a one-to-many relationship field" },
		c(1, {
			sn(nil, {
				i(1, "field"),
				t(" "),
				i(2, "Model"),
				t(" "),
				t("@relation(fields: ["),
				d(3, function(args, _, _, suffix)
					return sn(nil, {
						i(1, args[1][1] .. suffix),
					})
				end, { 1 }, { user_args = { "Id" } }),
				t("], references: ["),
				i(4, "id"),
				t({ "])", "" }),
				f(function(args)
					return { args[1][1] }
				end, { 3 }),
				t(" "),
				i(5, "Int"),
			}),
			sn(nil, {
				i(1, "field"),
				t(" "),
				i(2, "Model"),
				t("[]"),
			}),
		})
	),
}
