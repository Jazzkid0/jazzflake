local mod = "SUPER"

hl.env("XCURSOR_THEME", "Vanilla-DMZ")
hl.env("XCURSOR_SIZE", "24")

-- Exit / Kill
hl.bind((mod .. " + SHIFT + Escape"), hl.dsp.exec_cmd("@powerMenu@/bin/power-menu"))
hl.bind((mod .. " + K"), hl.dsp.window.close())
hl.bind((mod .. " + CONTROL + K"), hl.dsp.window.kill())

-- Programs
hl.bind((mod .. " + D"), hl.dsp.exec_cmd("@launcher@/bin/launcher"))
hl.bind((mod .. " + SHIFT + D"), hl.dsp.exec_cmd("@runner@/bin/runner"))
hl.bind((mod .. " + H"), hl.dsp.exec_cmd("@alacritty@/bin/alacritty"))
hl.bind((mod .. " + V"), hl.dsp.exec_cmd("@cursorClip@/bin/cursor-clip"))
hl.bind((mod .. " + SHIFT + V"), hl.dsp.exec_cmd("@cursorClip@/bin/cursor-clip"))
hl.bind((mod .. " + G"), hl.dsp.exec_cmd("@screenshot@/bin/screenshot"))
hl.bind((mod .. " + Q"), hl.dsp.exec_cmd("@dndToggle@/bin/dnd-toggle"))

-- Window management
hl.bind((mod .. " + F"), hl.dsp.window.fullscreen())
hl.bind((mod .. " + ALT + F"), hl.dsp.window.fullscreen())
hl.bind((mod .. " + SHIFT + F"), hl.dsp.window.float({action = "toggle"}))

-- Workspace navigation (Colemak: arst = 1-4, neio = 5-9)
hl.bind((mod .. " + A"), hl.dsp.focus({workspace = "1"}))
hl.bind((mod .. " + R"), hl.dsp.focus({workspace = "2"}))
hl.bind((mod .. " + S"), hl.dsp.focus({workspace = "3"}))
hl.bind((mod .. " + T"), hl.dsp.focus({workspace = "4"}))
hl.bind((mod .. " + N"), hl.dsp.focus({workspace = "5"}))
hl.bind((mod .. " + E"), hl.dsp.focus({workspace = "6"}))
hl.bind((mod .. " + I"), hl.dsp.focus({workspace = "7"}))
hl.bind((mod .. " + O"), hl.dsp.focus({workspace = "8"}))

-- Move window to workspace (Colemak)
hl.bind((mod .. " + SHIFT + A"), hl.dsp.window.move({workspace = 1}))
hl.bind((mod .. " + SHIFT + R"), hl.dsp.window.move({workspace = 2}))
hl.bind((mod .. " + SHIFT + S"), hl.dsp.window.move({workspace = 3}))
hl.bind((mod .. " + SHIFT + T"), hl.dsp.window.move({workspace = 4}))
hl.bind((mod .. " + SHIFT + N"), hl.dsp.window.move({workspace = 5}))
hl.bind((mod .. " + SHIFT + E"), hl.dsp.window.move({workspace = 6}))
hl.bind((mod .. " + SHIFT + I"), hl.dsp.window.move({workspace = 7}))
hl.bind((mod .. " + SHIFT + O"), hl.dsp.window.move({workspace = 8}))

