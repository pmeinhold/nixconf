{ pkgs, ... }:
# I use Zellij mainly for tabs.

# Terminal's Duties
# - GPU acceleration
# - Open Links with mouse
# - Copy/Paste to/from the system that the terminal runs on

# Multiplexer Duties
# - Multiplexing (tabs, panes, etc.)
# - Sessions
# - Handle scrollback and scrolling
# - Copy/Paste to/from the system that zellij runs on

{
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "tmux-256color";
    prefix = "M-Space";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = tmux-sessionx;
        extraConfig = "set -g @sessionx-bind 'f'";
      }
    ];
    extraConfig = #bash
    ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g status-position top

      # Windows/Tabs
      bind-key -n M-S-Enter new-window
      bind-key -n M-l next-window
      bind-key -n M-h previous-window

      # Other
      bind-key -n M-q detach-client
      bind-key -n M-: command-prompt

      # Catppuccin
      set -g @catppuccin_window_status_style "basic" #"rounded"
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      # set -ag status-right "#{E:@catppuccin_status_uptime}"
      # set -agF status-right "#{E:@catppuccin_status_cpu}"
      # set -agF status-right "#{E:@catppuccin_status_battery}"
    '';
  };

  programs.zellij = {
    enable = true; # Enable this if KDL conversion has improved
    settings = {
      simplified_ui   = true;
      mouse_mode      = true;
      copy_on_select  = true;
      pane_frames     = false;
      default_layout  = "compact";
      keybinds = {
        _props.clear-defaults = true;
        shared._children = [
          { bind = { _args = [ "Alt Enter" ]; NewPane = {}; }; }
          { bind = { _args = [ "Alt j" ]; FocusNextPane = {}; }; }
          { bind = { _args = [ "Alt k" ]; FocusPreviousPane = {}; }; }
          { bind = { _args = [ "Alt Shift Enter" ]; NewTab = {}; }; }
          { bind = { _args = [ "Alt h" ]; GoToPreviousTab = {}; }; }
          { bind = { _args = [ "Alt l" ]; GoToNextTab = {}; }; }
          { bind = { _args = [ "Alt Shift h" ]; MoveTab = ["Left"]; }; }
          { bind = { _args = [ "Alt Shift l" ]; MoveTab = ["Right"]; }; }
          { bind = { _args = [ "Alt n" ]; NewPane = {}; }; }
          { bind = { _args = [ "Alt q" ]; Detach = {}; }; }
          { bind = { _args = [ "Alt Ctrl u" ]; PageScrollUp = {}; }; }
          { bind = { _args = [ "Alt Ctrl d" ]; PageScrollDown = {}; }; }
          {
            bind = {
              _args = [ "Alt f" ];
              _children = [
                {
                  LaunchOrFocusPlugin = {
                    _args = [ "session-manager" ];
                    _children = [ { floating = true; } { move_to_focused_tab = true; } ];
                  };
                }
                { SwitchToMode = ["Normal"]; }
              ];
            };
          }
        ];
      };
    };
  };
}
  #           bind "Alt Shift r"      { SwitchToMode "RenameTab"; TabNameInput 0; }
  #           bind "Alt Ctrl j" { ScrollDown; }
  #           bind "Alt Ctrl k" { ScrollUp; }
  #           bind "Alt Ctrl h" { HalfPageScrollUp; }
  #           bind "Alt Ctrl l" { HalfPageScrollDown; }
  #           bind "Alt Ctrl e" { EditScrollback; }
  #           bind "Alt Ctrl Down" { ScrollDown; }
  #           bind "Alt Ctrl Up" { ScrollUp; }
  #           bind "PageDown"   { PageScrollDown; }
  #           bind "PageUp"     { PageScrollUp; }
  #           bind "Home"       { ScrollToTop; }
  #           bind "End"        { ScrollToBottom; }
