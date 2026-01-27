{ config, inputs, ... }:
let
  flakeConfig = config;
  hasCatppuccin = inputs ? catppuccin;
in
{
  flake.modules.nixos.feature-desktop = { lib, pkgs, ... }: {
    services = {
      displayManager.gdm.enable = lib.mkDefault true;

      blueman.enable = true;
      udisks2.enable = true;
      printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
          # hplip
          # samsung-unified-linux-driver
          # hplipWithPlugin
          # (writeTextDir "share/cups/HP_Laser_10x_Series/HP_Laser_10x_Series.ppd" (builtins.readFile "${config.users.users.username.home}/Sync/Utility/printer/HP_Laser_10x_Series.ppd"))
          # (pkgs.callPackage ../printer/hp-laser-107w.nix {})
        ];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      pipewire = {
        enable = true;
        jack.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
    };
    security.rtkit.enable = true;

    hardware = {
      bluetooth.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    programs = {
      dconf.enable = true; # For Gnome and GTK managing user preferences
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    };

    environment = {
      gnome.excludePackages = (with pkgs; [
        cheese
        gedit
        yelp
        epiphany
        geary
        evince
        totem
        baobab
        seahorse
        snapshot
        gnome-tour
        gnome-connections
        gnome-photos
        gnome-online-accounts
        gnome-system-monitor
        gnome-maps
        gnome-music
        gnome-weather
      ]);
      systemPackages = with pkgs; [
        # desktop requirements
        dunst
        libnotify
        swww
        waybar
        cbatticon
        gnupg
        pinentry-all
        networkmanagerapplet
        nautilus
        playerctl
        brightnessctl
        pwvucontrol
        system-config-printer
        # screenshot requirements
        grim
        slurp
        wl-clipboard
        # openvpn
        # networkmanager-openvpn
        # podman
        # podman-tui
        # podman-compose
      ];
      sessionVariables = {
        # If your cursor becomes invisible
        #WLR_NO_HARDWARE_CURSORS = "1";
        # Hint electron apps to use wayland
        # NIXOS_OZONE_WL = "1";
      };
    };
  };

  flake.modules.homeManager.feature-desktop = { config, lib, pkgs, ... }: {
    imports = [
      ./_hyprland.nix
      ./_hyprlock.nix
      ./_waybar.nix
      flakeConfig.flake.modules.homeManager.feature-browser
      flakeConfig.flake.modules.homeManager.feature-terminal
      flakeConfig.flake.modules.homeManager.feature-launcher
    ];

    # Use catppuccin cursors if available
    catppuccin.cursors.enable = lib.optionalAttrs hasCatppuccin true;
    home.pointerCursor.gtk.enable = true;
    gtk.enable = true;
    qt.enable = true;

    services = {
      dunst.enable = true;
      udiskie.enable = true;
    };

    home.packages = with pkgs; [
      pwvucontrol
      networkmanagerapplet
      brightnessctl
      sxiv
      zathura
      spotify
      telegram-desktop
      signal-desktop
      # libreoffice-still
      # hyphenDicts.de_DE
      # cbatticon
      # bitwarden-desktop
    ];

    xdg = {
      portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = "*";
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "org.pwmt.zathura.desktop";
          "image/jpeg" = "sxiv.desktop";
          "image/png" = "sxiv.desktop";
        };
      };
    };

    # programs.tofi = {
    #   enable = true;
    #   settings = {
    #     font = "Inconsolata Nerd Font";
    #     font-size = 14;
    #     outline-width = 0;
    #     width = "50%";
    #     height = "50%";
    #     border-width = config.wayland.windowManager.hyprland.settings.general.border_size;
    #     corner-radius = config.wayland.windowManager.hyprland.settings.decoration.rounding;
    #     border-color= "#94e2d5";
    #   };
    # };
  };
}
