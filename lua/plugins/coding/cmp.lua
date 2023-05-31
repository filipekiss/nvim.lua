return {
	"https://github.com/hrsh7th/nvim-cmp",
	version = false, -- last release is way too old
	event = "InsertEnter",
	dependencies = {
		"https://github.com/hrsh7th/cmp-nvim-lsp",
		"https://github.com/hrsh7th/cmp-buffer",
		"https://github.com/hrsh7th/cmp-path",
		"https://github.com/saadparwaiz1/cmp_luasnip",
		"LuaSnip",
		"https://github.com/hrsh7th/cmp-omni",
	},
	init = function()
		require("plugins.coding.helpers.ui")
	end,
	config = function(_, opts)
		require("cmp").setup(opts)
		require("cmp").setup.filetype("DressingInput", {
			sources = require("cmp").config.sources({ { name = "omni" } }),
		})
	end,
	opts = function()
		local cmp = require("cmp")
		local smart_completion = require(
			"plugins.coding.helpers.smart_completion"
		)
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
				autocomplete = false,
				completeopt = "menu,menuone,noinsert,noselect",
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-n>"] = cmp.mapping(smart_completion("next"), {
					"i",
					"s",
				}),
				["<C-p>"] = cmp.mapping(
					smart_completion("previous"),
					{ "i", "s" }
				),
				-- for colemak reasons, maybe I can find a better way to map this
				["<C-e>"] = cmp.mapping(
					smart_completion("previous"),
					{ "i", "s" }
				),
				["<C-x>"] = cmp.mapping.complete(),
				["<C-u>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				["<Esc>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = function()
						if cmp.visible() then
							cmp.close()
						else
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes(
									"<C-c>",
									true,
									true,
									true
								),
								"n",
								true
							)
						end
					end,
				}),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				}),
				["<Tab>"] = cmp.mapping(smart_completion("next"), {
					"i",
					"s",
				}),
				["<S-Tab>"] = cmp.mapping(
					smart_completion("previous"),
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
}
