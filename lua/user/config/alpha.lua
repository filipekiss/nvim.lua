local if_nil = vim.F.if_nil

local nebula_art = {
	[[                                            888            ]],
	[[                                            888            ]],
	[[                                            888            ]],
	[[ 88888b.  888  888 888d888 888d888 88888b.  888  .d88b.    ]],
	[[ 888 "88b 888  888 888P"   888P"   888 "88b 888 d8P  Y8b   ]],
	[[ 888  888 888  888 888     888     888  888 888 88888888   ]],
	[[ 888 d88P Y88b 888 888     888     888 d88P 888 Y8b.       ]],
	[[ 88888P"   "Y88888 888     888     88888P"  888  "Y8888    ]],
	[[ 888                               888                     ]],
	[[ 888                               888                     ]],
	[[ 888                               888                     ]],
}

local default_header = {
	type = "text",
	val = nebula_art,
	opts = {
		position = "center",
		hl = "Type",
		-- wrap = "overflow";
	},
}

local translate_key = require("nebula.helpers.mappings").translate

local footer = {
	type = "text",
	val = "<leader> = "
		.. translate_key(vim.g.mapleader)
		.. " | https://github.com/filipekis/nebula",
	opts = {
		position = "center",
		hl = "Comment",
	},
}

local folder = {
	type = "text",
	val = function()
		local folder = vim.fn.expand("%:p:h")
		folder = folder:gsub(os.getenv("HOME"), "~")
		return folder
	end,
	opts = {
		position = "center",
		hl = "String",
	},
}

local leader = vim.g.mapleader

--- @param sc string
--- @param txt string
--- @param keybind string optional
--- @param keybind_opts table optional
local function button(sc, txt, keybind, keybind_opts)
	local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

	local opts = {
		position = "center",
		shortcut = sc,
		cursor = 5,
		width = 50,
		align_shortcut = "right",
		hl_shortcut = "Keyword",
	}
	if keybind then
		keybind_opts = if_nil(
			keybind_opts,
			{ noremap = true, silent = true, nowait = true }
		)
		opts.keymap = { "n", sc_, keybind, keybind_opts }
	end

	local function on_press()
		-- local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
		local key = vim.api.nvim_replace_termcodes(
			sc .. "<Ignore>",
			true,
			false,
			true
		)
		vim.api.nvim_feedkeys(key, "t", false)
	end

	return {
		type = "button",
		val = txt,
		on_press = on_press,
		opts = opts,
	}
end

local last_path = vim.fn.expand("%:p:h:t")

local buttons = {
	type = "group",
	val = {
		button("e", "  New file", "<cmd>ene <CR>"),
		button(
			translate_key(leader, true) .. translate_key(leader, true),
			"  Find file"
		),
		button(
			translate_key(leader, true) .. "fh",
			"  Recently opened files"
		),
		-- button(translate_key(leader, true) .. "fr", "  Frecency/MRU"),
		button(translate_key(leader, true) .. "fg", "  Find word"),
		-- button(translate_key(leader, true) .. "fm", "  Jump to bookmarks"),
		-- get last path of current directory
		button(
			translate_key(leader, true) .. "t",
			"  Browse " .. last_path .. " folder"
		),
		-- button(translate_key(leader, true) .. "sl", "  Open last session"),
		button("q", "  Quit Neovim", "<cmd>quit! <CR>"),
	},
	opts = {
		spacing = 1,
	},
}

local section = {
	header = default_header,
	buttons = buttons,
	footer = footer,
	repo = repo,
	folder = folder,
}

local occupied_lines = 29 -- this is the sum of all sections configure above
local total_sections = 4
local winheight = vim.fn.winheight(0)
-- calculate an even spacing to use based on winheight and occupied_lines and
-- total_sections
local spacing = math.floor((winheight - occupied_lines) / total_sections)
-- calculate the remaining spacing after summing the occupied_lines and the
-- spacing used
local remaining_spacing = math.floor(
	winheight
		- occupied_lines
		- (spacing * (total_sections - 1))
		+ spacing / (total_sections - 1)
)

--[[ local headerPadding = vim.fn.max({ ]]
--[[ 	2, ]]
--[[ 	vim.fn.floor(vim.fn.winheight(0) * marginTopPercent), ]]
--[[ }) ]]

local config = {
	layout = {
		section.header, -- 11
		-- add a padding section
		{ type = "padding", val = spacing },
		section.buttons, -- 23 (12)
		{ type = "padding", val = spacing },
		{ type = "padding", val = spacing },
		section.folder, -- 25
		{ type = "padding", val = remaining_spacing },
		section.footer, -- 26
	},
	opts = {
		margin = 5,
	},
}

return config
