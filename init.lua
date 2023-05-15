require("_")

-- install lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- map leader to <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("user.functions").lazy_notify()

-- setup lazy to load idle.nvim and then the plugins in the lua/plugin folder
-- see :h lazy.nvim.txt
---@type LazyConfig
local lazyOptions = {
	spec = {
		{
			"filipekiss/idle.nvim",
			dev = true,
			lazy = false,
			priority = 10000,
			config = true,
			cond = true,
			version = "*",
			dependencies = {
				{ "folke/lazy.nvim" },
			},
			opts = {
				colorscheme = "duskfox",
				-- extra options I use throughout my configuration
				-- having them here makes it easier to change settings without needing
				-- to remember where I need to update them
				quit_on_q = { -- which filetypes to quit on <q>
					"help",
					"lspinfo",
					"man",
					"notify",
					"qf",
					"checkhealth",
					"startuptime",
				},
				rooter = {
					root_pattern = {
						".rooter",
						".git",
						"package.json",
					}, -- if this files/folders are found, set as the current root. priority is top to bottom
					exclude = { "", "help", "man", "gitcommit" }, -- don't run rooter on these filetypes
					notify_once = true, -- only notify the first time the root is changed for a buffer in any given window
				},
				-- disable smart numbering for the following filetypes and use…
				nonumber = { "gitcommit" }, -- …nonumber norelativenumber (never show numbers)
				number = {}, -- …number norelativenumber (always show absolute number)
				relativenumber = { "man", "help" }, -- …number relativenumber (always show relative numbers)
				-- icons used by LSP, Completion, etc
				icons = {
					diagnostics = {
						Error = " ",
						Warn = " ",
						Hint = " ",
						Info = " ",
					},
					kinds = {
						Array = "",
						Boolean = "",
						Calendar = "",
						Class = "",
						Color = "",
						Constant = "",
						Constructor = "",
						Copilot = "",
						Enum = "",
						EnumMember = "",
						Event = "",
						Field = "ﰠ",
						File = "",
						Folder = "",
						Function = "",
						Interface = "",
						Keyword = "",
						Method = "",
						Module = "",
						Namespace = "",
						Null = "󰟢",
						Number = "",
						Object = "",
						Operator = "",
						Package = "",
						Property = "",
						Reference = "",
						Snippet = "",
						String = "",
						Struct = "פּ",
						Table = "",
						Tag = "",
						Text = "",
						TypeParameter = "",
						Unit = "塞",
						Value = "",
						Variable = "",
						Watch = "",
					},
				},
			},
		},
		{
			import = "plugins",
		},
		{
			import = "plugins.lang",
		},
		{
			import = "plugins.coding.copilot",
		},
	},
	dev = {
		path = "~/code/filipekiss",
		patterns = { "filipekiss" },
		fallback = true,
	},
}
require("lazy").setup(lazyOptions)
