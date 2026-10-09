{ inputs, lib, pkgs, ... }:
let
  # https://firefox-admin-docs.mozilla.org/reference/policies/preferences/
  my_policies = {
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

    # Preferences
    Preferences = {
      ui.key.menuAccessKey = -1; # disable Alt as the menu access key
      browser.translations.automaticallyPopup = false;
      browser.translations.neverTranslateLanguages = [ "de" "en" ];
    };

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
    Handlers.mimeTypes."application/pdf".action = "saveToDisk";

    # Set here rather than in profiles.<name>.search so that it applies to
    # every profile, including freshly created ones.
    SearchEngines = {
      Default        = "DuckDuckGo";
      DefaultPrivate = "DuckDuckGo";
      Remove         = [ "Bing" ];
      Add = [
        { Name = "Nix Packages"; Alias = "@np";
          URLTemplate = "https://search.nixos.org/packages?type=packages&channel=unstable&query={searchTerms}";
          IconURL     = "https://search.nixos.org/favicon.png";
        }
        { Name = "Nix Options"; Alias = "@no";
          URLTemplate = "https://search.nixos.org/options?type=options&channel=unstable&query={searchTerms}";
          IconURL     = "https://search.nixos.org/favicon.png";
        }
        { Name = "Home Manager Options"; Alias = "@ho";
          URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}&source=home_manager&type=options";
        }
        { Name = "NixOS Wiki"; Alias = "@nw";
          URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
        }
        { Name = "Arch Wiki"; Alias = "@aw";
          URLTemplate = "https://wiki.archlinux.org/index.php?search={searchTerms}";
          IconURL     = "https://wiki.archlinux.org/favicon.ico";
        }
        { Name = "youtube"; Alias = "@yt";
          URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
          IconURL     = "https://www.youtube.com/favicon.ico";
        }
        { Name = "LEO"; Alias = "@leo";
          URLTemplate = "https://dict.leo.org/german-english/{searchTerms}";
        }
        { Name = "Dict.cc"; Alias = "@dict";
          URLTemplate = "https://www.dict.cc/?s={searchTerms}";
          IconURL     = "https://www.dict.cc/favicon.ico";
        }
        { Name = "docs.rs"; Alias = "@drs";
          URLTemplate = "https://docs.rs/releases/search?query={searchTerms}";
          IconURL     = "https://docs.rs/favicon.ico";
        }
        { Name = "Scryfall"; Alias = "@scry";
          URLTemplate = "https://scryfall.com/search?q={searchTerms}";
          IconURL     = "https://scryfall.com/favicon.ico";
        }
      ];
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

      # I Still Don't Care About Cookies
      "idcac-pub@guus.ninja" = {
        install_url       = moz "istilldontcareaboutcookies";
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
in
{
  flake.modules.homeManager.feature-browser = { config, lib, pkgs, ... }:
  {
    # https://wiki.nixos.org/wiki/Firefox#Configuration
    programs.firefox = {
      enable = true;

      languagePacks = [ "en-US" ];

      configPath = ".mozilla/firefox";

      policies = my_policies;
    };

    # Zen Browser
    home.packages = with pkgs; [(
      pkgs.wrapFirefox
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
        { extraPolicies = my_policies; }
    )];
  };
}
