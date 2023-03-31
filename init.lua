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
				colorscheme = "catppuccin",
				debug = true,
			},
		},
		{
			import = "plugins",
		},
	},
	dev = {
		path = "~/code/filipekiss",
		patterns = { "filipekiss" },
		fallback = true,
	},
})
