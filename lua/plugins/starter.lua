local pad = string.rep(" ", 2)
-- start screen
return {
	{
		"https://github.com/echasnovski/mini.starter",
		version = false,
		event = "VimEnter",
		opts = function()
			local logo = table.concat({
				"██████╗ ██╗   ██╗██████╗ ██████╗ ██████╗ ██╗     ███████╗",
				"██╔══██╗██║   ██║██╔══██╗██╔══██╗██╔══██╗██║     ██╔════╝",
				"██████╔╝██║   ██║██████╔╝██████╔╝██████╔╝██║     █████╗  ",
				"██╔═══╝ ██║   ██║██╔══██╗██╔══██╗██╔═══╝ ██║     ██╔══╝  ",
				"██║     ╚██████╔╝██║  ██║██║  ██║██║     ███████╗███████╗",
				"╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝╚══════╝",
			}, "\n")
			local new_section = function(name, action, section)
				return {
					name = name,
					action = action,
					section = pad .. section,
				}
			end

			local starter = require("mini.starter")
			local is_git_repo = require("user.functions.git").is_git_repo
      --stylua: ignore
      local config = {
        evaluate_single = true,
        header = logo,
        items = {
					is_git_repo() and new_section("G Open Lazygit", "Git", "Projects") or nil,
          new_section("P Show Projects",    "Telescope projects", "Projects"),
          new_section("N New file",     "ene | startinsert",    "Files"),
          new_section("F Find file",    "Telescope find_files", "Files"),
          new_section("R Recent files", "Telescope oldfiles",   "Files"),
          new_section("T Grep text",    "Telescope live_grep",  "Files"),
          new_section("I init.lua",     "e $MYVIMRC",           "Config"),
          new_section("L Lazy",         "Lazy",                 "Config"),
          new_section("S Session restore", [[lua require("persistence").load()]], "Session"),
          new_section("Q Quit",         "qa",                   "Actions"),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(pad .. "➜ ", false),
          starter.gen_hook.aligning("center", "center"),
        },
      }
			config.footer = ""
			return config
		end,
		config = function(_, config)
			-- close Lazy and re-open when starter is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "MiniStarterOpened",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			local starter = require("mini.starter")
			starter.setup(config)
		end,
	},
}
