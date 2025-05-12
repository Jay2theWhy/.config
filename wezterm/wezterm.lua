-- Pull in the wezterm API
local wezterm = require("wezterm")

-- TODO: cannot find file
-- local quietLight = wezterm.color.load_scheme("colors/quiet_light.toml")

-- Functions
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end

	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Gruvbox dark, hard (base16)"
	else
		return "Builtin Solarized Light"
	end
end

local function colors_for_appearance(appearance)
	return {
		background = "rgba(44, 73, 65, 0.75)",
		tab_bar = {
			background = "rgba(44, 73, 65, 0.75)",
		},
	}
end

local function get_window_decorations()
	if wezterm.target_triple:match("darwin") or wezterm.target_triple:match("linux") then
		return "RESIZE"
	else
		return "RESIZE | TITLE"
	end
end

local function get_default_domain()
	if wezterm.target_triple:match("darwin") or wezterm.target_triple:match("linux") then
		return nil
	else
		return "WSL:Ubuntu"
	end
end

-- This will hold the configuration.
local config = wezterm.config_builder()
-- This is where you actually apply your config choices

-- Appearance, colors, and themes
config.font_size = 14
config.font = wezterm.font("JetBrainsMono Nerd Font")
local appearance = get_appearance()
config.colors = colors_for_appearance(appearance)
config.color_scheme = scheme_for_appearance(appearance)
config.window_decorations = get_window_decorations()

-- Window and tab configs
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.line_height = 1.1
config.window_padding = {
	top = 0,
	bottom = 0,
	right = 0,
	left = 0,
}
config.window_background_opacity = 0.9
config.macos_window_background_blur = 15

-- custom keys
config.keys = {
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	},
	{ key = "k", mods = "CMD", action = wezterm.action.ScrollByLine(-1) },
	{ key = "j", mods = "CMD", action = wezterm.action.ScrollByLine(1) },
}

config.default_domain = get_default_domain()

-- and finally, return the configuration to wezterm
return config
