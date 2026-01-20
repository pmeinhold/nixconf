{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Inconsolata Nerd Font";
      size = 12;
    };
    settings = {
      enable_audio_bell = false;
      clear_all_shortcuts = true;
      kitty_mod = "alt";
      window_padding_width = 12;
    };
    keybindings = {
      # Clipboard
      "kitty_mod+y"     = "copy_to_clipboard";
      "kitty_mod+p"     = "paste_from_clipboard";

      # Font size
      "kitty_mod+plus"  = "change_font_size all +2.0";
      "kitty_mod+minus" = "change_font_size all -2.0";
      "kitty_mod+equal" = "change_font_size all  0";
      "kitty_mod+0"     = "change_font_size all  0";

      # Scrolling (May overlap with Zellij)
      "kitty_mod+ctrl+j" = "scroll_line_down";
      "kitty_mod+ctrl+k" = "scroll_line_up";
      "kitty_mod+ctrl+l" = "scroll_page_down";
      "kitty_mod+ctrl+h" = "scroll_page_up";
      "kitty_mod+ctrl+u" = "scroll_page_up";
      "kitty_mod+ctrl+d" = "scroll_page_down";
      "kitty_mod+ctrl+e" = "launch --stdin-source=@screen_scrollback $EDITOR -n";
      "kitty_mod+ctrl+down" = "scroll_line_down";
      "kitty_mod+ctrl+up"   = "scroll_line_up";
      "page_up"   = "scroll_page_up";
      "page_down" = "scroll_page_down";
      "home"      = "scroll_home";
      "end"       = "scroll_end";

      # "kitty_mod+ctrl+c"          = "copy_to_clipboard";
      # "kitty_mod+ctrl+v"          = "paste_from_clipboard";

      # "kitty_mod+ctrl+j"          = "change_font_size all -2.0";
      # "kitty_mod+ctrl+k"          = "change_font_size all +2.0";
      # "kitty_mod+ctrl+backspace"  = "change_font_size all  0";
      # "ctrl+plus"                 = "change_font_size all +2.0";
      # "ctrl+minus"                = "change_font_size all -2.0";
      # "ctrl+equal"                = "change_font_size all  0";
      # "ctrl+0"                    = "change_font_size all  0";

      # "kitty_mod+shift+up"        = "scroll_line_up";
      # "kitty_mod+shift+down"      = "scroll_line_down";
      # "kitty_mod+shift+page_up"   = "scroll_page_up";
      # "kitty_mod+shift+page_down" = "scroll_page_down";
      # "kitty_mod+shift+home"      = "scroll_home";
      # "kitty_mod+shift+end"       = "scroll_end";
            # bind "Alt Ctrl j" { ScrollDown; }
            # bind "Alt Ctrl k" { ScrollUp; }
            # bind "Alt Ctrl h" { HalfPageScrollUp; }
            # bind "Alt Ctrl l" { HalfPageScrollDown; }
            # bind "Alt Ctrl u" { PageScrollUp; }
            # bind "Alt Ctrl d" { PageScrollDown; }
            # bind "Alt Ctrl e" { EditScrollback; }
            # bind "PageDown"   { PageScrollDown; }
            # bind "PageUp"     { PageScrollUp; }
            # bind "Home"       { ScrollToTop; }
            # bind "End"        { ScrollToBottom; }
    };
  };
}
