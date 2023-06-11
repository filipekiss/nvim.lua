local Util = require("user.functions")

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function()
		local icons = Idle.options.icons

		return {
			options = {
				component_separators = "",
				section_separators = "",
				theme = "auto",
				globalstatus = true,
				disabled_filetypes = {
					winbar = { "starter" },
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						-- mode component
						function()
							return type(Idle.options.icons.mode) == "string"
									and Idle.options.icons.mode
								or ">"
						end,
						color = function()
							-- auto change color according to neovims mode
							--
							local colors = {
								ok = Util.fg("DiagnosticOk"),
								hint = Util.fg("DiagnosticHint"),
								error = Util.fg("DiagnosticError"),
								warn = Util.fg("DiagnosticWarn"),
								info = Util.fg("DiagnosticInfo"),
								keyword = Util.fg("Keyword"),
								include = Util.fg("Include"),
							}
							local mode_color = {
								n = colors.error,
								i = colors.ok,
								v = colors.info,
								[""] = colors.info,
								V = colors.info,
								c = colors.keyword,
								no = colors.error,
								s = colors.warn,
								S = colors.warn,
								[""] = colors.warn,
								ic = colors.yellow,
								R = colors.include,
								Rv = colors.include,
								cv = colors.error,
								ce = colors.error,
								r = colors.hint,
								rm = colors.hint,
								["r?"] = colors.hint,
								["!"] = colors.error,
								t = colors.error,
							}
							return mode_color[vim.fn.mode()]
						end,
						padding = { left = 1, right = 1 },
					},
					{
						"filetype",
						icon_only = true,
						separator = "",
						padding = {},
					},
					{
						"filename",
						path = 1,
						symbols = {
							modified = "",
							readonly = "",
							unnamed = "",
						},
					},
				},
				lualine_x = {
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
					-- stylua: ignore
					{
						function()
							return require("noice").api.status.command.get()
						end,
						cond = function()
							return package.loaded["noice"]
								and require("noice").api.status.command.has()
						end,
						color = Util.fg("Statement"),
					},
					-- show commands being typed in normal mode
					-- stylua: ignore
					{
						function()
							return require("noice").api.status.mode.get()
						end,
						cond = function()
							return package.loaded["noice"]
								and require("noice").api.status.mode.has()
						end,
						color = Util.fg("Constant"),
					},
					-- show if we have lazy packages that need an update
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = Util.fg("Special"),
					},
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
					},
				},
				lualine_y = {
					{
						function()
							return type(Idle.options.icons.harpoon) == "string"
									and Idle.options.icons.harpoon
								or "!"
						end,
						cond = function()
							return require("harpoon.mark").get_index_of(
								vim.fn.bufname()
							) and true or false
						end,
					},
					{
						"branch",
						icon = "",
						padding = { left = 1, right = 1 },
						color = Util.fg("Keyword"),
					},
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
			},
			winbar = {
				lualine_c = {
					{
						"%=",
					},
					{
						function()
							return require("nvim-navic").get_location()
						end,
						cond = function()
							return package.loaded["nvim-navic"]
								and require("nvim-navic").is_available()
						end,
						color = Util.bg("Normal"),
					},
					{
						"%=",
					},
				},
			},
			inactive_winbar = {},
			extensions = {
				"neo-tree",
				require("user.functions.lualine-ext").lazy,
				require("user.functions.lualine-ext").starter,
			},
		}
	end,
}
