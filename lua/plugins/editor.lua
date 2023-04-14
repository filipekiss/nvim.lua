return {
	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		keys = {},
		opts = {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
			},
		},
	},
	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		cmd = "Gitsigns",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>gd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
			end,
		},
	},
	-- cursed.nvim
	{
		"filipekiss/cursed.nvim",
		opts = {
			delay = 500,
			smart_cursorline = true,
		},
		config = true,
	},
}
