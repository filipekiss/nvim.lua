-- Based on Eviline config for lualine
-- Author: shadmansaleh / filipekiss
-- Credit: glepnir

local cat_colors = require("catppuccin.palettes").get_palette()
local colors = {
	bg = cat_colors.black1,
	fg = cat_colors.white,
	yellow = cat_colors.yellow,
	cyan = cat_colors.sky,
	darkblue = cat_colors.black4,
	green = cat_colors.green,
	orange = cat_colors.peach,
	violet = cat_colors.mauve,
	magenta = cat_colors.pink,
	blue = cat_colors.blue,
	red = cat_colors.red,
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	show_in_wide = function()
		local is_wide = vim.fn.winwidth(0) > 80
		return is_wide
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
	has_lsp_attached = function()
		local clients = vim.lsp.get_active_clients()
		if next(clients) == nil then
			return false
		end
		return true
	end,
}

-- Config
local config = {
	options = {
		-- Disable sections and component separators
		component_separators = "",
		section_separators = "",
		theme = {
			-- We are going to use lualine_c an lualine_x as left and
			-- right section. Both are highlighted by c theme .  So we
			-- are just setting default looks o statusline
			normal = { c = { fg = colors.fg, bg = colors.bg } },
			inactive = { c = { fg = colors.fg, bg = colors.bg } },
		},
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

-- Inserts a component in lualine_c at left section
local function ins_left_inactive(component)
	table.insert(config.inactive_sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right_inactive(component)
	table.insert(config.inactive_sections.lualine_x, component)
end

-- ins_left({
-- 	function()
-- 		return "▊"
-- 	end,
-- 	color = { fg = colors.blue }, -- Sets highlighting of component
-- 	padding = { left = 0 }, -- We don't need space before this
-- })

ins_left({
	-- mode component
	function()
		return ""
	end,
	color = function()
		-- auto change color according to neovims mode
		local mode_color = {
			n = colors.red,
			i = colors.green,
			v = colors.blue,
			[""] = colors.blue,
			V = colors.blue,
			c = colors.magenta,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			[""] = colors.orange,
			ic = colors.yellow,
			R = colors.violet,
			Rv = colors.violet,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.red,
		}
		return { fg = mode_color[vim.fn.mode()] }
	end,
	padding = { right = 1 },
})

local filename_component = {
	"filename",
	cond = conditions.buffer_not_empty,
	color = { fg = colors.magenta, gui = "bold" },
	symbols = {
		modified = " ",
		readonly = " ",
	},
}
ins_left(filename_component)
ins_left_inactive(filename_component)

ins_left({
	"filetype",
	icon_only = true,
	colored = true,
	padding = { left = 0, right = 1 }, -- We don't need space before this
})
ins_left_inactive({
	"filetype",
	icon_only = true,
	padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
	"branch",
	icon = "",
	color = { fg = colors.violet, gui = "bold" },
})

ins_left({
	"diff",
	-- Is it me or the symbol for modified us really weird
	symbols = { added = " ", modified = "柳 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
})

ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " " },
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.cyan },
	},
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left({
	function()
		return "%="
	end,
})

ins_left({
	-- Lsp server name .
	function()
		local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
		local clients = vim.lsp.get_active_clients()
		local client_names = {}
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				if client.name == "null-ls" then
					local sources = require("null-ls.sources").get_available(
						buf_ft
					)
					for _, source in pairs(sources) do
						if source.name ~= "" then
							table.insert(client_names, source.name)
						end
					end
				end
				if
					not vim.tbl_contains(
						Nebula.user_options.filter_lsp_servers or {},
						client.name
					)
				then
					table.insert(client_names, client.name)
				else
				end
			end
		end
		if type(client_names) == "table" and next(client_names) ~= nil then
			return table.concat(client_names, "  ")
		end
	end,
	icon = " LSP:",
	color = { fg = "#ffffff", gui = "bold" },
	cond = conditions.has_lsp_attached,
})

-- Add components to right sections
ins_right({ "location" })

ins_right({
	"progress",
	color = { fg = colors.fg, gui = "bold" },
	cond = conditions.show_in_wide,
})

ins_right({
	-- filesize component
	"filesize",
	cond = conditions.buffer_not_empty,
})

ins_right({
	"o:encoding", -- option component same as &encoding in viml
	fmt = string.upper, -- I'm not sure why it's upper case either ;)
	cond = conditions.show_in_wide,
	color = { fg = colors.green, gui = "bold" },
})

ins_right({
	"fileformat",
	fmt = string.upper,
	color = { fg = colors.green, gui = "bold" },
})

ins_right({ 'os.date("%H:%M", os.time())' })
-- ins_right({
-- 	function()
-- 		return "▊"
-- 	end,
-- 	color = { fg = colors.blue },
-- 	padding = { left = 1, right = 0 },
-- })

return config
