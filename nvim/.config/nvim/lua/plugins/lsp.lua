-- Language servers: Mason installs them, Neovim 0.11's built-in LSP client runs them.
--
--   Python      pyright + ruff        C / C++    clangd
--   Java        jdtls (needs a JDK)   C#         csharp_ls (needs the .NET SDK)
--   JS / TS     ts_ls                 HTML / CSS html, cssls
--   Bash        bashls                Lua        lua_ls (for editing this config)
--
-- Several of these run on Node, so keep nodejs + npm installed.

return {
	{
		"mason-org/mason.nvim",
		opts = { ui = { border = "rounded" } },
	},

	{
		"neovim/nvim-lspconfig", -- ships the default server definitions
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			-- Completion capabilities for every server
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			-- Per-server tweaks
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})
			-- ruff does linting/formatting; leave hover to pyright
			vim.lsp.config("ruff", {
				on_attach = function(client)
					client.server_capabilities.hoverProvider = false
				end,
			})

			-- Install the servers and auto-enable every one Mason has installed
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ruff",
					"clangd",
					"jdtls",
					"csharp_ls",
					"ts_ls",
					"html",
					"cssls",
					"bashls",
				},
				automatic_enable = true,
			})

			-- Keymaps, set only when a server attaches to a buffer.
			-- Neovim 0.11 already provides: K (hover), grn (rename), gra (code action),
			-- grr (references), gri (implementation), gO (symbols), [d / ]d (diagnostics).
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
				callback = function(ev)
					local function map(keys, fn, desc)
						vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
					end
					map("gd", vim.lsp.buf.definition, "Go to definition")
					map("gD", vim.lsp.buf.declaration, "Go to declaration")
					map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
				end,
			})

			vim.diagnostic.config({
				virtual_text = { spacing = 2, prefix = "●" },
				severity_sort = true,
				float = { border = "rounded" },
			})
		end,
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		lazy = true,
	},

	-- Formatters / linters that aren't language servers
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"clang-format",
				"prettier",
				"shfmt",
				"google-java-format",
				"shellcheck",
			},
		},
	},
}
