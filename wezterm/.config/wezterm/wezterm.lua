local wt = require "wezterm"

local is_windows = wt.target_triple:match "windows" ~= nil
local is_macos = wt.target_triple:match "darwin" ~= nil

-- Utility functions -----------------------------------------------------------

-- Join list of arguments into a path separated by the correct path seperator
local function join(...)
  local sep = is_windows and [[\]] or "/"
  return table.concat({ ... }, sep)
end

-- Equivalent to POSIX basename(3)
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Paths / Config files --------------------------------------------------------

local confighome = wt.config_dir

-- Events ----------------------------------------------------------------------

local window_opacity = 0.90

wt.on("toggle-opacity", function(window, _)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = window_opacity
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

wt.on("increase-opacity", function(window, _)
  window_opacity = window_opacity + 0.05
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity then
    overrides.window_background_opacity = window_opacity
    window:set_config_overrides(overrides)
  end
end)

wt.on("decrease-opacity", function(window, _)
  window_opacity = window_opacity - 0.05
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity then
    overrides.window_background_opacity = window_opacity
    window:set_config_overrides(overrides)
  end
end)

wt.on("user-var-changed", function(window, _, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "theme" then
    overrides.color_scheme = value
    if string.match(value, "light$") or string.match(value, "dark$") then
      overrides.window_background_opacity = nil
    else
      overrides.window_background_opacity = window_opacity
    end
  end
  window:set_config_overrides(overrides)
end)

wt.on("reset-color-state", function(window, _)
  local overrides = window:get_config_overrides() or {}
  overrides.color_scheme = "carbon"
  overrides.window_background_opacity = window_opacity
  overrides.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
  overrides.integrated_title_buttons = { "Close" }
  window:set_config_overrides(overrides)
end)

-- Config table ---------------------------------------------------------------

local config = {
  audible_bell = "Disabled",
  check_for_updates = true,

  default_cursor_style = "BlinkingBar",
  cursor_blink_rate = 350,
  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",

  color_scheme_dirs = {
    join(confighome, "colors"),
  },

  enable_wayland = not (is_windows or is_macos),
  enable_kitty_keyboard = true,

  exit_behavior = "Close",

  font = wt.font("Terminess Nerd Font Mono", { weight = "Regular" }),

  front_end = "WebGpu",
  webgpu_power_preference = "LowPower",

  font_rules = {
    {
      intensity = "Bold",
      italic = false,
      font = wt.font("Terminess Nerd Font Mono", { weight = "Bold" }),
    },
  },

  font_size = is_windows and 14 or 22,
  initial_rows = 37,

  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = false,
  show_new_tab_button_in_tab_bar = true,
  tab_bar_at_bottom = false,

  leader = is_macos and { key = "q", mods = "CMD", timeout_milliseconds = 1000 } or
  { key = "q", mods = "CTRL", timeout_milliseconds = 1000 },

  keys = {
    {
      key = 'q',
      mods = 'CMD',
      action = wt.action.DisableDefaultAssignment,
    },

    {
      key = 'Enter',
      mods = 'OPT',
      action = wt.action.SpawnCommandInNewWindow {}
    },

    -- Event handlers
    { key = "\\", mods = "ALT",          action = "ShowLauncher" },
    { key = "t",  mods = "CTRL|ALT",     action = wt.action.EmitEvent "toggle-opacity" },
    { key = "t",  mods = "SUPER|ALT",    action = wt.action.EmitEvent "toggle-opacity" },
    { key = "=",  mods = "CTRL|ALT",     action = wt.action.EmitEvent "increase-opacity" },
    { key = "=",  mods = "SUPER|ALT",    action = wt.action.EmitEvent "increase-opacity" },
    { key = "-",  mods = "CTRL|ALT",     action = wt.action.EmitEvent "decrease-opacity" },
    { key = "-",  mods = "SUPER|ALT",    action = wt.action.EmitEvent "decrease-opacity" },
    { key = "b",  mods = "CTRL",         action = wt.action.EmitEvent "reset-color-state" },

    -- Multiplexing
    { key = "|",  mods = "LEADER|SHIFT", action = wt.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "-",  mods = "LEADER",       action = wt.action.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "n",  mods = "LEADER",       action = wt.action.ActivateTabRelative(1) },
    { key = "p",  mods = "LEADER",       action = wt.action.ActivateTabRelative(-1) },
    { key = "c",  mods = "LEADER",       action = wt.action.SpawnTab "CurrentPaneDomain" },
    {
      key = ",",
      mods = "LEADER",
      action = wt.action.PromptInputLine {
        description = "Enter new tab name",
        action = wt.action_callback(function(window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
  },

  term = (not is_windows) and "wezterm" or "xterm-256color",

  window_padding = {
    left = 25,
    right = 25,
    top = 20,
    bottom = 5,
  },
}

-- Windows ---------------------------------------------------------------------

local function windows_launch_menu()
  local launch_menu = { {
    label = "Powershell",
    args = { "powershell.exe", "-NoLogo" },
  } }

  local _, wsl_list, _ = wt.run_child_process { "wsl.exe", "-l" }
  wsl_list = wt.utf16_to_utf8(wsl_list)

  for idx, line in ipairs(wt.split_by_newlines(wsl_list)) do
    if idx > 1 then
      local distro = line:gsub(" %(Default%)", "")
      if not distro:find "^docker" then
        table.insert(launch_menu, {
          label = distro,
          args = { "wsl.exe", "--distribution", distro },
        })
      end
    end
  end

  return launch_menu
end

if is_macos then
  config.set_environment_variables = {
    XDG_CONFIG_HOME = os.getenv "HOME" .. "/.config",
  }
  config.window_decorations = "RESIZE"
end

if is_windows then
  config.launch_menu = windows_launch_menu()
  config.default_prog = { "powershell.exe", "-NoLogo" }
elseif is_macos then
  config.default_prog = { "/opt/homebrew/bin/nu", "-l" }
else
  config.default_prog = { "/home/cross/.cargo/bin/nu", "-l" }
end

return config
