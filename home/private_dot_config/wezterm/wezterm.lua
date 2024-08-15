local wezterm = require 'wezterm'

local act = wezterm.action
local config = wezterm.config_builder()

config.enable_tab_bar = false -- Use tmux for tabs

config.font = wezterm.font 'Hack'
config.font_size = 16.0

config.color_scheme = 'Jellybeans'

config.window_background_opacity = 0.95

-- Copy/paste with right mouse button
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act.PasteFrom("Clipboard"), pane)
      end
    end),
  },
}

-- https://github.com/wez/wezterm/issues/5612
config.front_end = "WebGpu"

return config
