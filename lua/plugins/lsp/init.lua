return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } }, -- used to develop plugins and give context awareness to vim config globals
		},
		opts = {
		servers = {},
		setup = {},
	},
		config = function(_, opts)
			Idle.load("functions.lsp").attach_autocmd(function(client, buffer)
				require("plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			local servers = opts.servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

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
				mlsp.setup_handlers({setup})
			end
		end,
	},
	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = true,
		opts = {
			ensure_installed = {
				"lua_ls",
				"tsserver",
				"jsonls"
			}
		}
	}
}
