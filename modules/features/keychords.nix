{ ... }:
{
  flake.modules.homeManager.feature-keychords = { config, lib, pkgs, ... }:
  let
    term =
      if      config.programs.foot.enable      then "foot"
      else if config.programs.alacritty.enable then "alacritty"
      else if config.programs.wezterm.enable   then "wezterm"
      else "noctalia msg notification-show 'No terminal configured'";
      # else "notify-send 'No terminal configured'";

    home = config.home.homeDirectory;
  in
  {
    # programs.wlr-which-key = {
    #   enable = true;
    #   settings = {
    #     font = "Inconsolata Nerd Font 14";
    #     background = "#1e1e2ed0";
    #     color = "#cdd6f4";
    #     border = "#cba6f7";
    #     separator = " → ";
    #     border_width = 2;
    #     corner_r = 8;
    #     padding = 15;
    #     anchor = "center";
    #     inhibit_compositor_keyboard_shortcuts = true;
    #
    #     menu = [
    #       { key = "Return"; desc = "  Terminal";     cmd = "${term}"; }
    #       { key = "b";      desc = "󰈹  Browser";      cmd = "zen"; }
    #       { key = "r";      desc = "󱓞  Run ...";      cmd = "noctalia msg panel-toggle launcher"; }
    #       { key = "p";      desc = "󰹑  Screenshot";   cmd = "noctalia msg screenshot-region"; }
    #       { key = "l";      desc = "󰍁  Lock";         cmd = "noctalia msg session lock"; }
    #       {
    #         key     = "s";
    #         desc    = "System";
    #         submenu = [
    #           { key = "s";      desc = "󰐥  Shutdown"; cmd = "systemctl poweroff"; }
    #           { key = "r";      desc = "󰜉  Reboot";   cmd = "systemctl reboot"; }
    #           { key = "l";      desc = "󰿅  Logout";   cmd = "noctalia msg session logout"; }
    #         ];
    #       }
    #     ];
    #   };
    # };

    home.packages = [ pkgs.wlr-which-key ];
    # noctalia msg session <lock|suspend|lock-and-suspend|logout|reboot|shutdown>
    # 󰈹
    # 
    xdg.configFile."wlr-which-key/config.yaml".text = /*yaml*/ ''
      font: "Inconsolata Nerd Font 14"
      background: "#1e1e2ed0"
      color: "#cdd6f4"
      border: "#cba6f7"
      separator: " → "
      border_width: 2
      corner_r: 8
      padding: 15
      anchor: center
      inhibit_compositor_keyboard_shortcuts: true

      menu:
        - key: "Return"
          desc:   Terminal
          cmd: ${term}
        - key: "b"
          desc:   Browser
          cmd: zen
        - key: "r"
          desc: 󱓞  Run ...
          cmd: noctalia msg panel-toggle launcher
        - key: "p"
          desc: 󰹑  Print Screen
          cmd: noctalia msg screenshot-region
        - key: "l"
          desc: 󰍁  Lock
          cmd: noctalia msg session lock
        - key: "s"
          desc: System
          submenu:
            - key: "s"
              desc: 󰐥  Shutdown
              cmd: systemctl poweroff
            - key: "r"
              desc: 󰜉  Reboot
              cmd: systemctl reboot
            - key: "l"
              desc: 󰿅  Logout
              cmd: noctalia msg session logout
    '';
  };
}
