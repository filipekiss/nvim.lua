local fn = vim.fn
local log = require("nebula.log")
	-- Set path to install packer
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

	-- Automatically install packer if not installed
	if fn.empty(fn.glob(install_path)) > 0 then
		log.temporary_level("info")
		log.info("packer.nvim not found. Installing…")
		PACKER_BOOTSTRAP = fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
			"-q",
		})
		vim.cmd([[redraw!]])
		log.info("packer.nvim installed. Installing plugins…")
		log.restore_level()
		vim.cmd([[packadd packer.nvim]])
	end
local packer = {
	"https://github.com/wbthomason/packer.nvim",
}

return packer
