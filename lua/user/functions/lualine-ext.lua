local Util = require("user.functions")
local color = vim.tbl_extend("force", Util.fg("Keyword"), Util.bg("StatusLine"))

local M = {}

M.lazy = {
	sections = {
		lualine_a = {},
		lualine_b = {
			{
				function()
					local ok, lazy = pcall(require, "lazy")
					if not ok then
						return ""
					end

					return "⚡plugins loaded: "
						.. lazy.stats().loaded
						.. "/"
						.. lazy.stats().count
				end,
				color = color,
			},
		},
		lualine_z = {
			{
				require("lazy.status").updates,
				cond = require("lazy.status").has_updates,
			},
		},
	},

	filetypes = { "lazy" },
}

M.starter = {
	sections = {
		lualine_c = {
			{
				function()
					return vim.fn.fnamemodify(vim.loop.cwd(), ":~:.")
				end,
			},
		},
		lualine_y = {
			{
				function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return "⚡ Neovim loaded "
						.. stats.count
						.. " plugins in "
						.. ms
						.. "ms"
				end,
				color = color,
			},
		},
		lualine_z = {
			{
				require("lazy.status").updates,
				cond = require("lazy.status").has_updates,
			},
		},
	},
	filetypes = { "starter" },
}

return M
