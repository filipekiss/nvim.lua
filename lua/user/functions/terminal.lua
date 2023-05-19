local Terminal = {}

Terminal.is_open = false
Terminal.float_term = nil

function Terminal.float(cmd, opts)
	opts = vim.tbl_deep_extend("force", {
		size = { width = 0.9, height = 0.9 },
	}, opts or {})
	local float = require("lazy.util").float_term(cmd, opts)
	Terminal.float_term = float
	Terminal.is_open = true
	if opts.esc_esc == false then
		vim.keymap.set(
			"t",
			"<esc>",
			"<esc>",
			{ buffer = float.buf, nowait = true }
		)
	end
end

function Terminal.create_remote_terminal_autocmd()
	if Terminal.is_open and vim.fn.executable("nvr") then
		local augroup = require("idle.helpers.autocmd").augroup
		local autocmd = require("idle.helpers.autocmd").autocmd
		autocmd({ "BufUnload" }, {
			group = augroup("RemoteTerminal", true),
			buffer = vim.api.nvim_get_current_buf(),
			callback = function()
				local root =
					require("user.functions.rooter").get_project_dir().path
				vim.schedule(function()
					require("user.functions").float_term(nil, { cwd = root })
				end)
				Terminal.is_open = false
			end,
		})
	end
end

return Terminal
