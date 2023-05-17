-- this is heavily based on nightfox but I want to make this a bit more generic
-- and use basically only links and generated colors
-- see line 62 onwards
local M = {}

function M.update_colors()
	local get_hlgroup = require("user.functions").get_hlgroup
	local Color = require("nightfox.lib.color")

	local nightfox_cmp = require("nightfox.group.modules.cmp")
	local style = vim.g.colors_name
	local config = require("nightfox.config").options
	local s = require("nightfox.spec").load(style)
	local cmp_highlights = nightfox_cmp.get(s, config)
	local p = s.palette
	local base = Color.from_hex(s.bg0)
	local tbg = config.transparent and "NONE" or s.bg0

	local baseSelectedColor = p.magenta
	local selectedColor = {
		bg = baseSelectedColor.bright,
		fg = Color.from_hex(baseSelectedColor.dim):lighten(-20):to_css(),
	}

	local highlights = vim.tbl_deep_extend("force", cmp_highlights, {
		CmpDoc = { bg = s.bg0 },
		CmpDocBorder = { fg = s.bg0, bg = s.bg0 },
		PmenuSel = selectedColor,
		CmpPmenu = {
			fg = selectedColor.bg,
			-- bg = Color.from_hex(selectedColor.bg):lighten(10):to_css(),
		},
		CmpSel = {
			bg = selectedColor.bg,
			fg = selectedColor.fg,
			style = "bold",
		},

		CmpItemAbbrDeprecated = {
			style = "strikethrough",
		},
		CmpItemAbbr = {
			link = "Comment",
		},
		CmpItemAbbrMatch = {
			fg = selectedColor.bg,
			bg = "NONE",
			style = "bold",
		},
		CmpItemAbbrMatchFuzzy = {
			fg = selectedColor.bg,
			bg = "NONE",
			style = "bold",
		},
		CmpItemMenu = {
			link = "Comment",
		},
	})

	local function fade(color, amount)
		amount = amount or 0.3
		return Color(s.bg1):blend(Color.from_hex(color), amount):to_css()
	end

	-- TODO: Map this to TreeSitter types
	local item_kinds = {
		CmpItemKindField = { fg = p.red() },
		CmpItemKindProperty = { fg = p.red() },
		CmpItemKindEvent = { fg = p.red() },

		CmpItemKindText = { fg = p.green() },
		CmpItemKindEnum = { fg = p.green() },
		CmpItemKindKeyword = { fg = p.green() },

		CmpItemKindConstant = { fg = p.yellow() },
		CmpItemKindConstructor = { fg = p.yellow() },
		CmpItemKindReference = { fg = p.yellow() },

		CmpItemKindFunction = { fg = p.magenta() },
		CmpItemKindStruct = { fg = p.magenta() },
		CmpItemKindClass = { fg = p.magenta() },
		CmpItemKindModule = { fg = p.magenta() },
		CmpItemKindOperator = { fg = p.magenta() },

		CmpItemKindVariable = { fg = p.comment },
		CmpItemKindFile = { fg = p.comment },

		CmpItemKindUnit = { fg = p.yellow() },
		CmpItemKindSnippet = { fg = p.yellow() },
		CmpItemKindFolder = { fg = p.yellow() },

		CmpItemKindMethod = { fg = p.blue() },
		CmpItemKindValue = { fg = p.blue() },
		CmpItemKindEnumMember = { fg = p.blue() },

		CmpItemKindInterface = { fg = p.cyan() },
		CmpItemKindColor = { fg = p.cyan() },
		CmpItemKindTypeParameter = { fg = p.cyan() },
	}

	-- override item_kind highlights for atom_colored style
	for group, spec in
		pairs(vim.tbl_deep_extend("force", highlights, item_kinds))
	do
		local new_spec = spec

		if spec.link ~= nil then
			if spec.link then
				local proper_spec = get_hlgroup(spec.link)
				new_spec = proper_spec
			else
				spec["link"] = nil
			end
		end
		if spec.style then
			---@diagnostic disable-next-line: assign-type-mismatch
			new_spec[spec.style] = true
			new_spec.style = nil
		end

		if item_kinds[group] then
			new_spec = vim.tbl_deep_extend("force", new_spec, item_kinds[group])
			---@diagnostic disable: undefined-field
			new_spec.fg = new_spec.fg
			new_spec.bg = fade(new_spec.fg, 0.3)
			---@diagnostic enable: undefined-field
			new_spec.bold = true
		end
		vim.api.nvim_set_hl(0, group, new_spec)
	end
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
autocmd({ "ColorScheme", "VimEnter" }, {
	desc = "update completion menu colors",
	group = augroup("colorscheme_completion", { clear = true }),
	pattern = { "*" },
	callback = function()
		M.update_colors()
	end,
})
