return {
	-- Status line (Tokyo Night theme)
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				theme = "tokyonight",
				globalstatus = true,
				component_separators = "",
				section_separators = "",
			},
		},
	},

	-- Press <leader> and wait: shows what keys are available
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			spec = {
				{ "<leader>f", group = "find" },
				{ "<leader>c", group = "code" },
				{ "<leader>h", group = "git hunks" },
				{ "<leader>b", group = "buffer" },
			},
		},
	},
}
