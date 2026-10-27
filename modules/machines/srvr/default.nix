{ lib, config, inputs, ... }:
let
  domaina = "meinhold.duckdns.org";
  domainb = "getintogig.duckdns.org";
  domainc = "random123test.duckdns.org";
  domain = domainc;
  tailnetip = "http://srvr.tail70fe0.ts.net";
  username = "paulm";
in
{
  flake.nixosConfigurations.srvr = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.feature-base
      config.flake.modules.nixos.feature-syncthing
      config.flake.modules.nixos.feature-hdidle
      config.flake.modules.nixos.feature-mergerfs
      config.flake.modules.nixos.feature-snapraid
      config.flake.modules.nixos.feature-immich

      ({ config, lib, pkgs, ... }: {
        networking.hostName = "srvr";

        boot.loader.systemd-boot.enable = true;
        # EHL/JSL: HuC loading is disabled by default since kernel 5.8, required for the
        # low-power hw encoder this chip needs. https://github.com/intel/media-driver#enablingdisabling-features
        hardware.enableRedistributableFirmware = true;
        boot.kernelParams = [ "i915.enable_guc=2" ];

        services.jellyfin = {
          enable = true;
          openFirewall = true;
          user = username;
          hardwareAcceleration = {
            enable = true;
            device = "/dev/dri/by-path/pci-0000:00:02.0-render";
            # Use vaapi because Quick Sync (QSV) support is deprecated for Jasper Lake :(
            # https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/intel
            type = "vaapi";
          };
          # Supported codecs: https://github.com/intel/media-driver#decodingencoding-features
          # AV1 is not in either list - Jasper Lake (Gen11) has no AV1 decode/encode hardware at all.
          forceEncodingConfig = true; # Overwrite any WebUI changes to the transcoding settings
          transcoding = {
            enableHardwareEncoding = true;
            # Gen11 JSL/EHL graphics only support the low-power encoder, unlike e.g. Ice Lake which supports both.
            enableIntelLowPowerEncoding = true;
            hardwareDecodingCodecs = {
              h264 = true;
              hevc = true;
              hevc10bit = true;
            };
            hardwareEncodingCodecs = {
              # h264 encoding is always enabled by Jellyfin; not a valid option here.
              hevc = true;
            };
          };
        };
        environment.systemPackages = [ pkgs.jellyfin-ffmpeg ]; # jellyfin fork of ffmpeg
        environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
        systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
        users.users.${username}.extraGroups = [ "video" "render" ]; # for jellyfin VAAPI access to /dev/dri

        hardware.graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver            # For Broadwell and newer (ca. 2014+), use with LIBVA_DRIVER_NAME=iHD
            intel-compute-runtime-legacy1 # OpenCL driver for processors older than 13th gen but somewhat new
            # We have the Intel Celeron N5105 with QuickSync belonging to the Jasper Lake architecture (which is post-Broadwell by being launched in 2021)
            # "It includes the Intel Gen11 graphics architecture from Ice Lake" - Wikipedia
            #
            # https://www.intel.com/content/www/us/en/products/sku/212328/intel-celeron-processor-n5105-4m-cache-up-to-2-90-ghz/specifications.html
            # https://en.wikipedia.org/wiki/Tremont_(microarchitecture)
            # https://wiki.nixos.org/wiki/Jellyfin
            # https://wiki.nixos.org/wiki/Intel_Graphics
            # For info, try "nix-shell -p intel-gpu-tools --run intel_gpu_top"
          ];
        };

        users.users = {
          read = {
            isNormalUser = true;
            home = "/home/read";
          };
          rie = {
            isNormalUser = true;
            home = "/home/rie";
          };
        };

        networking.firewall = {
          enable = true;
          allowedTCPPorts = [
            28981
            69
            5232
            80
            443
            # 53 # DNS
          ];
          allowedUDPPorts = [
            # 53 # DNS
          ];
        };

        services = {
          tailscale.useRoutingFeatures = "server";
          openssh = {
            enable = true;
            ports = [ 69 ];
            settings = {
              PermitRootLogin = "no";
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
            };
            extraConfig = ''
              Match User read
              PasswordAuthentication yes
              Match all

              Match User rie
              PasswordAuthentication yes
              Match all
            '';
          };
          radicale = {
            enable = true;
            settings = {
              server.hosts = [ "0.0.0.0:5232" "[::]:5232" ];
              auth = {
                type = "htpasswd";
                # Set password with 'htpasswd -B' (with bcrypt) provided by the 'apacheHttpd' package
                htpasswd_filename = "/etc/radicale/users";
                htpasswd_encryption = "bcrypt";
              };
              storage = {
                filesystem_folder = "/var/lib/radicale/collections";
              };
            };
          };
          microbin = {
            enable = true;
            settings = {
              MICROBIN_BIND = "0.0.0.0";
              MICROBIN_PORT = 8081;
              MICROBIN_PUBLIC_PATH = "https://microbin.${domain}";
              MICROBIN_DISABLE_TELEMETRY = true;
            };
          };
          audiobookshelf = {
            enable = true;
            port = 8000;
            host = "0.0.0.0";
            openFirewall = true;
            user = "${username}";
          };
          komga = {
            enable = true;
            openFirewall = true;
            user = "${username}";
            settings = {
              server.port = 8079;
            };
          };
          paperless = {
            enable = true;
            port = 28981;
            domain = "paperless.${domain}";
            address = "0.0.0.0";
            user = "${username}";
            mediaDir = "/mnt/storage/Paperless";
            settings = {
              PAPERLESS_CONSUMER_IGNORE_PATTERN = [
                ".DS_STORE/*"
                "desktop.ini"
              ];
              PAPERLESS_OCR_LANGUAGE = "deu+eng";
              PAPERLESS_OCR_USER_ARGS = {
                optimize = 1;
                pdfa_image_compression = "lossless";
              };
              # PAPERLESS_BIND_ADDR="0.0.0.0";
              #PAPERLESS_URL = "http://srvr:28981";
              #PAPERLESS_URL = "https://paperless.example.com";
            };
          };
          vaultwarden = { };
        };

        age.secrets.duckdns_token = {
          file = ../../../secrets/duckdns_token.age;
          owner = "caddy";
        };
        services.caddy = {
          enable = true;
          environmentFile = config.age.secrets.duckdns_token.path;
          package = pkgs.caddy.withPlugins {
            plugins = [ "github.com/caddy-dns/duckdns@v0.5.0" ];
            hash = "sha256-hdJoUoWpDZEz367Rwhagz5040TMHBReLY+hhHjMfwgM=";
          };
          # virtualHosts."${...}".extraConfig = ''
          #   tls {
          #     dns duckdns {env.DUCKDNS_TOKEN}
          #   }
          #   reverse_proxy ${tailnetip}:2283
          # '';
          virtualHosts."*.${domain}".extraConfig = ''
            tls {
              dns duckdns {env.DUCKDNS_TOKEN}
            }
            @immich host immich.${domain}
            handle @immich {
              reverse_proxy ${tailnetip}:2283
            }
            @jf host jf.${domain}
            handle @jf {
              reverse_proxy ${tailnetip}:8096
            }
            handle {
              abort
            }
          '';
        };
        system.stateVersion = "25.11";
      })
    ];
  };
}
