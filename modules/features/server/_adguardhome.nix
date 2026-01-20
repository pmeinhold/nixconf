{ config, lib, pkgs, ... }:

{
  services.adguardhome = {
    enable = true;
    mutableSettings = true;
    openFirewall = true;
    #allowDHCP = false;
    #port = ;
    #host = "";
    settings = {
      http.address = "";
      users = [
        {
          name = "";
          password = "";
        }
      ];
      dns = {
        upstream_dns = [
          "https://dns10.quad9.net/dns-query"
          "1.1.1.1"
        ];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        # not wanting:
        parental_enabled = false;
        safe_search.enabled = false;
      };
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
        }
      ];
    };
  };
}
