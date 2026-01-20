{ lib, config, inputs, ... }:
let
  domain = "getintogig.duckdns.org";
  username = "paulm";
in
{
  flake.nixosConfigurations.srvr = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.feature-base
      config.flake.modules.nixos.feature-server

      ({ config, lib, pkgs, ... }: {
        networking.hostName = "srvr";

        boot.loader.systemd-boot.enable = true;

        environment = {
          systemPackages = with pkgs; [ ];
          sessionVariables = { LIBVA_DIVER_NAME = "iHD"; };
        };

        systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD"; # or i965
        services.jellyfin.user = username;
        hardware.graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-ocl
            intel-media-driver
            # intel-compute-runtime # for newer processors (>=13th gen)
            intel-compute-runtime-legacy1
            vpl-gpu-rt # for newer processors (>=11th gen)
            # https://github.com/intel/libvpl?tab=readme-ov-file#dispatcher-behavior-when-targeting-intel-gpus
            # https://www.intel.com/content/www/us/en/products/sku/212328/intel-celeron-processor-n5105-4m-cache-up-to-2-90-ghz/specifications.html
            # intel-media-sdk # Enable QuickSyncVideo (QSV)

            # TODO: Need to update soon. Read: https://wiki.nixos.org/wiki/Jellyfin
            # intel-vaapi-driver
            # intel-vdpau-driver
          ];
        };
        # Only set this if you're using intel-vaapi-driver
        # nixpkgs.config.packageOverrides = pkgs: {
        #   intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
        # };
        # Do 'nix-shell -p intel-gpu-tools --run intel_gpu_top' for info

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
          vaultwarden = {
          };
        };

        virtualisation.oci-containers = {
          backend = "podman";

          # Nginx-Proxy-Manager for reverse-proxy
          containers.nginx-proxy-manager = {
            image = "jc21/nginx-proxy-manager:latest";
            ports = [ "80:80" "443:443" "81:81" ];
            # autoStart = true;
            volumes = [
              "/var/lib/nginx-proxy-manager/data:/data"
              "/var/lib/nginx-proxy-manager/letsencrypt:/etc/letsencrypt"
            ];
            # Optional environment variables
            environment = {
              # "DB_SQLITE_FILE" = "/data/database.sqlite";
              # "DISABLE_IPV6" = "true";
            };
          };
        };
        systemd.tmpfiles.rules = [
          "d /var/lib/nginx-proxy-manager 0755 root root -"
          "d /var/lib/nginx-proxy-manager/data 0755 root root -"
          "d /var/lib/nginx-proxy-manager/letsencrypt 0755 root root -"
        ];

        system.stateVersion = "25.11";
      })

    ];
  };
}
