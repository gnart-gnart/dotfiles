return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000, -- load before everything else
		opts = {
			style = "night",
			-- Let WezTerm's 0.9 opacity + blur show through Neovim too.
			-- Set to false for a solid background.
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
