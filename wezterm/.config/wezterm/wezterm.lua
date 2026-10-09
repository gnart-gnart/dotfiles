-- ~/.config/wezterm/wezterm.lua
-- Tokyo Night · Maple Mono · borderless · blurred · tmux handles tabs/panes.
local wezterm = require("wezterm")
local config = wezterm.config_builder()

local is_mac = wezterm.target_triple:find("darwin") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil

-- ── Font ───────────────────────────────────────────────────────────────
-- "Maple Mono NF" is the Nerd Font build (icons included). Falls back to
-- JetBrains Mono if Maple isn't installed yet.
config.font = wezterm.font_with_fallback({
	"Maple Mono",
	"Maple Mono NF",
	"JetBrains Mono",
})
config.font_size = is_mac and 14.0 or 12.0
config.line_height = 1.05
config.adjust_window_size_when_changing_font_size = false

-- ── Colors (Tokyo Night, "night" variant) ──────────────────────────────
config.colors = {
	foreground = "#c0caf5",
	background = "#1a1b26",
	cursor_bg = "#c0caf5",
	cursor_fg = "#1a1b26",
	cursor_border = "#c0caf5",
	selection_fg = "#c0caf5",
	selection_bg = "#33467c",
	scrollbar_thumb = "#292e42",
	split = "#292e42",
	ansi = {
		"#15161e", -- black
		"#f7768e", -- red
		"#9ece6a", -- green
		"#e0af68", -- yellow
		"#7aa2f7", -- blue
		"#bb9af7", -- magenta
		"#7dcfff", -- cyan
		"#a9b1d6", -- white
	},
	brights = {
		"#414868",
		"#f7768e",
		"#9ece6a",
		"#e0af68",
		"#7aa2f7",
		"#bb9af7",
		"#7dcfff",
		"#c0caf5",
	},
}

-- ── Window: borderless, translucent, blurred ───────────────────────────
-- "RESIZE" removes the title bar but keeps edge-resizing.
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
if is_linux then
	-- KDE blur-behind (only exists in WezTerm nightly; pcall keeps older builds from erroring)
	pcall(function()
		config.kde_window_background_blur = true
	end)
end
config.window_padding = { left = 16, right = 16, top = 12, bottom = 8 }
config.window_close_confirmation = "NeverPrompt"
config.initial_cols = 130
config.initial_rows = 36

-- tmux provides tabs and panes, so WezTerm's tab bar stays hidden.
config.enable_tab_bar = false

-- ── Behavior ───────────────────────────────────────────────────────────
config.scrollback_lines = 5000 -- tmux keeps its own, bigger history
config.audible_bell = "Disabled"
config.hide_mouse_cursor_when_typing = true
config.default_cursor_style = "SteadyBlock"
config.check_for_updates = false
config.max_fps = 120

if is_mac then
	-- Left Option acts as Alt (for tmux/nvim bindings); right Option still types special characters.
	config.send_composed_key_when_left_alt_is_pressed = false
	config.send_composed_key_when_right_alt_is_pressed = true
end

-- Shell: WezTerm launches your login shell (zsh). The tmux auto-attach lives
-- in ~/.zshrc so it works the same on both machines.

return config
