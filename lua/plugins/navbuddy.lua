local Util = require("user.functions")

return {
	{
		"https://github.com/SmiteshP/nvim-navbuddy",
		cmd = { "Navbuddy" },
		keys = {
			{
				"<leader>cs",
				function()
					require("nvim-navbuddy").open()
				end,
				mode = "n",
				desc = "Symbol navigation",
			},
		},
		dependencies = { "nvim-navic", "nui.nvim" },
		opts = {
			lsp = {
				auto_attach = true,
			},
		},
	},
	{
		"https://github.com/SmiteshP/nvim-navic",
		lazy = true,
		init = function()
			vim.g.navic_silence = true
			require("user.functions.lsp").attach_autocmd(
				function(client, buffer)
					if client.server_capabilities.documentSymbolProvider then
						require("nvim-navic").attach(client, buffer)

						local navic_lib = require("nvim-navic.lib")

						local lualine_fg = Util.get_hlgroup("Comment").fg
						local lualine_bg = Util.get_hlgroup("StatusLine").bg

						local set_highlight = vim.api.nvim_set_hl
						local style = function(fg, bg)
							return { fg = fg, bg = bg }
						end

						set_highlight(
							0,
							"NavicText",
							style(lualine_fg, lualine_bg)
						)

						set_highlight(
							0,
							"NavicSeparator",
							style(lualine_fg, lualine_bg)
						)

						for i = 1, 26, 1 do
							local hl_name = "NavicIcons"
								.. navic_lib.adapt_lsp_num_to_str(i)

							local hl = Util.get_hlgroup(hl_name)
							if hl.fg ~= nil and hl.fg ~= "NONE" then
								set_highlight(
									0,
									hl_name,
									style(hl.fg, lualine_bg)
								)
							end
						end
					end
				end
			)
		end,
		opts = function()
			local icons = Idle and Idle.options.icons.kinds or {}
			for k, v in pairs(icons) do
				icons[k] = v .. " "
			end
			return {
				separator = " › ",
				highlight = true,
				depth_limit = 5,
				depth_limit_indicator = "⋯",
				icons = icons,
			}
		end,
	},
}
