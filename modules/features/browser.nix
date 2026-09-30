{ inputs, lib, pkgs, ... }:
let
  hasFirefoxAddons = inputs ? firefox-addons;
in
{
  flake.modules.homeManager.feature-browser = { config, lib, pkgs, ... }:
  {
    # config.flake.modules.homeManager.feature-vimium
    home.packages = with pkgs; [ brave ];

    xdg.mimeApps.defaultApplications = {
      "text/html" = lib.mkDefault "firefox.desktop";
      "x-scheme-handler/ipynb" = lib.mkDefault "firefox.desktop";
      "x-scheme-handler/http" = lib.mkDefault "firefox.desktop";
      "x-scheme-handler/https" = lib.mkDefault "firefox.desktop";
      "x-scheme-handler/about" = lib.mkDefault "firefox.desktop";
      "x-scheme-handler/unknown" = lib.mkDefault "firefox.desktop";
    };

    # https://wiki.nixos.org/wiki/Firefox#Configuration
    # https://firefox-admin-docs.mozilla.org/reference/policies/preferences/
    programs.firefox = {
      enable = true;

      languagePacks = [ "en-US" ];

      configPath = ".mozilla/firefox";

      policies = {
        # Updates & Background Services
        AppAutoUpdate                 = false;
        BackgroundAppUpdate           = false;

        # Feature Disabling
        DisableBuiltinPDFViewer       = false;
        DisableFirefoxStudies         = true;
        DisableFirefoxAccounts        = true;
        DisableFirefoxScreenshots     = true;
        DisableForgetButton           = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport          = true;
        DisableProfileRefresh         = true;
        DisableSetDesktopBackground   = true;
        DisablePocket                 = true;
        DisableTelemetry              = true;
        DisableFormHistory            = true;
        DisablePasswordReveal         = true;

        # Access Restrictions
        BlockAboutConfig              = false;
        BlockAboutProfiles            = true;
        BlockAboutSupport             = true;

        # UI and Behavior
        DisplayMenuBar                = "never";
        DontCheckDefaultBrowser       = true;
        HardwareAcceleration          = true;
        OfferToSaveLogins             = false;
        DefaultDownloadDirectory      = "$HOME/Downloads";
        HttpsOnlyMode                 = true;
        EnableTrackingProtection      = true;
        FirefoxHome = {
          Search            = false;
          TopSites          = true;
          SponsoredTopSites = false;
          Highlights        = false;
          Pocket            = false;
          Stories           = false;
          SponsoredPocket   = false;
          SponsoredStories  = false;
          Snippets          = false;
          Widgets.Enabled   = false;
          Locked            = true;
        };
        AIControls = {
          Default = {
            Value = "blocked";
            Locked = true;
          };
          Translations = {
            Value = "available";
            Locked = true;
          };
        };
        GenerativeAI = {
          Enabled = false;
          Locked = true;
        };

        ExtensionSettings =
        let
          # for the short names go to addons.mozilla.org, search the extension, click it,
          # and copy whatever sits between /addon/ and the trailing slash.
          moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
        in
        {
          "*".installation_mode = "blocked";

          "uBlock0@raymondhill.net" = {
            install_url       = moz "ublock-origin";
            installation_mode = "force_installed";
            default_area      = "navbar";
            updates_disabled  = true;
            private_browsing  = true;
          };

          "nordvpnproxy@nordvpn.com" = {
            install_url       = moz "nordvpn-proxy-extension";
            installation_mode = "force_installed";
            default_area      = "navbar";
            updates_disabled  = true;
            private_browsing  = true;
          };

          # Bitwarden Password Manager
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url       = moz "bitwarden-password-manager";
            installation_mode = "force_installed";
            default_area      = "navbar";
            updates_disabled  = true;
            private_browsing  = true;
          };

          # Vimium Key Binds
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url       = moz "vimium-ff";
            installation_mode = "force_installed";
            default_area      = "navbar";
            updates_disabled  = true;
            private_browsing  = true;
          };

          # Hide Shorts for YouTube
          "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}" = {
            install_url       = moz "hide-youtube-shorts";
            installation_mode = "force_installed";
            default_area      = "navbar";
            updates_disabled  = true;
            private_browsing  = true;
          };
        };
      };

      profiles.default.extensions.force = true; # Somehow required
      profiles.default.search = {
        force           = true;
        default         = "ddg";
        privateDefault  = "ddg";

        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type";    value = "packages"; }
                { name = "channel"; value = "unstable"; }
                { name = "query";   value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };

          "Nix Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "type";    value = "options"; }
                { name = "channel"; value = "unstable"; }
                { name = "query";   value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
          };

          "Home Manager Options" = {
            urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}"; }];
            definedAliases = [ "@ho" ];
          };

          "NixOS Wiki" = {
            urls = [{
              template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
            }];
            icon = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };

          "My NixOS" = {
            urls = [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
            definedAliases = [ "@mn" ];
          };

          "Arch Wiki" = {
            urls = [{
              template = "https://wiki.archlinux.org/index.php";
              params = [
                { name = "search"; value = "{searchTerms}"; }
              ];
            }];
            definedAliases = ["@aw"];
          };

          "youtube" = {
            urls = [{
              template = "https://www.youtube.com/results";
              params = [
                { name = "search_query"; value = "{searchTerms}"; }
              ];
            }];
            definedAliases = ["@yt"];
          };

          "LEO" = {
            urls = [{ template = "https://dict.leo.org/german-english/{searchTerms}"; }];
            definedAliases = ["@leo"];
          };

          "Dict.cc" = {
            urls = [{ template = "https://www.dict.cc/?s={searchTerms}"; }];
            definedAliases = ["@dict"];
          };

          "docs.rs" = {
            urls = [{ template = "https://docs.rs/releases/search?query={searchTerms}"; }];
            definedAliases = ["@drs"];
          };

          "Scryfall" = {
            urls = [{ template = "https://scryfall.com/search?q={searchTerms}"; }];
            definedAliases = ["@scry"];
          };

          "google".metaData.alias = "@g";
          "bing".metaData.hidden = true;
        };
      };
    };
  };
}
