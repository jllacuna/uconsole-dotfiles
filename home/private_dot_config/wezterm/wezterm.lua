local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.enable_tab_bar = false -- Use tmux for tabs

config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 16.0

config.color_scheme = 'Jellybeans'

config.window_background_opacity = 0.85

-- https://github.com/wez/wezterm/issues/5612
config.front_end = "WebGpu"

return config
