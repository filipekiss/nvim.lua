return {
	close_on_select = true,
	on_attach = function(bufnr)
		local nnoremap = require("nebula.helpers.mappings").nnoremap
		local opts = require("nebula.helpers.mappings").opts
		nnoremap("<leader>a", "<cmd>AerialToggle<CR>", opts.buffer({}, bufnr))
		nnoremap("{", "<cmd>AerialPrev<CR>", opts.buffer({}, bufnr))
		nnoremap("}", "<cmd>AerialNext<CR>", opts.buffer({}, bufnr))
		nnoremap("[[", "<cmd>AerialPrevUp<CR>", opts.buffer({}, bufnr))
		nnoremap("]]", "<cmd>AerialNextUp<CR>", opts.buffer({}, bufnr))
	end,
}
