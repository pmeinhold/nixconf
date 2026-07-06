{ ... }:
{
  flake.modules.homeManager.feature-keychords = { config, lib, pkgs, ... }:
  let
    term =
      if      config.programs.foot.enable      then "foot"
      else if config.programs.alacritty.enable then "alacritty"
      else if config.programs.wezterm.enable   then "wezterm"
      else "notify-send 'No terminal configured'";

    home = config.home.homeDirectory;
  in
  {
    home.packages = [ pkgs.wlr-which-key ];

    home.file."keychords-screenshot" = {
      executable = true;
      target = ".config/keychords/screenshot.sh";
      text = ''
        #!/bin/sh
        grim -g "$(slurp)" "$HOME/Desktop/$(date +'%F_%T.png')"
      '';
    };

    home.file."keychords-logout" = {
      executable = true;
      target = ".config/keychords/logout.sh";
      text = ''
        #!/bin/sh
        loginctl terminate-session $(loginctl session-status | head -n 1 | awk '{print $1}')
      '';
    };

    xdg.configFile."wlr-which-key/config.yaml".text = ''
      font: "Inconsolata Nerd Font 14"
      background: "#1e1e2ed0"
      color: "#cdd6f4"
      border: "#cba6f7"
      separator: " → "
      border_width: 2
      corner_r: 8
      padding: 15
      anchor: center
      margin_left: 10
      margin_bottom: 10
      inhibit_compositor_keyboard_shortcuts: true

      menu:
        - key: "Return"
          desc: Terminal
          cmd: ${term}
        - key: "b"
          desc: Browser
          cmd: firefox
        - key: "r"
          desc: Launcher
          cmd: rofi -show drun
        - key: "p"
          desc: Screenshot
          cmd: ${home}/.config/keychords/screenshot.sh
        - key: "l"
          desc: Lock
          cmd: hyprlock
        - key: "s"
          desc: System
          submenu:
            - key: "s"
              desc: Shutdown
              cmd: systemctl poweroff
            - key: "r"
              desc: Reboot
              cmd: systemctl reboot
            - key: "l"
              desc: Logout
              cmd: ${home}/.config/keychords/logout.sh
    '';
  };
}
