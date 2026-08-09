{ config, inputs, ... }:
{
  flake.modules.nixos.feature-gnome = { lib, pkgs, ... }:
  {
    # For Gnome and GTK managing user preferences
    programs.dconf.enable = true;

    # To disable installing GNOME's suite of applications and only be left with GNOME shell.
    services.gnome.core-apps.enable = false;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
    ];

    # Extensions
    environment.systemPackages = with pkgs; [
      gnomeExtensions.tailscale
    ];

    # environment.gnome.excludePackages = with pkgs; [
    #   cheese
    #   gedit
    #   yelp
    #   epiphany
    #   geary
    #   evince
    #   totem
    #   baobab
    #   seahorse
    #   snapshot
    #   gnome-tour
    #   gnome-connections
    #   gnome-photos
    #   gnome-online-accounts
    #   gnome-system-monitor
    #   gnome-maps
    #   gnome-music
    #   gnome-weather
    # ];
  };

  flake.modules.homeManager.feature-gnome = { lib, pkgs, ... }:
  {
  };
}
