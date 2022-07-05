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

s(
	{ trig = "@snippet", dscr = "imports for lua snippets" },
	t([[
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
  ]])
)
