local telescope = require("user.functions.telescope")
return {
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
	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		keys = {
			{
				"<leader>,",
				"<cmd>Telescope buffers show_all_buffers=true<cr>",
				desc = "Switch Buffer",
			},
			{ "<leader>/", telescope("live_grep"), desc = "Grep (root dir)" },
			{
				"<leader>:",
				"<cmd>Telescope command_history<cr>",
				desc = "Command History",
			},
			{
				"<leader><space>",
				telescope("files"),
				desc = "Find Files (root dir)",
			},
			-- find
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{
				"<leader>ff",
				telescope("files"),
				desc = "Find Files (root dir)",
			},
			{
				"<leader>fF",
				telescope("files", { cwd = false }),
				desc = "Find Files (cwd)",
			},
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			-- git
			{
				"<leader>gc",
				"<cmd>Telescope git_commits<CR>",
				desc = "commits",
			},
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
			-- search
			{
				"<leader>sa",
				"<cmd>Telescope autocommands<cr>",
				desc = "Auto Commands",
			},
			{
				"<leader>sb",
				"<cmd>Telescope current_buffer_fuzzy_find<cr>",
				desc = "Buffer",
			},
			{
				"<leader>sc",
				"<cmd>Telescope command_history<cr>",
				desc = "Command History",
			},
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{
				"<leader>sd",
				"<cmd>Telescope diagnostics bufnr=0<cr>",
				desc = "Document diagnostics",
			},
			{
				"<leader>sD",
				"<cmd>Telescope diagnostics<cr>",
				desc = "Workspace diagnostics",
			},
			{ "<leader>sg", telescope("live_grep"), desc = "Grep (root dir)" },
			{
				"<leader>sG",
				telescope("live_grep", { cwd = false }),
				desc = "Grep (cwd)",
			},
			{
				"<leader>sh",
				"<cmd>Telescope help_tags<cr>",
				desc = "Help Pages",
			},
			{
				"<leader>sH",
				"<cmd>Telescope highlights<cr>",
				desc = "Search Highlight Groups",
			},
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{
				"<leader>sM",
				"<cmd>Telescope man_pages<cr>",
				desc = "Man Pages",
			},
			{
				"<leader>sm",
				"<cmd>Telescope marks<cr>",
				desc = "Jump to Mark",
			},
			{
				"<leader>so",
				"<cmd>Telescope vim_options<cr>",
				desc = "Options",
			},
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{
				"<leader>sw",
				telescope("grep_string"),
				desc = "Word (root dir)",
			},
			{
				"<leader>sW",
				telescope("grep_string", { cwd = false }),
				desc = "Word (cwd)",
			},
			{
				"<leader>uC",
				telescope("colorscheme", { enable_preview = true }),
				desc = "Colorscheme with preview",
			},
			{
				"<leader>ss",
				telescope("lsp_document_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				telescope("lsp_dynamic_workspace_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol (Workspace)",
			},
			{
				"<leader>ft",
				"<cmd>Telescope filetypes<CR>",
				desc = "Set filetype",
			},
		},
		opts = {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				mappings = {
					i = {
						["<c-t>"] = function(...)
							return require("trouble.providers.telescope").open_with_trouble(
								...
							)
						end,
						["<a-t>"] = function(...)
							return require("trouble.providers.telescope").open_selected_with_trouble(
								...
							)
						end,
						["<a-i>"] = function()
							telescope("find_files", { no_ignore = true })()
						end,
						["<a-h>"] = function()
							telescope("find_files", { hidden = true })()
						end,
						["<C-Down>"] = function(...)
							return require("telescope.actions").cycle_history_next(
								...
							)
						end,
						["<C-Up>"] = function(...)
							return require("telescope.actions").cycle_history_prev(
								...
							)
						end,
						["<C-f>"] = function(...)
							return require("telescope.actions").preview_scrolling_down(
								...
							)
						end,
						["<C-b>"] = function(...)
							return require("telescope.actions").preview_scrolling_up(
								...
							)
						end,
					},
					n = {
						["q"] = function(...)
							return require("telescope.actions").close(...)
						end,
					},
				},
			},
		},
	},
}
