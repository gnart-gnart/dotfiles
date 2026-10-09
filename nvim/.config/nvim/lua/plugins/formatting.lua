-- Format with <leader>cf, and automatically on save.
-- Languages without a formatter below (e.g. C#) fall back to their language server.
return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				java = { "google-java-format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				sh = { "shfmt" },
				bash = { "shfmt" },
			},
			format_on_save = { timeout_ms = 1500, lsp_format = "fallback" },
		},
	},
}
