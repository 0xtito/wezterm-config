local wezterm = require("wezterm")
local rp = require("rose_pine")

-- Constants
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- Configuration
local config = wezterm.config_builder()

-- Leader key
config.leader = (wezterm.target_triple == "x86_64-pc-windows-msvc") and { key = ",", mods = "ALT" }
	-- config.leader = (wezterm.target_triple == "x86_64-pc-windows-msvc") and { key = "", mods = "ALT" }
	or { key = ",", mods = "SUPER" }

-- General settings
config.force_reverse_video_cursor = true
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.audible_bell = "Disabled"
config.check_for_updates = false
config.font = wezterm.font("JetBrains Mono NL")
config.color_scheme = "rose-pine"
config.inactive_pane_hsb = { hue = 1.0, saturation = 1.0, brightness = 1.0 }
config.font_size = 14.0
config.launch_menu = {}
config.window_padding = { left = 2, right = 2, top = 0, bottom = 0 }
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.disable_default_key_bindings = true

-- Colors
config.colors = {
	tab_bar = {
		background = rp.colors.base,
		new_tab = { bg_color = rp.colors.overlay, fg_color = rp.colors.text },
	},
}

-- Key bindings
local function define_key_bindings()
	local keys = {
		{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
		{ key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{
			key = "\\",
			mods = "LEADER",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
		{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{
			key = "!",
			mods = "LEADER | SHIFT",
			action = wezterm.action_callback(function(win, pane)
				pane:move_to_new_tab()
			end),
		},
		{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
		{ key = "t", mods = "SHIFT|CTRL", action = "ShowTabNavigator" },
		{ key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
		{ key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
		{ key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "c", mods = "SHIFT|CTRL", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "+", mods = "SHIFT|CTRL", action = "IncreaseFontSize" },
		{ key = "_", mods = "SHIFT|CTRL", action = wezterm.action.DecreaseFontSize },
		{ key = "=", mods = "LEADER|CTRL", action = "ResetFontSize" },
	}

	-- Add tab activation keys
	for i = 1, 9 do
		table.insert(keys, { key = tostring(i), mods = "LEADER", action = wezterm.action({ ActivateTab = i - 1 }) })
	end

	-- Add rename tab key
	table.insert(keys, {
		key = "E",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	})

	return keys
end

config.keys = define_key_bindings()

-- Adding MoveTab from: https://wezfurlong.org/wezterm/config/lua/keyassignment/MoveTab.html?h=move
for i = 1, 8 do
	-- CTRL+ALT + number to move to that position
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL|ALT",
		action = wezterm.action.MoveTab(i - 1),
	})
end

-- Event handlers
wezterm.on("format-window-title", function()
	return string.format("[%s] %s - $W", wezterm.mux.get_active_workspace(), wezterm.mux.get_domain():name())
end)

-- NOTE: Args are: tab, tabs, panes, config, hover, max_width
wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
	local title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title or tab.active_pane.title
	local index = tab.tab_index + 1
	local colors = rp.active and rp.colors
		or {
			base = "#0b0022",
			surface = "#2b2042",
			overlay = "#1b1032",
			text = "#A9A6AC",
			muted = "#66646C",
		}

	local function create_tab_title(bg, fg, text_color)
		return {
			{ Background = { Color = colors.base } },
			{ Foreground = { Color = bg } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = bg } },
			{ Foreground = { Color = text_color } },
			{ Text = string.format(" %d| %s ", index, title) },
			{ Background = { Color = colors.base } },
			{ Foreground = { Color = bg } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	end

	return tab.is_active and create_tab_title(colors.surface, colors.text, colors.text)
		or create_tab_title(colors.overlay, colors.muted, colors.muted)
end)

wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
	window:gui_window():toggle_fullscreen()
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental then
			for _ = 1, number_value do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("update-right-status", function(window, pane)
	-- local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
	local date = wezterm.strftime("%H:%M:%S")
	local colors = rp.colors

	window:set_right_status(wezterm.format({
		{ Background = { Color = colors.base } },
		-- { Foreground = { Color = colors.rose } },
		{ Attribute = { Italic = true } },
		-- { Text = " " .. window:active_workspace() .. " " },
		-- { Foreground = { Color = colors.subtle } },
		-- { Text = "│ " },
		{ Foreground = { Color = colors.rose } },
		{ Text = date .. " " },
	}))
end)

-- Platform-specific configurations
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(config.launch_menu, { label = "PowerShell", args = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" } })
	config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-l" }
end

-- Unix domains
config.unix_domains = {
	{ name = "usual" },
	{ name = "config" },
	{ name = "godot", socket_path = "C:\\Users\\tito\\.local\\share\\wezterm\\godot" },
}

return config
