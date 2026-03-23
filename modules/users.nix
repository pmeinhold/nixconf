{ config, inputs, ... }:
{
  flake.homeConfigurations."paulm@x220" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-kmonad-miryoku

      ({ ... }: {
        home.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@srvr" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell

      ({ ... }: {
        home.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@vps0" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell

      ({ ... }: {
        home.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@lars" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-emulation

      ({ pkgs, ... }: {
        programs.retroarch.settings = {
          video_driver = "glcore"; # vulkan, glcore, gl, gl1, sdl
        };
        home.packages = with pkgs; [
          stretchly
          prismlauncher # minecraft
          discord
        ];
        home.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@tini" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-emulation

      ({ pkgs, ... }: {
        programs.retroarch.settings.video_driver = "glcore"; # vulkan, glcore, gl, gl1, sdl
        home.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@deck" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-emulation

      ({ ... }: {
        wayland.windowManager.hyprland.settings.monitor = [ "eDP-1, 800x1280@60, auto, 1, transform, 3" ];
        home.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."pmeinhold@opt" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-browser
      config.flake.modules.homeManager.feature-terminal
      config.flake.modules.homeManager.feature-defaultapps

      ({ lib, pkgs, ... }: {
        home = {
          stateVersion = "25.11";
          username = "pmeinhold";
          homeDirectory = "/home/optimi/pmeinhold";
          packages = with pkgs; [ nix ];
        };
        targets.genericLinux.enable = true;
        programs.foot.server.enable = lib.mkForce false;
      })

    ];
  };

  flake.homeConfigurations."pmeinhold@mob" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-browser
      config.flake.modules.homeManager.feature-terminal
      config.flake.modules.homeManager.feature-defaultapps

      ({ lib, pkgs, ... }: {
        home = {
          stateVersion = "25.11";
          username = "pmeinhold";
          homeDirectory = "/home/pmeinhold";
          packages = with pkgs; [
            nix
            openvpn
          ];
        };
        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            "application/pdf" = "firefox.desktop";
            "image/jpeg" = "sxiv.desktop";
            "image/png" = "sxiv.desktop";
          };
        };
        targets.genericLinux.enable = true;
        programs.foot.server.enable = lib.mkForce false;
      })

    ];
  };

  flake.homeConfigurations."pmeinhold@z1" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell

      ({ pkgs, ... }: {
        home = {
          stateVersion = "25.11";
          username = "pmeinhold";
          homeDirectory = "/home/htc/pmeinhold";
          packages = with pkgs; [ nix ];
        };
        targets.genericLinux.enable = true;
        programs.fish.interactiveShellInit = ''
          # initialize conda manually
          eval /opt/conda/bin/conda "shell.fish" "hook" $argv | source
        '';
      })

    ];
  };

  flake.homeConfigurations.rie = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-desktop

      ({ pkgs, ... }: {
        home = {
          stateVersion = "25.11";
          username = "rie";
          homeDirectory = "/home/rie";
          packages = with pkgs; [
            vim
            python3
          ];
        };
        programs.neovim.enable = false;
        wayland.windowManager.hyprland.settings.input.kb_layout = "de";
      })

    ];
  };
}
