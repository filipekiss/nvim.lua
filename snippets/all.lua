local function get_comment_wrapper(_, _, part)
	-- adapted from https://github.com/terrortylor/nvim-comment/blob/e9ac16ab056695cad6461173693069ec070d2b23/lua/nvim_comment.lua#L24
	local cs = vim.api.nvim_buf_get_option(0, "commentstring")

	-- make sure comment string is understood
	if cs:find("%%s") then
		local left, right = cs:match("^(.*)%%s(.*)")
		if right == "" then
			right = nil
		end

		-- left comment markers should have padding as linterers preffer
		if not left:match("%s$") then
			left = left .. " "
		end
		if right and not right:match("^%s") then
			right = " " .. right
		end

		if part == "right" then
			return right or ""
		end
		return left or ""
	end
	return ""
end

return {
	-- vim fold
	s({ trig = "@fold", dscr = "Wrap the selected text in a fold" }, {
		f(get_comment_wrapper, {}, { user_args = { "left" } }),
		i(1, "Fold Title"),
		t(" ---------------------------------------- {{{"),
		f(get_comment_wrapper, {}, { user_args = { "right" } }),
		t({ "", "" }),
		d(2, function(args, snip)
			local next = next
			local selected_text = snip.env.TM_SELECTED_TEXT
			if next(selected_text) == nil then
				return sn(nil, {
					i(1, ""),
				})
			else
				return sn(nil, { t(selected_text) })
			end
		end),
		t({ "", "" }),
		f(get_comment_wrapper, {}, { user_args = { "left" } }),
		f(function(args)
			return { args[1][1] }
		end, { 1 }),
		t(" End ------------------------------------ }}}"),
		f(get_comment_wrapper, {}, { user_args = { "right" } }),
	}),
}
