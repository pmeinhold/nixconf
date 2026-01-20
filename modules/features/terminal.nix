{ ... }:
{
  flake.modules.homeManager.feature-terminal = { pkgs, ... }:
  {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "Inconsolata Nerd Font:size=14";
          dpi-aware = "no"; # yes
        };
      };
    };
  };
}

  # # default bindings: https://alacritty.org/config-alacritty-bindings.html
  # programs.alacritty = {
  #   enable = false;
  #   settings = {
  #     font = {
  #       normal.family = "Inconsolata Nerd Font";
  #       # bold.family = "Inconsolata Nerd Font";
  #       size = 12;
  #     };
  #     window.padding = { x = 4; y = 4; };
  #   };
  # };

  # # "[...] Color scheme in `~/.config/wezterm/colors/catppuccin-mocha.toml` failed to load: parsing TOML: scheme is missing ANSI colors"
  # catppuccin.wezterm = {
  #   enable = false;
  #   apply = false;
  # };

  # programs.wezterm = {
  #   enable = false;
  #   extraConfig = #lua
  #   ''
  #     local wezterm = require 'wezterm'
  #     local config = wezterm.config_builder()
  #     config.color_scheme = "Catppuccin Mocha" -- Must set theme here
  #     config.font = wezterm.font "Inconsolata Nerd Font"
  #     config.command_palette_font = wezterm.font "Inconsolata Nerd Font"
  #     config.command_palette_bg_color = "#313244"
  #     config.command_palette_fg_color = "#cdd6f4"

  #     config.font_size = 12
  #     config.disable_default_key_bindings = true
  #     config.window_decorations = "NONE"
  #     config.enable_tab_bar = false
  #     config.window_close_confirmation = "NeverPrompt"

  #     -- Do 'weztertm --config debug_key_events = true' to debug the key events
  #     config.leader = { key = "Space", mods = "ALT", timeout_milliseconds = 1000 }
  #     --config.key_map_preference = "Physical" -- "Mapped"
  #     config.keys = {
  #       --{ key = "Enter", mods = "ALT",        action = wezterm.action.SendKey{ key="Enter", mods="ALT"} },
  #       --{ key = "Enter", mods = "SHIFT",      action = wezterm.action.SendKey{ key="Enter", mods="SHIFT"} },
  #       --{ key = "Enter", mods = "ALT|SHIFT",  action = wezterm.action.SendString("\x1b[27[;6;13~") },

  #       -- Send alt+shift+enter as special binding as a workaround
  #       --{ key = "mapped:Enter", mods = "ALT|SHIFT",  action = wezterm.action.SendKey{ key="mapped:Enter", mods="ALT|SHIFT"} },
  #       --{ key = "Enter", mods = "ALT|SHIFT",  action = wezterm.action.SendKey{ key="Enter", mods="ALT|SHIFT"} },
  #       --
  #       { key = "y", mods = "ALT", action = wezterm.action.CopyTo("Clipboard") },
  #       { key = "p", mods = "ALT", action = wezterm.action.PasteFrom("Clipboard") },
  #       { key = "-", mods = "ALT", action = wezterm.action.DecreaseFontSize },
  #       { key = "=", mods = "ALT|SHIFT", action = wezterm.action.IncreaseFontSize },
  #       { key = "=", mods = "ALT", action = wezterm.action.ResetFontSize },

  #       { key = "Space", mods = "LEADER", action = wezterm.action.ActivateCommandPalette },

  #       -- Scrolling
  #       { key = "g", mods = "LEADER", action = wezterm.action.ScrollToTop },
  #       { key = "k", mods = "LEADER", action = wezterm.action.ScrollToPrompt(-1) },
  #       { key = "j", mods = "LEADER", action = wezterm.action.ScrollToPrompt(1) },
  #       { key = "UpArrow", mods = "ALT|CTRL", action = wezterm.action.ScrollByLine(-1) },
  #       { key = "DownArrow", mods = "ALT|CTRL", action = wezterm.action.ScrollByLine(1) },
  #       { key = "u", mods = "ALT|CTRL", action = wezterm.action.ScrollByPage(-1) },
  #       { key = "d", mods = "ALT|CTRL", action = wezterm.action.ScrollByPage(1) },

  #       { key = "UpArrow", mods = "ALT|CTRL", action = wezterm.action.ScrollByLine(-1) },
  #       { key = "DownArrow", mods = "ALT|CTRL", action = wezterm.action.ScrollByLine(1) },
  #     }
  #     --
  #     config.mouse_bindings = {
  #       {
  #         event = { Down = { streak = 1, button = { WheelUp = 1 } } },
  #         mods = "",
  #         action = wezterm.action.ScrollByLine(-1),
  #       },
  #       {
  #         event = { Down = { streak = 1, button = { WheelDown = 1 } } },
  #         mods = "",
  #         action = wezterm.action.ScrollByLine(1),
  #       },
  #     }
  #     return config
  #   '';
  # };
# }
