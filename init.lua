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
require("lazy").setup({
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
				rooter = {
					exclude = { "", "help", "man", "gitcommit" }, -- don't run rooter on these filetypes
				},
				-- disable smart numbering for the following filetypes and use…
				nonumber = { "gitcommit" }, -- …nonumber norelativenumber (never show numbers)
				number = {}, -- …number norelativenumber (always show absolute number)
				relativenumber = { "man", "help" }, -- …number relativenumber (always show relative numbers)
			},
		},
		{
			import = "plugins",
		},
		{
			import = "plugins.lang",
		},
	},
	---@diagnostic disable-next-line: assign-type-mismatch
	dev = {
		path = "~/code/filipekiss",
		patterns = { "filipekiss" },
		fallback = true,
	},
})
