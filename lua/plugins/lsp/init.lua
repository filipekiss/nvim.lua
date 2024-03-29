return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"neoconf.nvim",
			"mason.nvim",
			"mason-lspconfig.nvim",
			{
				"https://github.com/folke/neodev.nvim",
				opts = { experimental = { pathStrict = true } },
			}, -- used to develop plugins and give context awareness to vim config globals
			"nvim-navbuddy",
		},
		opts = {
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
						},
					},
				},
				tsserver = {
					settings = {
						javascript = {
							format = {
								indentSize = vim.o.shiftwidth,
								convertTabsToSpaces = vim.o.expandtab,
								tabSize = vim.o.tabstop,
							},
						},
						typescript = {
							format = {
								indentSize = vim.o.shiftwidth,
								convertTabsToSpaces = vim.o.expandtab,
								tabSize = vim.o.tabstop,
							},
						},
						completions = {
							completeFunctionCalls = true,
						},
					},
				},
			},
			setup = {},
		},
		config = function(_, opts)
			Idle.load("functions.lsp").attach_autocmd(function(client, buffer)
				require("plugins.lsp.keymaps").on_attach(client, buffer)
				require("plugins.lsp.format").on_attach(client, buffer)
			end)

			-- diagnostics
			for name, icon in pairs(Idle.options.icons.diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(
					name,
					{ text = icon, texthl = name, numhl = "" }
				)
			end

			local servers = opts.servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local function setup(server)
				local server_opts = {
					capabilities = vim.deepcopy(capabilities),
				}
				-- check if a file exists in
				-- lua/<namespace>/lsp/server/<server-name>.lua
				local settings_file = "lsp.server." .. server
				if
					Idle.load(
						settings_file,
						{ silent = not Idle.options.debug }
					)
				then
					local server_opts_from_file = Idle.load(settings_file)
					server_opts = vim.tbl_deep_extend(
						"force",
						server_opts,
						server_opts_from_file
					)
				else
					server_opts = vim.tbl_deep_extend(
						"force",
						server_opts,
						servers[server] or {}
					)
				end

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			local mlsp = Idle.safe_require("mason-lspconfig")

			if mlsp then
				mlsp.setup({
					ensure_installed = opts.ensure_installed,
				})
				mlsp.setup_handlers({ setup })
			end
		end,
	},
	-- mason
	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		config = true,
	},
	-- mason lspconfig
	{
		"https://github.com/williamboman/mason-lspconfig.nvim",
		lazy = true,
		opts = {
			ensure_installed = {
				"lua_ls",
				"tsserver",
				"jsonls",
			},
		},
	},
	-- null-ls
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				root_dir = require("null-ls.utils").root_pattern(
					".null-ls-root",
					".neoconf.json",
					"Makefile",
					".git"
				),
				sources = {
					nls.builtins.formatting.stylua,
					nls.builtins.diagnostics.eslint_d.with({
						prefer_local = "node_modules/.bin",
						condition = function(utils)
							return utils.root_has_file({
								".eslintrc",
								".eslintrc.js",
								".eslintrc.cjs",
								".eslintrc.yaml",
								".eslintrc.yml",
								".eslintrc.json",
							})
						end,
					}),
				},
			}
		end,
	},
}
