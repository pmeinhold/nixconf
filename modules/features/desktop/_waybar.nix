{ config, lib, pkgs, ... }:
let
  baseColor = "rgb(1e1e2e)";
  barColor = "rgb(313244)";
  activeBorderColor = "rgba(a6e3a1ee) rgba(89dcebee) 45deg";
  killWindowColor = "rgb(f38ba8)";
  floatWindowColor = "rgb(f9e2af)";
  fullWindowColor = "rgb(94e2d5)";
  gapSize = config.wayland.windowManager.hyprland.settings.general.gaps_out;
in
{
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 20;
      margin = "0";
      spacing = 0; # 2*gapSize;
      modules-left = [
        "group/power"
      ];
      modules-center = [
        "hyprland/workspaces"
      ];
      modules-right = [
        "tray"
        "battery"
        "backlight"
        "pulseaudio"
        "clock"
      ];
      "group/power" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 80;
          transition-left-to-right = true;
          click-to-reveal = false;
        };
        modules = [
          "custom/launcher"
          "custom/lock"
          "custom/quit"
          "custom/power"
          "custom/reboot"
        ];
      };
      "custom/launcher" = {
        on-click = config.home.file."showbinds".target;
        format = " ";
        tooltip = false;
      };
      "custom/lock" = {
        on-click = "${lib.getExe pkgs.hyprlock}";
        format = "󰍁 "; # 󰌾 
        tooltip = false;
      };
      "custom/reboot" = {
        format = "󰜉 "; # 󰑓  󰦛  󱍸
        on-click = "${pkgs.systemd}/bin/systemctl reboot";
        tooltip = false;
      };
      "custom/power" = {
        format = "󰐥 "; # ⏼
        on-click = "${pkgs.systemd}/bin/systemctl poweroff";
        tooltip = false;
      };
      "custom/quit" = {
        format = "󰿅 ";# 󰿅  󰅙
        # on-click = "${pkgs.hyprland}/bin/hyprctl dispatch exit";
        on-click = "loginctl terminate-session $(loginctl session-status | head -n 1 | awk '{print $1}')";
        tooltip = false;
      };
      "hyprland/workspaces" = {
        on-click = "activate";
        active-only = false;
        all-outputs = false;
        sort-by-number = true;
        disable-scroll = false;
        format = " ";
        persistent-workspaces = { "1" = []; "2" = []; "3" = []; "4" = []; };
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };
      "pulseaudio" = {
        format = "{icon}{volume}%";
        format-muted = " ";
        format-icons = [" " " " " "];
        on-click-right = "pwvucontrol";
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      "backlight" = {
        device = "intel_backlight";
        format = "{icon}{percent}%";
        format-icons = [" " " " " " " " " " " " " " " " " "];
        tooltip = false;
      };
      "clock" = {
        format = " {:%a %d.%m. 󰥔 %H:%M}";
        tooltip = false;
      };
      "battery" = {
        states = {
          good = 70;
          warning = 30;
          critical = 15;
        };
        bat             = "BAT1";
        format          = "{icon}  {capacity}%";
        format-charging = "{icon}󱐋 {capacity}%";
        format-plugged  = "{icon} {capacity}%";
        format-icons    = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      };
      "tray" = {
        spacing = 10;
        icon-size = 16;
      };
    };
    # Use some of the Catppuccin style:
    # https://github.com/rubyowo/dotfiles/blob/f925cf8e3461420a21b6dc8b8ad1190107b0cc56/config/waybar/style.css
    style = #css
    ''
      * {
        font-family: Inconsolata Nerd Font;
        /* font-weight: bold; */
        background-color: @surface0;
        min-height: 0;
        margin: 0;
        padding: 0;
      }

      #waybar {
        font-size: 16px;
        color: @text;
      }
      .modules-left { margin-left: ${builtins.toString (2*gapSize)}px; }
      .modules-right { margin-right: ${builtins.toString (2*gapSize)}px; }
      #group-power { }
      #custom-lock, #custom-quit, #custom-power, #custom-reboot { margin-left: 1em; }
      #custom-launcher { margin-right: 0em; }
      #custom-lock { color: @green; }
      #custom-quit { color: @yellow; }
      #custom-power { color: @red; }
      #custom-reboot { color: @mauve; }

      #workspaces { }
      #workspaces button {
        font-size: 14px;
        color: @overlay0;
        padding-left: 1px;
      }
      #workspaces button.empty { color: @base; }
      #workspaces button.visible { color: @mauve; }
      #workspaces button.active { color: @green; }
      #workspaces button.urgent { color: @red; }
      #workspaces button:hover { color: @text; }

      #tray , battery, #backlight, #pulseaudio, #clock {
        margin-left: 1em;
        color: @text;
      }
      #battery { color: @teal; }
      #battery.charging { color: @teal; }
      #battery.warning:not(.charging) { color: @red; }
    '';
  };
}
