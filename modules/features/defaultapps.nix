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

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = lib.mkDefault "org.pwmt.zathura.desktop";
        "image/jpeg"      = lib.mkDefault "sxiv.desktop";
        "image/png"       = lib.mkDefault "sxiv.desktop";

        "text/html"                 = lib.mkDefault "firefox.desktop";
        "x-scheme-handler/ipynb"    = lib.mkDefault "firefox.desktop";
        "x-scheme-handler/http"     = lib.mkDefault "firefox.desktop";
        "x-scheme-handler/https"    = lib.mkDefault "firefox.desktop";
        "x-scheme-handler/about"    = lib.mkDefault "firefox.desktop";
        "x-scheme-handler/unknown"  = lib.mkDefault "firefox.desktop";
      };
    };
  };
}
