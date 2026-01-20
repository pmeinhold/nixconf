# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, stateVersion, ... }:

{
  imports = [ ];

  environment.systemPackages = with pkgs; [ ];

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };
    # https://nixos.wiki/wiki/Nvidia
    # GeForce MX150 is Pascal (Chip GP108): https://www.notebookcheck.com/NVIDIA-GeForce-MX150-GPU-Benchmarks-und-Specs-der-GT-1030-fuer-Laptops.223528.0.html
    # I.e., older than Turing: https://en.wikipedia.org/wiki/Pascal_(microarchitecture)
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false; # NVIDIA will be on full-time
      powerManagement.finegrained = false;
      open = false; # Only set to false if older than Turing architecture (2018)
      nvidiaSettings = true;
      prime = {
        sync.enable = true;
        # find out by 'sudo lshw -c display' (and convert to decimal)
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    throttled.enable = true;
    tailscale.useRoutingFeatures = "client";
    logind = {
      lidSwitch = "lock";
      lidSwitchExternalPower = "lock";
      lidSwitchDocked = "lock";
    };
    tlp = {
      enable = false;
      settings = {
        #Optional helps save long term battery health
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        STOP_CHARGE_THRESH_BAT1 = 80;
        # START_CHARGE_THRESH_BAT0 = 80; # this and bellow it starts to charge
        # START_CHARGE_THRESH_BAT1 = 80;

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # CPU_MIN_PERF_ON_AC = 0;
        # CPU_MAX_PERF_ON_AC = 100;
        # CPU_MIN_PERF_ON_BAT = 0;
        # CPU_MAX_PERF_ON_BAT = 20;
      };
    };
  };

  i18n = {
    #defaultLocale = "en_US.UTF-8";
    defaultLocale = "de_DE.UTF-8";
    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  system.stateVersion = stateVersion;
}
