{ config, inputs, ... }:
{
  flake.homeConfigurations."paulm@t480" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-kmonad-miryoku

      ({ ... }: {
        # wayland.windowManager.hyprland.settings.monitor = [
        #   "DP-1,  3440x1440@60, auto, 1"
        #   "eDP-1, 1920x1080@60, auto, 1, mirror, DP-1"
        # ];
        # programs.waybar.settings.mainBar."battery".bat = "BAT0";
        home.stateVersion = "25.11";
      })
    ];
  };

  flake.homeConfigurations."paulm@x220" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-desktop
      config.flake.modules.homeManager.feature-kmonad-miryoku

      ({ ... }: {
        feature.kmonad.miryoku.thumbRow = "lalt spc tab ralt cmp del";
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
          prismlauncher # minecraft
          discord
        ];
        home.stateVersion = "25.11";
      })

    ];
  };

  flake.homeConfigurations."paulm@deck" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      config.flake.modules.homeManager.feature-base
      config.flake.modules.homeManager.feature-shell
      config.flake.modules.homeManager.feature-gnome
      config.flake.modules.homeManager.feature-browser
      config.flake.modules.homeManager.feature-terminal
      config.flake.modules.homeManager.feature-emulation

      ({ ... }: {
        services.udiskie.enable = true;
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
      config.flake.modules.homeManager.feature-kmonad-miryoku

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
          packages = with pkgs; [
            nix
            home-manager
          ];
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
        # wayland.windowManager.hyprland.settings.input.kb_layout = "de";
      })

    ];
  };
}
