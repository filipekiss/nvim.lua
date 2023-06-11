local map = require("idle.helpers.mapping").map

-- use arrows to resize windows
map(
	"n",
	"<Left>",
	"<cmd>vertical resize +2<CR>",
	{ desc = "Increase window width", silent = true }
)
map(
	"n",
	"<Right>",
	"<cmd>vertical resize -2<CR>",
	{ desc = "Decrease window width", silent = true }
)
map(
	"n",
	"<Up>",
	"<cmd>resize +2<CR>",
	{ desc = "Increase window height", silent = true }
)
map(
	"n",
	"<Down>",
	"<cmd>resize -2<CR>",
	{ desc = "Decrease window height", silent = true }
)

-- treat overflowing text as having line breaks, useful when `set wrap` is true
map("n", "j", "v:count ? 'j' : 'gj'", { expr = true, silent = true })
map("n", "k", "v:count ? 'k' : 'gk'", { expr = true, silent = true })
map("x", "j", "v:count ? 'j' : 'gj'", { expr = true, silent = true })
map("x", "k", "v:count ? 'k' : 'gk'", { expr = true, silent = true })

-- used to quickly move lines up and down. accepts a count, so 2<leader>j will
-- move it two lines down and also works in visual selection mode
map(
	"n",
	"<leader>j",
	":<c-u>execute 'move +' . v:count1<CR>",
	{ desc = "Move line up", silent = true }
)
map(
	"n",
	"<leader>k",
	":<c-u>execute 'move --' . v:count1<CR>",
	{ desc = "Move line down", silent = true }
)
map(
	"x",
	"<leader>j",
	":<c-u>execute \"'<,'>move'>+\" . v:count1 <CR>gv",
	{ desc = "Move line up", silent = true }
)
map(
	"x",
	"<leader>k",
	":<c-u>execute \"'<,'>move'<--\" . v:count1 <CR>gv",
	{ desc = "Move line down", silent = true }
)

-- better behavior for search
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map(
	"n",
	"n",
	"'Nn'[v:searchforward]",
	{ expr = true, desc = "Next search result" }
)
map(
	"x",
	"n",
	"'Nn'[v:searchforward]",
	{ expr = true, desc = "Next search result" }
)
map(
	"o",
	"n",
	"'Nn'[v:searchforward]",
	{ expr = true, desc = "Next search result" }
)
map(
	"n",
	"N",
	"'nN'[v:searchforward]",
	{ expr = true, desc = "Prev search result" }
)
map(
	"x",
	"N",
	"'nN'[v:searchforward]",
	{ expr = true, desc = "Prev search result" }
)
map(
	"o",
	"N",
	"'nN'[v:searchforward]",
	{ expr = true, desc = "Prev search result" }
)

-- don't lose selection when shifting identation
map("x", "<", "<gv")
map("x", ">", ">gv")

-- don't move the cursor when yanking
-- See http://ddrscott.github.io/blog/2016/yank-without-jank/
map("v", "y", '"' .. 'my\\"" . v:register . "y`y' .. '"', { expr = true })
--

-- mark the current line and add a line at the beggining and end of the file
map("n", "<leader>o", "moGGo", "Add line at beginning of buffer")
map("n", "<leader>O", "mOggO", "Add line at the end of buffer")

-- easier navigation in line - H goes to the start, L goes to the end
map("n", "H", "^", "Move cursor to start of the line")
map("n", "L", "$", "Move cursor to end of the line")

-- Make better undo chunks when writing long texts (prose) without exiting insert mode.
-- :h i_CTRL-G_u
-- https://twitter.com/vimgifs/status/913390282242232320
map("i", ".", ".<c-g>u")
map("i", "?", "?<c-g>u")
map("i", "!", "!<c-g>u")
map("i", ",", ",<c-g>u")

-- Use CTRL+[MNEI] to navigate between panes, instead of CTRL+W CTRL+[HJKL]
map("n", "<leader>m", "<C-w><C-h>", "Go to left pane")
map("n", "<leader>n", "<C-w><C-j>", "Go to bottom pane")
map("n", "<leader>e", "<C-w><C-k>", "Go to top pane")
map("n", "<leader>i", "<C-w><C-l>", "Go to right pane")

-- Use | to split window vertically and _ to split it horizontally
map(
	"n",
	"<Bar>",
	'v:count == 0 ? "<C-W>v<C-W>l" : ":<C-U>normal! 0".v:count."<Bar><CR>"',
	{ expr = true, silent = true, desc = "Split pane vertically" }
)
map(
	"n",
	"_",
	'v:count == 0 ? "<C-W>s<C-W>k" : ":<C-U>normal! 0".v:count."_<CR>"',
	{ expr = true, silent = true, desc = "Split pane horizontally" }
)

-- List current buffers to cycle, but only if telescope is not installed
if not Idle.has_plugin("telescope.nvim") then
	map("n", "<tab>", ":silent ls<CR>:b<space>", "Show buffer switcher")
end

-- repeat last macro (use qq to record, @q to run the first time and Q to run it
map("n", "Q", "@@", "Repeat last macro")

-- avoid overwriting the register when pasting (allow to past multiple times)
map("x", "p", '"_dP')

-- Insert before current word under the cursor
map("n", "<leader>I", "bi", "Insert before current word")

-- Insert after current word under the cursor
map("n", "<leader>A", "ea", "Insert after current word")

-- make <leader>q exit terminal mode when in terminal, of course
map("t", "<Leader>q", "<C-\\><C-n>")

-- make <leader>Q quit neovim
map(
	"n",
	"<leader>Q",
	'&diff ? ":windo bd<CR>" : ":quit<CR>"',
	{ expr = true, silent = true, desc = "Quit" }
)

map("n", "<leader>bn", "<cmd>bnext<CR>", "Next buffer")
map("n", "<leader>bp", "<cmd>bprevious<CR>", "Previous buffer")
map("n", "<leader>gg", "<cmd>Git<CR>", "Lazygit (root)")
map("n", "<leader>gG", "<cmd>Git!<CR>", "Lazygit (cwd)")
map("n", "<leader>tt", "<cmd>Term<CR>", "Open Terminal (root)")
map("n", "<leader>tT", "<cmd>Term!<CR>", "Open Terminal (cwd)")
map("n", "<leader>xl", function()
	if vim.g.qfix_win then
		vim.cmd.cclose()
		vim.g.qfix_win = nil
	else
		vim.cmd.copen()
		---@diagnostic disable-next-line param-type-mismatch
		vim.g.qfix_win = vim.fn.bufnr("$")
	end
end, "Toggle quickfix list")
