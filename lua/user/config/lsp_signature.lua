return {
	-- Floating window borders ---------------------------------------- {{{
	-- as per https://github.com/ray-x/lsp_signature.nvim#floating-window-borders
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	handler_opts = {
		border = "rounded",
	},
	-- Floating window borders End ------------------------------------ }}}
	select_signature_key = "<C-x>", -- cycle between signatures e.g. function overload
	hint_prefix = " ", -- prefix for parameter hints
}