-- Move focus (columns via layoutmsg, rows via movefocus)
hl.bind((mod .. " + CONTROL + H"), hl.dsp.layout("focus l"))
hl.bind((mod .. " + CONTROL + J"), hl.dsp.focus({direction = "d"}))
hl.bind((mod .. " + CONTROL + K"), hl.dsp.focus({direction = "u"}))
hl.bind((mod .. " + CONTROL + L"), hl.dsp.layout("focus r"))
hl.bind((mod .. " + Left"), hl.dsp.layout("focus l"))
hl.bind((mod .. " + Right"), hl.dsp.layout("focus r"))
hl.bind((mod .. " + Up"), hl.dsp.focus({direction = "u"}))
hl.bind((mod .. " + Down"), hl.dsp.focus({direction = "d"}))
hl.bind((mod .. " + CONTROL + Left"), hl.dsp.layout("focus l"))
hl.bind((mod .. " + CONTROL + Right"), hl.dsp.layout("focus r"))
hl.bind((mod .. " + CONTROL + Up"), hl.dsp.focus({direction = "u"}))
hl.bind((mod .. " + CONTROL + Down"), hl.dsp.focus({direction = "d"}))

-- Swap columns / move window in column
hl.bind((mod .. " + SHIFT + H"), hl.dsp.layout("swapcol l"))
hl.bind((mod .. " + SHIFT + J"), hl.dsp.window.move({direction = "d"}))
hl.bind((mod .. " + SHIFT + K"), hl.dsp.window.move({direction = "u"}))
hl.bind((mod .. " + SHIFT + L"), hl.dsp.layout("swapcol r"))
hl.bind((mod .. " + SHIFT + Left"), hl.dsp.layout("swapcol l"))
hl.bind((mod .. " + SHIFT + Right"), hl.dsp.layout("swapcol r"))
hl.bind((mod .. " + SHIFT + Up"), hl.dsp.window.move({direction = "u"}))
hl.bind((mod .. " + SHIFT + Down"), hl.dsp.window.move({direction = "d"}))

-- Special workspace (scratchpad)
hl.bind((mod .. " + X"), hl.dsp.workspace.toggle_special("magic"))
hl.bind((mod .. " + SHIFT + X"), hl.dsp.window.move({workspace = "special:magic"}))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))

-- Mouse scroll for column layout
hl.bind((mod .. " + mouse_down"), function() hl.dispatch(hl.dsp.layout("move +200")) end)
hl.bind((mod .. " + mouse_up"), function() hl.dispatch(hl.dsp.layout("move -200")) end)
hl.bind((mod .. " + mouse:272"), hl.dsp.window.drag(), {mouse = true})
hl.bind((mod .. " + mouse:273"), hl.dsp.window.resize(), {mouse = true})

-- Config
hl.config({
  animations = {
    enabled = false,
    animation = {
      "workspaces, 1, 0.5, snap, slidefade 8%",
      "windows, 1, 0.5, snap, slide",
      "windowsIn, 1, 1, snap, popin 80%",
      "windowsOut, 1, 0.5, snap, popin 80%",
      "fade, 1, 0.5, default",
      "border, 1, 0.5, default",
      "specialWorkspace, 1, 0.5, snap, slidefadevert 8%",
    },
  },
  decoration = {
    rounding = 8,
    blur = { enabled = false },
  },
  general = {
    gaps_in = 4,
    gaps_out = 8,
    border_size = 2,
    layout = "scrolling",
  },
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = { natural_scroll = true },
  },
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
  },
  scrolling = {
    direction = "right",
    fullscreen_on_one_column = false,
    column_width = 0.8,
    focus_fit_method = 0,
    follow_focus = false,
    follow_min_visible = 0.4,
    explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
  },
})

-- Startup services
hl.on("hyprland.start", function()
  hl.exec_cmd("@waybar@/bin/waybar")
  hl.exec_cmd("@mako@/bin/mako")
  hl.exec_cmd("@cursorClip@/bin/cursor-clip --daemon")
end)

-- Systemd activation
hl.on("hyprland.start", function()
  hl.exec_cmd("@dbus@/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target")
end)

-- Window rules
hl.window_rule({match = {class = "pavucontrol"}, float = true})
hl.window_rule({match = {class = "nm-connection-editor"}, float = true})
hl.window_rule({match = {title = "Open File"}, float = true})
hl.window_rule({match = {title = "Save File"}, float = true})
