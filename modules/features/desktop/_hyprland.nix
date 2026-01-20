{ lib, pkgs, config, ... }:
let
  baseColor = "rgb(1e1e2e)";
  barColor = "rgb(313244)";
  textColor = "rgb(cdd6f4)";
  activeBorderColor = "rgba(a6e3a1ee) rgba(89dcebee) 45deg";
  killWindowColor = "rgb(f38ba8)";
  floatWindowColor = "rgb(f9e2af)";
  fullWindowColor = "rgb(a6e3a1)";
in
{
  # Show keybinds script
  # https://github.com/hyprland-community/hypr-binds?tab=readme-ov-file
  home.packages = with pkgs; [ jq ]; # for hypr-binds-script
  home.file."showbinds" = {
    executable = true;
    target = ".config/showbinds.sh";
    text = #bash
    ''
      hyprctl binds -j |
        jq -r '
          map({mod:.modmask|tostring,key:.key,code:.keycode|tostring,desc:.description,dp:.dispatcher,arg:.arg,sub:.submap}) |
          map(.mod |= {"0":"","1":"SHIFT+","4":"CTRL+","5":"SHIFT+CTRL+","64":"SUPER+","65":"SUPER+SHIFT+","68":"SUPER+CTRL+","8":"ALT+"} [.]) |
          map(.code |= {"59":"Comma","60":"Dot"} [.]) |
          sort_by(.mod) | .[] |
          select(.sub == "") |
          select(.desc != "") |
          "<b>\(.mod)\(if .key == "" then .code else .key end)</b> <i>\(.desc)</i> <span>\(.dp) \(.arg)</span>" ' |
        rofi -dmenu -markup-rows -i -p 'Hypr binds' -columns 2 |
        sed -n 's/.*<span>\(.*\)<\/span>.*/\1/p' |
        sed -e 's/^/"/g' -e 's/$/"/g' |
        xargs -n1 hyprctl dispatch
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    plugins = with pkgs; [
      hyprlandPlugins.hyprbars
    ];

    extraConfig = # hyprlang
    ''
      plugin {
        hyprbars {
          bar_height = 20
          hyprbars-button = ${killWindowColor}, 12, 󰖭, hyprctl dispatch killactive
          hyprbars-button = ${floatWindowColor}, 12, ~, $tfl
          hyprbars-button = ${fullWindowColor}, 12, ^, hyprctl dispatch fullscreen 1
          inactive_button_color = ${baseColor}
          bar_text_size = 10
          bar_text_font = Sans Bold
          bar_color = ${barColor}
          col.text = ${textColor}
          bar_part_of_window = true
          on_double_click = hyprctl dispatch togglefloating
          icon_on_hover = true
          # BUG: gives border/focus flickering if enabled:
          bar_precedence_over_border = false
        }
      }
    '';

    settings = {
      # Any monitor is duplicate of eDP-1 if exists
      monitor = lib.mkDefault [ ", highres, auto, 1, mirror, eDP-1" ];

      exec-once = [
        "swww-daemon || swww img ~/dev/nixconf/pics/waves-light.jpg"
        "udiskie"
        "nm-applet"
        "blueman-applet"
        "tailscale-systray"
        "waybar"
        "stretchly"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        resize_on_border = true;
        extend_border_grab_area = 20;
        #sensitivity = 0.5;
        layout = "master";
        "col.inactive_border" = barColor;
        "col.active_border" = activeBorderColor;
      };

      cursor = {
        no_warps = true;
      };

      dwindle = {
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_on_top = false;
        inherit_fullscreen = true;
      };

      gestures = {
        workspace_swipe_touch = false;
        workspace_swipe_create_new = false;
      };

      input = {
        kb_layout = lib.mkDefault "eu";
        follow_mouse = 2;
        repeat_delay = 200;
        sensitivity = 0;
        natural_scroll = false;
      };

      decoration = {
        rounding = 8;
        shadow.enabled = false;
      };

      animation = [
        "border, 1, 2, default"
        "fade, 1, 4, default"
        "windows, 1, 3, default, popin 80%"
        "workspaces, 1, 2, default, slide"
      ];

      windowrule = [
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      "$tfl"      = "hyprctl --batch 'dispatch togglefloating ; dispatch resizeactive exact 50% 50% ; dispatch centerwindow 1'";
      "$mod"      = "SUPER";
      "$browser"  = "firefox";
      "$term"     =
        if config.programs.foot.enable then "foot"
        else if config.programs.alacritty.enable then "alacritty"
        else if config.programs.wezterm.enable  then "wezterm"
        else "notify-send 'none of foot, alacritty, or wezterm installed'";
      "$menu"     = "rofi -show drun";
      "$scrnshot" = "grim -g \"$(slurp)\" $HOME/Desktop/screen/$(date +'%s_grim.png')"; # Screenshot utility

      # Binds with description
      bindd = [
        "$mod,          space,  Show keybinds,            exec, ${config.home.file."showbinds".target}"
        "$mod,          Return, Open terminal,            exec, $term"
        "$mod SHIFT,    Return, Open launcher,            exec, $menu"
        "$mod,          B,      Open browser,             exec, $browser"
        "$mod,          P,      Take screenshot,          exec, $scrnshot"
        ",              Print,  Take screenshot,          exec, $scrnshot"
        "$mod,          Escape, Lock screen,              exec, hyprlock"
        "$mod CONTROL,  Escape, Shutdown,                 exec, systemctl poweroff"
        "$mod SHIFT,    Escape, Logout,                   exit"
        "$mod SHIFT,    Q,      Close window,             killactive"
        "$mod,          F,      Maximize,                 fullscreen, 1"
        "$mod SHIFT,    F,      Fullscreen,               fullscreen, 0"
        "$mod CONTROL,  F,      Toggle floating,          exec, $tfl"
        "$mod,          j,      Focus window down,        layoutmsg, cyclenext"
        "$mod,          k,      Focus window up,          layoutmsg, cycleprev"
        "$mod SHIFT,    j,      Move window down,         layoutmsg, swapnext"
        "$mod SHIFT,    k,      Move window up,           layoutmsg, swapprev"
        "$mod CONTROL,  h,      Resize window left,       resizeactive, -80   0"
        "$mod CONTROL,  j,      Resize window down,       resizeactive,   0  80"
        "$mod CONTROL,  k,      Resize window up,         resizeactive,   0 -80"
        "$mod CONTROL,  l,      Resize window right,      resizeactive,  80   0"
        "$mod,          h,      Go workspace left,        workspace, -1"
        "$mod,          l,      Go workspace right,       workspace, +1"
        "$mod SHIFT,    h,      Move to workspace left,   movetoworkspacesilent, -1"
        "$mod SHIFT,    l,      Move to workspace right,  movetoworkspacesilent, +1"
        "$mod,          1,      Go to workspace 1,        workspace,       1"
        "$mod,          2,      Go to workspace 2,        workspace,       2"
        "$mod,          3,      Go to workspace 3,        workspace,       3"
        "$mod,          4,      Go to workspace 4,        workspace,       4"
        "$mod SHIFT,    1,      Move to workspace 1,      movetoworkspacesilent, 1"
        "$mod SHIFT,    2,      Move to workspace 2,      movetoworkspacesilent, 2"
        "$mod SHIFT,    3,      Move to workspace 3,      movetoworkspacesilent, 3"
        "$mod SHIFT,    4,      Move to workspace 4,      movetoworkspacesilent, 4"
      ];
      bind = [
        ",     XF86MonBrightnessUp,     exec, brightnessctl set +5%"
        ",     XF86MonBrightnessDown,   exec, brightnessctl set 5%-"
        "$mod, XF86AudioRaiseVolume,    exec, brightnessctl set +5%"
        "$mod, XF86AudioLowerVolume,    exec, brightnessctl set 5-%"
        ", XF86AudioRaiseVolume,        exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume,        exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioPlay,               exec, playerctl play-pause"
        ", XF86AudioPrev,               exec, playerctl previous"
        ", XF86AudioNext,               exec, playerctl next"
      ];

      # Hold-repeatable binds
      binde = [
        # Resize
        "$mod,      left, resizeactive, -30   0"
        "$mod,      down, resizeactive,   0  30"
        "$mod,        up, resizeactive,   0 -30"
        "$mod,     right, resizeactive,  30   0"
      ];

      # Mouse binds
      bindm = [
        # Move/resize windows with mod + LMB/RMB and dragging
        # 274 = middle/wheel
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
