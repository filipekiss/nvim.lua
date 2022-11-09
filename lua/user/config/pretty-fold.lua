local content = require("pretty-fold.components").content
return {
	fill_char = "-",
	sections = {
		left = {
			function(config)
				local c = content(config)
				return c:gsub("^%s*(.-)%s*$", "%1")
			end,
		},
		right = {
			" ",
			"number_of_folded_lines",
			": ",
			"percentage",
			" ",
			function(config)
				return config.fill_char:rep(3)
			end,
		},
	},
}
