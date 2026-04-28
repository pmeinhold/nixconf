{ config, inputs, ... }:
{
  flake.modules.homeManager.feature-defaultapps = { config, lib, pkgs, ... }: {
    home.packages = with pkgs; [
      zathura
      sxiv
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = lib.mkDefault "org.pwmt.zathura.desktop";
        "image/jpeg"      = lib.mkDefault "sxiv.desktop";
        "image/png"       = lib.mkDefault "sxiv.desktop";
      };
    };
  };
}
