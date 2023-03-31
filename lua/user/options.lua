local opt = vim.opt

opt.clipboard = "unnamedplus" -- make use of the system clipboard
opt.colorcolumn = "80" -- show a column at 80 chars (it must be a string)
opt.cursorline = true -- show cursorline
opt.foldlevelstart = 99 -- start with all folds open
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- make search smarter. if all lowercase, ignore it, but if you add any uppercase letter, becomes case sensitive
opt.mouse = "a" -- allow the mouse to work
opt.showmode = false -- don't show -- INSERT --  or other modes in the status bar
opt.number = true -- show line numbers
opt.numberwidth = 4 -- set number column width to 4
opt.pumheight = 10 -- set the maximum number of items to show in the completion menu
opt.relativenumber = false -- disable relative numbers by default
opt.scrolloff = 40 -- the amount of lines that surround the cursorline
opt.sidescrolloff = 8 -- same as above, but for horizontal movement
opt.shiftwidth = 2 -- use 2 spaces when indenting
opt.shortmess:append({
	A = true, -- don't give the "ATTENTION" message when an existing swap file is found.
	F = true, -- don't give the file info when editing a file, like `:silent` was used for the command; note that this also affects messages from autocommands
	I = true, -- don't give the intro message when starting Vim |:intro|.
	O = true, -- message for reading a file overwrites any previous message. Also for quickfix message (e.g., ":cn").
	T = true, -- truncate other messages in the middle if they are too long to fit on the command line.  "..." will appear in the middle. Ignored in Ex mode.
	W = true, -- don't give "written" or "[w]" when writing a file
	a = true, -- same as applying `filmnrwx` to shortmess. See :h shortmess for more info
	c = true, -- don't give |ins-completion-menu| messages.  For example, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
	o = true, -- overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when 'autowrite' on)
	t = true, -- truncate file message at the start if it is too long to fit on the command-line, "<" will appear in the left most column. Ignored in Ex mode.
})
opt.signcolumn = "yes" -- always show the sign column to avoid text shifting
opt.smartindent = true -- try to keep indentation correct when pressing enter/return
opt.splitbelow = true -- new horizontal splits on the bottom
opt.splitright = true -- new vertical splits on the right
opt.tabstop = 2 -- use 2 spaces for a tab
opt.termguicolors = true -- use true colors
opt.textwidth = 80 -- wrap text at 80 chars
opt.undofile = true -- undo persist even if you close the file
opt.wrap = false -- don't wrap text, make it a long line
opt.wildmenu = true -- enhanced tab completion for the ex command line
opt.wildmode =
	"full:longest,list,full", -- complete the longest common part of the word
	opt.wildignore:append({ -- When completing a command, ignore files that are…
		".hg,.git,.svn", -- …from Version control
		"*.jpg,*.bmp,*.gif,*.png,*.jpeg", -- …binary images
		"*.o,*.obj,*.exe,*.dll,*.manifest", -- …compiled object files
		"*.spl", -- …compiled spelling word lists
		"*.sw?", -- …Vim swap files
		"*.DS_Store", -- …OSX bullshit
		"*.pyc", -- …Python byte code
		"*.orig", -- …merge resolution files
		"*.rbc,*.rbo,*.gem", -- …compiled stuff from Ruby
		"*/vendor/*,*/.bundle/*,*/.sass-cache/*", -- …vendor files
		"*/node_modules/*", -- …JavaScript modules
		"package-lock.json", -- …package-lock.json
		"tags", -- …(c)tags files
	})
