return {
	"https://github.com/github/copilot.vim",
	config = function()
		local imap = require("nebula.helpers.mappings").imap
		local opts = require("nebula.helpers.mappings").opts
		-- imap("C-j", 'copilot#Accept("\\<CR>")', opts.expr(opts.silent()))
	end,
}
