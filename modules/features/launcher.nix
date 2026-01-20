{ ... }:
{
  flake.modules.homeManager.feature-launcher = { config, pkgs, ... }:
  let
    borderSize = config.wayland.windowManager.hyprland.settings.general.border_size;
    rounding = config.wayland.windowManager.hyprland.settings.decoration.rounding;
  in
  {
    home.packages = with pkgs; [ rofi ];
    home.file.roficonf = {
      target = ".config/rofi/config.rasi";
      text = #rasi
      ''
        // https://man.archlinux.org/man/rofi-theme.5.en#scrollbar_Properties

        configuration {
            modes: [ drun, run ];
            scroll-method: 1; // centered
            show-icons: true;
            kb-cancel: "Escape,!MousePrimary"; // cancel rofi when clicking away
            // hover-select: true;
            // me-select-entry: "MousePrimary";
            // me-accept-entry: "!MousePrimary";
        }

        * {
            // Variables
            font:               "Inconsolata Nerd Font 14";
            mauve:              #cba6f7;
            red:                #f38ba8;
            yellow:             #f9e2af;
            green:              #a6e3a1;
            sky:                #89dceb;
            text:               #cdd6f4;
            subtext0:           #a6adc8;
            overlay0:           #6c7086;
            base:               #1e1e2e;
            surface0:           #313244;
        }

        window {
            text-color:         @text;
            background-color:   @surface0;
            margin:             0;
            padding:            0; // do 20 0 0 0 to fake top window bar
            border:             0;
            border-radius:      ${builtins.toString rounding};
            width:              50%;
            height:             50%;
            children:           [ mainbox ];
        }

        mainbox {
            text-color:         inherit;
            border-radius:      inherit;
            border-color:       @sky;
            background-color:   @base;
            border:             ${builtins.toString borderSize};
            padding:            1em;
            spacing:            1em;
            children:           [ inputbar, listview ];
        }
            inputbar, listview {
                text-color:         inherit;
                background-color:   inherit;
                padding:            0;
                margin:             0;
            }
            inputbar {
                children: [ textbox-prompt, entry ];
            }
                textbox-prompt {
                    text-color: @sky;
                    str:        "> ";
                    expand:     false;
                }
                entry {
                    text-color:         inherit;
                    background-color:   inherit;
                    text-transform:     italic;
                    placeholder:        "<i>Type to filter...</i>";
                    placeholder-markup: true;
                    placeholder-color:  @overlay0;
                }
            listview {
                columns:        1;
                fixed-height:   false;
                scrollbar:      false;
                border:         0;
            }
                element {
                    border-radius:  ${builtins.toString rounding};
                    padding:        0.2em 1em 0.2em 1em;
                    children:       [element-text, element-icon];
                }
                    element-icon {
                        size: 1.4em;
                    }
                    element-text {
                        vertical-align: 0.5;
                    }
                element selected.normal {
                    background-color:   @surface0;
                    text-color:         @sky;
                }
                element selected.active {
                    background-color:   @surface0;
                    text-color:         @yellow;
                }
                element selected.urgent {
                    background-color:   @surface0;
                    text-color:         @red;
                }
                element normal.normal, element normal.active, element normal.urgent, element alternate.normal, element alternate.active, element alternate.urgent {
                    background-color:   inherit;
                    text-color:         inherit;
                }
      '';
    };
  };
}
