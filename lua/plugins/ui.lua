return {
	-- Better `vim.notify()`
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Delete all Notifications",
			},
		},
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			render = "compact",
		},
		init = function()
			require("idle.helpers.autocmd").create_user_autocmd("VeryLazy", {
				callback = function()
					vim.notify = require("notify")
				end,
				group = require("idle.helpers.autocmd").augroup("notify", true),
			})
		end,
		config = function(_, opts)
			local options = vim.tbl_deep_extend(
				"force",
				opts,
				Idle.options.notify or {}
			)
			local enable_debug = Idle.options.debug or false
			if enable_debug then
				options.level = vim.log.levels.DEBUG
			end
			require("notify").setup(options)
			local get_hlgroup = Idle.load("functions").get_hlgroup
			local info = get_hlgroup("DiagnosticInfo")
			local error = get_hlgroup("DiagnosticError")
			local warn = get_hlgroup("DiagnosticWarn")
			local debug = get_hlgroup("DiagnosticHint")
			local hlgroups = {
				NotifyINFOBorder = info,
				NotifyINFOIcon = info,
				NotifyINFOTitle = info,
				NotifyERRORBorder = error,
				NotifyERRORIcon = error,
				NotifyERRORTitle = error,
				NotifyWARNBorder = warn,
				NotifyWARNIcon = warn,
				NotifyWARNTitle = warn,
				NotifyDEBUGBorder = debug,
				NotifyDEBUGIcon = debug,
				NotifyDEBUGTitle = debug,
			}

			for group, spec in pairs(hlgroups) do
				vim.api.nvim_set_hl(0, group, spec)
			end
		end,
	},
}
