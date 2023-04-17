-- require ui customizations for compltion
return {

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		build = (not jit.os:find("Windows")) and "make install_jsregexp" or nil,
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		-- stylua: ignore
		keys = {
			{
				"<tab>",
				function()
					return require("luasnip").jumpable(1)
							and "<Plug>luasnip-jump-next"
						or "<tab>"
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<tab>",
				function()
					require("luasnip").jump(1)
				end,
				mode = "s",
			},
			{
				"<s-tab>",
				function()
					require("luasnip").jump(-1)
				end,
				mode = { "i", "s" },
			},
		},
	},

	-- auto completion
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
		},
		init = function()
			require("plugins.coding.ui")
			local map = require("idle.helpers.mapping").map
			map("i", "<C-Space>", "<cmd>lua require('cmp').complete()<CR>")
		end,
		opts = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local smart_completion =
				require("plugins.coding.completion").smart_completion
			return {
				preselect = cmp.PreselectMode.None,
				window = {
					completion = {
						col_offset = -3,
						side_padding = 0,
						winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
						scrollbar = false,
					},
					documentation = {
						winhighlight = "Normal:CmpDoc",
					},
				},
				completion = {
					completeopt = "menu,menuone,noinsert,noselect",
					keyword_length = 3,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-n>"] = cmp.mapping(
						smart_completion(cmp, luasnip, "next"),
						{ "i", "s" }
					),
					["<C-p>"] = cmp.mapping(
						smart_completion(cmp, luasnip, "previous"),
						{ "i", "s" }
					),
					-- for colemak reasons, maybe I can find a better way to map this
					["<C-e>"] = cmp.mapping(
						smart_completion(cmp, luasnip, "previous"),
						{ "i", "s" }
					),
					["<C-u>"] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					["<Esc>"] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}),
					["<Tab>"] = cmp.mapping(
						smart_completion(cmp, luasnip, "next"),
						{ "i", "s" }
					),
					["<S-Tab>"] = cmp.mapping(
						smart_completion(cmp, luasnip, "previous"),
						{ "i", "s" }
					),
				}),
				confirm_opts = {
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(_, item)
						local icons = require("idle.config").options.icons.kinds
							or {}
						local icon = " " .. icons[item.kind] .. " "
						item.menu = item.kind
						item.kind = icon
						return item
					end,
				},
				experimental = {
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},
			}
		end,
	},

	-- auto pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},

	-- surround
	{
		"echasnovski/mini.surround",
		config = function(_, opts)
			require("mini.surround").setup(opts)
		end,
	},

	-- comments
	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			hooks = {
				pre = function()
					require("ts_context_commentstring.internal").update_commentstring({})
				end,
			},
		},
		config = function(_, opts)
			require("mini.comment").setup(opts)
		end,
	},

	-- better text-objects
	{
		"echasnovski/mini.ai",
		-- keys = {
		--   { "a", mode = { "x", "o" } },
		--   { "i", mode = { "x", "o" } },
		-- },
		event = "VeryLazy",
		dependencies = { "nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = {
							"@block.outer",
							"@conditional.outer",
							"@loop.outer",
						},
						i = {
							"@block.inner",
							"@conditional.inner",
							"@loop.inner",
						},
					}, {}),
					f = ai.gen_spec.treesitter(
						{ a = "@function.outer", i = "@function.inner" },
						{}
					),
					c = ai.gen_spec.treesitter(
						{ a = "@class.outer", i = "@class.inner" },
						{}
					),
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
			-- register all text objects with which-key
			if
				require("idle.helpers.plugin").is_installed("which-key.nvim")
			then
				---@type table<string, string|table>
				local i = {
					[" "] = "Whitespace",
					['"'] = 'Balanced "',
					["'"] = "Balanced '",
					["`"] = "Balanced `",
					["("] = "Balanced (",
					[")"] = "Balanced ) including white-space",
					[">"] = "Balanced > including white-space",
					["<lt>"] = "Balanced <",
					["]"] = "Balanced ] including white-space",
					["["] = "Balanced [",
					["}"] = "Balanced } including white-space",
					["{"] = "Balanced {",
					["?"] = "User Prompt",
					_ = "Underscore",
					a = "Argument",
					b = "Balanced ), ], }",
					c = "Class",
					f = "Function",
					o = "Block, conditional, loop",
					q = "Quote `, \", '",
					t = "Tag",
				}
				local a = vim.deepcopy(i)
				for k, v in pairs(a) do
					a[k] = v:gsub(" including.*", "")
				end

				local ic = vim.deepcopy(i)
				local ac = vim.deepcopy(a)
				for key, name in pairs({ n = "Next", l = "Last" }) do
					i[key] = vim.tbl_extend(
						"force",
						{ name = "Inside " .. name .. " textobject" },
						ic
					)
					a[key] = vim.tbl_extend(
						"force",
						{ name = "Around " .. name .. " textobject" },
						ac
					)
				end
				require("which-key").register({
					mode = { "o", "x" },
					i = i,
					a = a,
				})
			end
		end,
	},
}
