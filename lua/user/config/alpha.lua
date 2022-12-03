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
	val = "<leader> = " .. translate_key(vim.g.mapleader),
	opts = {
		position = "center",
		hl = "Number",
	},
}

local repo = {
	type = "text",
	val = "https://github.com/filipekis/nebula",
	opts = {
		position = "center",
		hl = "Number",
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
}

local config = {
	layout = {
		{ type = "padding", val = 2 },
		section.header,
		{ type = "padding", val = 2 },
		section.buttons,
		section.footer,
		section.repo,
	},
	opts = {
		margin = 5,
	},
}

return config
