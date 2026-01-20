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
      # "$termfiles"= "$term -e fish -c y";
      # "$files"    = "pcmanfm";
      # "$menu0"     = "tofi-drun | xargs hyprctl dispatch exec";
      # "$menu1"     = "tofi-run | xargs hyprctl dispatch exec";
      "$menu"     = "rofi -show drun";
      "$scrnshot" = "grim -g \"$(slurp)\" $HOME/Desktop/screen/$(date +'%s_grim.png')"; # Screenshot utility

      # Non-hold-repeatable binds
      bind = [
        # Launch
        "$mod,          Return, exec,   $term"
        "$mod SHIFT,    Return, exec,   $menu"
        # "$mod CONTROL,  Return, exec,   $menu1"
        # "$mod CONTROL,  Return, exec,   $termfiles"
        # "$mod,          E,      exec,   $files"
        "$mod,          B,      exec,   $browser"
        "$mod,          P,      exec,   $scrnshot"
        ",              Print,  exec,   $scrnshot"
        # Power & Exit
        "$mod,          Escape, exec,   hyprlock"
        "$mod CONTROL,  Escape, exec,   systemctl poweroff"
        "$mod SHIFT,    Escape, exit"
        # Windows
        "$mod SHIFT,    Q,      killactive"
        "$mod,          F,      fullscreen, 1" # maximize
        "$mod SHIFT,    F,      fullscreen, 0" # whole screen
        "$mod CONTROL,  F,      exec, $tfl"
        # Windows: cycle, swap
        "$mod,          j, layoutmsg, cyclenext"
        "$mod,          k, layoutmsg, cycleprev"
        "$mod SHIFT,    j, layoutmsg, swapnext"
        "$mod SHIFT,    k, layoutmsg, swapprev"
        # Windows: resize
        "$mod CONTROL, h, resizeactive, -80   0"
        "$mod CONTROL, j, resizeactive,   0  80"
        "$mod CONTROL, k, resizeactive,   0 -80"
        "$mod CONTROL, l, resizeactive,  80   0"
        # Brightness
        ",     XF86MonBrightnessUp,     exec, brightnessctl set +5%"
        ",     XF86MonBrightnessDown,   exec, brightnessctl set 5%-"
        "$mod, XF86AudioRaiseVolume,    exec, brightnessctl set +5%"
        "$mod, XF86AudioLowerVolume,    exec, brightnessctl set 5-%"
        # Audio
        ", XF86AudioRaiseVolume,    exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume,    exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioPlay,           exec, playerctl play-pause"
        ", XF86AudioPrev,           exec, playerctl previous"
        ", XF86AudioNext,           exec, playerctl next"
        # Workspaces
        "$mod,          h, workspace,      -1"          # relative
        "$mod,          l, workspace,      +1"          # relative
        "$mod SHIFT,    h, movetoworkspacesilent, -1"   # relative
        "$mod SHIFT,    l, movetoworkspacesilent, +1"   # relative
        "$mod,          1, workspace,       1"
        "$mod,          2, workspace,       2"
        "$mod,          3, workspace,       3"
        "$mod,          4, workspace,       4"
        "$mod,          5, workspace,       5"
        "$mod,          6, workspace,       6"
        "$mod,          7, workspace,       7"
        "$mod,          8, workspace,       8"
        "$mod,          9, workspace,       9"
        "$mod SHIFT,    1, movetoworkspacesilent, 1"
        "$mod SHIFT,    2, movetoworkspacesilent, 2"
        "$mod SHIFT,    3, movetoworkspacesilent, 3"
        "$mod SHIFT,    4, movetoworkspacesilent, 4"
        "$mod SHIFT,    5, movetoworkspacesilent, 5"
        "$mod SHIFT,    6, movetoworkspacesilent, 6"
        "$mod SHIFT,    7, movetoworkspacesilent, 7"
        "$mod SHIFT,    8, movetoworkspacesilent, 8"
        "$mod SHIFT,    9, movetoworkspacesilent, 9"
        # Example special workspace (scratchpad)
        # "$mod,          S, togglespecialworkspace, magic"
        # "$mod SHIFT,    S, movetoworkspace, special:magic"
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
