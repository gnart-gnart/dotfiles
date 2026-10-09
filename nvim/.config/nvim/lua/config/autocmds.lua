local augroup = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Flash yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- 2-space indentation for web files and Lua
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "javascript", "typescript", "html", "css", "json", "yaml", "lua" },
	callback = function()
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
	end,
})

-- Reopen files at the last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local lines = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= lines then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
