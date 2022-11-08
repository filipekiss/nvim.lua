local safe_require = require("nebula.helpers.require").safe_require
local cmp = safe_require("cmp")
if not cmp then
	return
end

local smart_completion = require("nebula.helpers.completion").smart_completion

local inoremap = require("nebula.helpers.mappings").inoremap
inoremap("<C-Space>", "<cmd>lua require('cmp').complete()<CR>")

-- local cmp_buffer = safe_require("cmp_buffer")

local luasnip = safe_require("luasnip")

local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

-- local compare = require("cmp.config.compare")

return {
	preselect = cmp.PreselectMode.None,
	completion = {
		keyword_length = 2,
	},
	mapping = {
		["<C-n>"] = cmp.mapping(smart_completion("next"), { "i", "s" }),
		["<C-p>"] = cmp.mapping(smart_completion("previous"), { "i", "s" }),
		["<C-e>"] = cmp.mapping(smart_completion("previous"), { "i", "s" }),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
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
			select = true,
		}),
		["<Tab>"] = cmp.mapping(smart_completion("next"), { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(smart_completion("previous"), { "i", "s" }),
	},
	snippet = {
		expand = function(args)
			if luasnip ~= nil then
				luasnip.lsp_expand(args.body)
			end
		end,
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				cmp_tabnine = "[TN]",
				luasnip = "[Snippet]",
				nvim_lsp = "[LSP]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "cmp_tabnine" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		documentation = {
			border = {
				"╭",
				"─",
				"╮",
				"│",
				"╯",
				"─",
				"╰",
				"│",
			},
		},
	},
	experimental = {
		ghost_text = false,
		native_menu = false,
	},
}
