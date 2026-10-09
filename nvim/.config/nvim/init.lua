-- ~/.config/nvim/init.lua
-- Kickstart-style config on lazy.nvim. Needs Neovim >= 0.11.

if vim.fn.has("nvim-0.11") == 0 then
	vim.api.nvim_echo({
		{ "This config needs Neovim >= 0.11 (you have " .. tostring(vim.version()) .. ").\n", "ErrorMsg" },
		{ "Update Neovim, then restart.", "Normal" },
	}, true, {})
	return
end

-- Leaders must be set before plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
