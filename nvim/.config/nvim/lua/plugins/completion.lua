return {
	{
		"saghen/blink.cmp",
		version = "1.*", -- pinned to the 1.x releases so prebuilt binaries are downloaded
		dependencies = { "rafamadriz/friendly-snippets" },
		event = { "InsertEnter", "CmdlineEnter" },
		---@module 'blink.cmp'
		opts = {
			-- "enter": <CR> accepts, <C-n>/<C-p> or arrows to pick, <C-e> closes.
			keymap = { preset = "enter" },
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 300 },
			},
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			signature = { enabled = true },
		},
	},
}
