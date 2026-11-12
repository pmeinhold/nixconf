{ config, inputs, ... }:
{
  flake.modules.homeManager.feature-defaultapps = { config, lib, pkgs, ... }: {
    home.packages = with pkgs; [
      # zathura
      sxiv
    ];

    programs.zathura = {
      enable = true;
      options = {
        "selection-clipboard" = "clipboard";
      };
    };

    # https://wiki.nixos.org/wiki/Default_applications

    # ls ~/.nix-profile/share/applications # for home-manager packages
    # ls /run/current-system/sw/share/applications # for global packages
    # ls /etc/profiles/per-user/$(id -n -u)/share/applications # for user packages
    # ls /var/lib/flatpak/exports/share/applications # for global flatpaks
    # ls ~/.local/share/flatpak/exports/share/applications/ # for user flatpaks
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = lib.mkDefault "org.pwmt.zathura.desktop";
        "image/jpeg"      = lib.mkDefault "sxiv.desktop";
        "image/png"       = lib.mkDefault "sxiv.desktop";

        "text/html"                 = lib.mkDefault "zen.desktop";
        "x-scheme-handler/ipynb"    = lib.mkDefault "zen.desktop";
        "x-scheme-handler/http"     = lib.mkDefault "zen.desktop";
        "x-scheme-handler/https"    = lib.mkDefault "zen.desktop";
        "x-scheme-handler/about"    = lib.mkDefault "zen.desktop";
        "x-scheme-handler/unknown"  = lib.mkDefault "zen.desktop";
      };
    };
  };
}
