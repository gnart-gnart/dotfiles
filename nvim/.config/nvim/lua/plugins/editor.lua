return {
	-- Ctrl-h/j/k/l move between Neovim splits AND tmux panes (pairs with the tmux plugin)
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},

	-- File explorer that works like a normal buffer: "-" opens the parent directory
	{
		"stevearc/oil.nvim",
		lazy = false,
		keys = {
			{ "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
			{ "<leader>e", "<cmd>Oil<CR>", desc = "File explorer" },
		},
		opts = {
			default_file_explorer = true,
			view_options = { show_hidden = true },
			-- free up Ctrl-h / Ctrl-l for tmux navigation
			keymaps = {
				["<C-h>"] = false,
				["<C-l>"] = false,
			},
		},
	},

	-- Auto-close brackets and quotes
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	-- Git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				local function map(keys, fn, desc)
					vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = "Git: " .. desc })
				end
				map("]h", function() gs.nav_hunk("next") end, "Next hunk")
				map("[h", function() gs.nav_hunk("prev") end, "Previous hunk")
				map("<leader>hp", gs.preview_hunk, "Preview hunk")
				map("<leader>hs", gs.stage_hunk, "Stage hunk")
				map("<leader>hr", gs.reset_hunk, "Reset hunk")
				map("<leader>hb", gs.blame_line, "Blame line")
			end,
		},
	},
}
