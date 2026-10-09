-- Fuzzy finder. Wants ripgrep (live grep) and fd (faster file listing).
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep in project" },
			{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
			{ "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
			{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
			{ "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in buffer" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					border = true,
					sorting_strategy = "ascending",
					layout_config = { prompt_position = "top" },
				},
			})
			pcall(require("telescope").load_extension, "fzf")
		end,
	},
}
