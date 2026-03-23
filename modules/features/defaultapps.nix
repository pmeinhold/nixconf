{ config, inputs, ... }:
{
  flake.modules.homeManager.feature-defaultapps = { config, lib, pkgs, ... }: {
    home.packages = with pkgs; [
      zathura
      sxiv
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = lib.mkDefault {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/jpeg" = "sxiv.desktop";
        "image/png" = "sxiv.desktop";
      };
    };
  };
}
