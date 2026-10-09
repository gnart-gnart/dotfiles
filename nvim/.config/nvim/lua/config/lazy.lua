-- Bootstrap lazy.nvim (installs itself on first launch)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Every file in lua/plugins/ is loaded as plugin specs.
-- lazy-lock.json (next to init.lua) pins exact plugin versions: commit it.
require("lazy").setup({
	spec = { { import = "plugins" } },
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = false },
	change_detection = { notify = false },
	rocks = { enabled = false },
	ui = { border = "rounded" },
})
