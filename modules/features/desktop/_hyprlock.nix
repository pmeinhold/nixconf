{ lib, pkgs, ... }:

{
  # Use the catppuccin hyprlock config
  catppuccin.hyprlock = {
    useDefaultConfig = true;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        path = "~/dev/nixconf/pics/waves-light.jpg";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        # lock_cmd = "${lib.getExe pkgs.hyprlock}";
        # command to run when receiving a dbus lock event (e.g. `loginctl lock-session`)
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple lock instances
      };

      listener = [
        # Brightness
        {
          timeout = 150; # 2min 30sec
          on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }

        # Lock screen
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session";
          # on-timeout = "${lib.getExe pkgs.hyprlock}";
        }

        # Screen off
        {
          timeout = 330; # 5min 30sec
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
          # on-timeout = "${pkgs.hyprland}/bin/dispatch dpms off";
          # on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }

        # Suspend
        {
          timeout = 900; # 15min
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
