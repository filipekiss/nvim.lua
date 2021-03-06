local leader = require("nebula.helpers.mappings").leader
local localleader = require("nebula.helpers.mappings").localleader
local inoremap = require("nebula.helpers.mappings").inoremap
local nmap = require("nebula.helpers.mappings").nmap
local nnoremap = require("nebula.helpers.mappings").nnoremap
local opts = require("nebula.helpers.mappings").opts
local tnoremap = require("nebula.helpers.mappings").tnoremap
local vnoremap = require("nebula.helpers.mappings").vnoremap
local xnoremap = require("nebula.helpers.mappings").xnoremap
local makeExpr = require("nebula.helpers.mappings").expr

-- Set the Leader key to Space
leader(" ")
localleader(" ")

local default_options = {}
-- use arrows to resize windows
nnoremap("<Left>", ":vertical resize +2<CR>", opts.silent(default_options))
nnoremap("<Right>", ":vertical resize -2<CR>", opts.silent(default_options))
nnoremap("<Up>", ":resize +2<CR>", opts.silent(default_options))
nnoremap("<Down>", ":resize -2<CR>", opts.silent(default_options))

-- treat overflowing text as having line breaks, useful when `set wrap` is true
-- I use opts.expr here to set `expr=true` so the mapping is treated as an
-- expression
nnoremap("j", "v:count ? 'j' : 'gj'", opts.expr(opts.silent(default_options)))
nnoremap("k", "v:count ? 'k' : 'gk'", opts.expr(opts.silent(default_options)))
xnoremap("j", "v:count ? 'j' : 'gj'", opts.expr(opts.silent(default_options)))
xnoremap("k", "v:count ? 'k' : 'gk'", opts.expr(opts.silent(default_options)))

-- used to quickly move lines up and down. accepts a count, so 2<leader>j will
-- move it two lines down and also works in visual selection mode
nnoremap(
	"<leader>j",
	":<c-u>execute 'move +' . v:count1<CR>",
	opts.silent(default_options)
)
nnoremap(
	"<leader>k",
	":<c-u>execute 'move --' . v:count1<CR>",
	opts.silent(default_options)
)
xnoremap(
	"<leader>j",
	":<c-u>execute \"'<,'>move'>+\" . v:count1 <CR>gv",
	opts.silent(default_options)
)
xnoremap(
	"<leader>k",
	":<c-u>execute \"'<,'>move'<--\" . v:count1 <CR>gv",
	opts.silent(default_options)
)

-- keep the search match in the middle of the window when jumping
nmap("n", "nzz", default_options)
nmap("N", "Nzz", default_options)

-- don't lose selection when shifting identation
xnoremap("<", "<gv", default_options)
xnoremap(">", ">gv", default_options)

-- don't move the cursor when yanking
-- See http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap(
	"y",
	makeExpr('my\\"" . v:register . "y`y'),
	opts.expr(default_options)
)

-- mark the current line and add a line at the beggining and end of the file
nnoremap("<leader>o", "moGGo", default_options)
nnoremap("<leader>O", "mOggO", default_options)

-- easier navigation in line - H goes to the start, L goes to the end
nnoremap("H", "^", default_options)
nnoremap("L", "$", default_options)

-- Make better undo chunks when writing long texts (prose) without exiting insert mode.
-- :h i_CTRL-G_u
-- https://twitter.com/vimgifs/status/913390282242232320
inoremap(".", ".<c-g>u", default_options)
inoremap("?", "?<c-g>u", default_options)
inoremap("!", "!<c-g>u", default_options)
inoremap(",", ",<c-g>u", default_options)

-- Use CTRL+[HJKL] to navigate between panes, instead of CTRL+W CTRL+[HJKL]
nnoremap("<leader>m", "<C-w><C-h>", default_options)
nnoremap("<leader>n", "<C-w><C-j>", default_options)
nnoremap("<leader>e", "<C-w><C-k>", default_options)
nnoremap("<leader>i", "<C-w><C-l>", default_options)

-- Use | to split window vertically and _ to split it horizontally
nnoremap(
	"<Bar>",
	'v:count == 0 ? "<C-W>v<C-W>l" : ":<C-U>normal! 0".v:count."<Bar><CR>"',
	opts.expr(opts.silent(default_options))
)
nnoremap(
	"_",
	'v:count == 0 ? "<C-W>s<C-W>k" : ":<C-U>normal! 0".v:count."_<CR>"',
	opts.expr(opts.silent(default_options))
)

-- List current buffers to cycle
nnoremap("<tab>", ":ls<CR>:b<space>", default_options)

-- repeat last macro (use qq to record, @q to run the first time and Q to run it
-- avoid overwriting the register when pasting
nnoremap("Q", "@@", default_options)

-- avoid overwriting the register when pasting (allow to past multiple times)
xnoremap("p", '"_dP', default_options)

-- Insert before current word under the cursor
nnoremap("<leader>I", "bi", default_options)

-- Insert after current word under the cursor
nnoremap("<leader>A", "ea", default_options)

-- make <leader>q exit terminal mode when in terminal, of course
tnoremap("<Leader>q", "<C-\\><C-n>", default_options)

-- make <leader>Q quit neovim
nnoremap(
	"<leader>Q",
	'&diff ? ":windo bd<CR>" : ":quit<CR>"',
	opts.expr(opts.silent(default_options))
)

-- when selecting an item in quickfix, close it
local augroup = require("nebula.helpers.autocmd").augroup
augroup("NebulaQfCloseOnSelect", {
	{
		events = { "FileType" },
		targets = { "qf" },
		command = nnoremap(
			"<CR>",
			"<CR>:cclose<CR>",
			opts.get_string(opts.buffer(opts.silent()))
		),
	},
})
-- press q to close que quickfix list
augroup("NebulaQfCloseOnQ", {
	{
		events = { "FileType" },
		targets = { "qf", "help" },
		command = nnoremap(
			"q",
			":q<CR>",
			opts.get_string(opts.buffer(opts.silent()))
		),
	},
})
