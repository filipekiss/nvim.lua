-- bring back supertab from Nebula
local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0
		and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
				:sub(col, col)
				:match("%s")
			== nil
end

local smart_completion = function(direction)
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	if direction == "previous" then
		return function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.jumpable(-1) then
				vim.fn.feedkeys(
					vim.api.nvim_replace_termcodes(
						"<Plug>luasnip-jump-prev",
						true,
						true,
						true
					),
					""
				)
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end
	else
		return function(fallback)
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_locally_jumpable() then
				vim.fn.feedkeys(
					vim.api.nvim_replace_termcodes(
						"<Plug>luasnip-expand-or-jump",
						true,
						true,
						true
					),
					""
				)
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end
	end
end

return {
	smart_completion = smart_completion,
}
