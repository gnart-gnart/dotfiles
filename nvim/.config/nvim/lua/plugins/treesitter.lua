-- Syntax highlighting via tree-sitter.
--
-- nvim-treesitter's maintained "main" branch needs Neovim >= 0.12 plus the
-- `tree-sitter` CLI (>= 0.26.1) and a C compiler. On Neovim 0.11 we fall back
-- to the frozen "master" branch, which works without the CLI. The config below
-- handles both, so the same dotfiles work on Fedora 43 and Fedora 44+/macOS.

local use_main = vim.fn.has("nvim-0.12") == 1

local languages = {
	"bash", "c", "cpp", "c_sharp", "java", "python",
	"javascript", "typescript", "html", "css", "json", "yaml", "toml",
	"lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
	"regex", "make", "cmake", "diff", "gitcommit",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = use_main and "main" or "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			if use_main then
				if vim.fn.executable("tree-sitter") == 0 then
					vim.notify(
						"nvim-treesitter needs the `tree-sitter` CLI (>= 0.26.1). Install tree-sitter-cli.",
						vim.log.levels.WARN
					)
				else
					require("nvim-treesitter").install(languages)
				end
				-- Turn on highlighting whenever a parser exists for the buffer
				vim.api.nvim_create_autocmd("FileType", {
					group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
					callback = function()
						pcall(vim.treesitter.start)
					end,
				})
			else
				require("nvim-treesitter.configs").setup({
					ensure_installed = languages,
					auto_install = true,
					highlight = { enable = true },
					indent = { enable = true },
				})
			end
		end,
	},
}
