local o = vim.o

-- Line numbers
o.number = true
o.relativenumber = true

-- Look & feel
o.termguicolors = true
o.cursorline = true
o.signcolumn = "yes"
o.scrolloff = 8
o.wrap = false
o.winborder = "rounded" -- rounded floating windows (Neovim 0.11+)
o.showmode = false -- lualine already shows the mode

-- Behavior
o.mouse = "a"
o.undofile = true
o.updatetime = 250
o.timeoutlen = 400
o.splitright = true
o.splitbelow = true
o.confirm = true
o.inccommand = "split" -- live preview for :s

-- Search
o.ignorecase = true
o.smartcase = true

-- Indentation: 4 spaces by default (2 for web/lua, see autocmds.lua)
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true

-- Share the system clipboard (needs wl-clipboard/xclip on Linux, pbcopy on macOS)
vim.schedule(function()
	o.clipboard = "unnamedplus"
end)
