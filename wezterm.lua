local wezterm = require("wezterm")

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local config = wezterm.config_builder()

local leader

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	leader = { key = ",", mods = "ALT" }
else
	leader = { key = ",", mods = "SUPER" }
end

config = {
	force_reverse_video_cursor = true,

	-- Define cursor styles for different modes
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	audible_bell = "Disabled",
	check_for_updates = false,
	font = wezterm.font("JetBrains Mono NL"),
	color_scheme = "iTerm2 Smoooooth",
	colors = {
		tab_bar = {
			background = "#0b0022",
			new_tab = {
				bg_color = "#0b0022",
				fg_color = "#2b2042",
			},
		},
	},
	inactive_pane_hsb = {
		hue = 1.0,
		saturation = 1.0,
		brightness = 1.0,
	},
	font_size = 14.0,
	launch_menu = {},
	window_padding = {
		left = 2,
		right = 2,
		top = 0,
		bottom = 0,
	},
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	disable_default_key_bindings = true,
	-- allow_win32_input_mode = false,
	-- send_composed_key_when_left_alt_is_pressed = true,
	-- debug_key_events = true,
	-- leader = { key = ",", mods = "ALT" },
	leader = leader,
	keys = {
		-- Map Alt+a to send the sequence for Alt+a
		-- { key = "a", mods = "ALT", action = wezterm.action({ SendString = "\x1ba" }) },
		-- -- Map Alt+w to send the sequence for Alt+w
		-- { key = "w", mods = "ALT", action = wezterm.action({ SendString = "\x1bw" }) },
		-- Map Alt+w to send the sequence for Alt+w
		-- { key = "w", mods = "ALT", action = wezterm.action({ SendString = "\x1bw" }) },
		-- Send "ALT-A" to the terminal when pressing CTRL-A, CTRL-A
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
				local tab, window = pane:move_to_new_tab()
			end),
		},
		{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
		{ key = "t", mods = "SHIFT|CTRL", action = "ShowTabNavigator" },
		{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
		{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
		{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
		{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
		{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
		{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
		{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
		{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
		{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
		{ key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

		{ key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
		{ key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "c", mods = "SHIFT|CTRL", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "+", mods = "SHIFT|CTRL", action = "IncreaseFontSize" },
		{ key = "_", mods = "SHIFT|CTRL", action = wezterm.action.DecreaseFontSize },
		{ key = "=", mods = "LEADER|CTRL", action = "ResetFontSize" },
		{
			key = "E",
			mods = "CTRL|SHIFT",
			action = wezterm.action.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, pane, line)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
	},
	set_environment_variables = {},
}

wezterm.on("format-window-title", function()
	local title = "[" .. wezterm.mux.get_active_workspace() .. "]"
	title = title .. " " .. wezterm.mux.get_domain():name()
	title = title .. " - $W"
	return title
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title
	if tab.tab_title and #tab.tab_title > 0 then
		title = tab.tab_title
	end
	if tab.is_active then
		return {
			{ Background = { Color = "#0b0022" } },
			{ Foreground = { Color = "#2b2042" } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = "#2b2042" } },
			{ Foreground = { Color = "#A9A6AC" } },
			{ Text = (tab.tab_index + 1) .. "| " .. title .. " " },
			{ Background = { Color = "#0b0022" } },
			{ Foreground = { Color = "#2b2042" } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	else
		return {
			{ Background = { Color = "#0b0022" } },
			{ Foreground = { Color = "#1b1032" } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = "#1b1032" } },
			{ Foreground = { Color = "#66646C" } },
			{ Text = (tab.tab_index + 1) .. "| " .. title .. " " },
			{ Background = { Color = "#0b0022" } },
			{ Foreground = { Color = "#1b1032" } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	end
end)

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
	window:gui_window():toggle_fullscreen()
end)

-- folke/zen-mode.nvim config
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
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

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- config.front_end = "Software" -- OpenGL doesn't work quite well with RDP.
	-- config.term = "" -- Set to empty so FZF works on windows
	-- "C:\Program Files\PowerShell\7\pwsh.exe"
	table.insert(config.launch_menu, { label = "PowerShell", args = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" } })
	config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-l" }
end

if wezterm.target_triple == "aarch64-apple-darwin" then
	-- config.font = wezterm.font_with_fallback({
	-- 	"JetBrains Mono",
	-- 	"Menlo",
	-- 	"DejaVu Sans Mono",
	-- 	"Bitstream Vera Sans Mono",
	-- 	"Lucida Console",
	-- 	"Monaco",
	-- 	"Consolas",
	-- 	"Courier New",
	-- })
end

-- NOTE:
config.unix_domains = {
	{
		name = "usual",
	},
	{
		name = "config",
		-- socket_path = "C:\\Users\\tito\\.local\\share\\wezterm\\config",
		-- socket_path = "C:/Users/tito/.local/share/wezterm/config",
	},
	{
		name = "godot",
		socket_path = "C:\\Users\\tito\\.local\\share\\wezterm\\godot",
		-- socket_path = "C:/Users/tito/.local/share/wezterm/godot",
	},
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
-- config.default_gui_startup_args = { "connect", "usual" }

return config
