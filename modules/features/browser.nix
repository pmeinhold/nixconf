{ inputs, lib, pkgs, ... }:
let
  hasFirefoxAddons = inputs ? firefox-addons;
in
{
  flake.modules.homeManager.feature-browser = { lib, pkgs, ... }:
  {
    programs.chromium = {
      enable = true;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # Ublock Origin
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      ];
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = lib.mkDefault "firefox.desktop";
      "x-scheme-handler/ipynb" = lib.mkDefault "firefox.desktop";
      "x-scheme-handler/http" = lib.mkDefault "firefox.desktop";
      "x-scheme-handler/https" = lib.mkDefault "firefox.desktop";
      "x-scheme-handler/about" = lib.mkDefault "firefox.desktop";
      "x-scheme-handler/unknown" = lib.mkDefault "firefox.desktop";
    };

    home.file.".config/vimium-options.json" = {
      text = builtins.toJSON {
        keyMappings = ''
          # Insert your preferred key mappings here.

          unmapAll
          map <a-h> previousTab
          map <a-l> nextTab
          map <a-L> moveTabRight
          map <a-H> moveTabLeft
          map <a-u> restoreTab
          map <a-f> LinkHints.activateMode
          map <a-F> LinkHints.activateModeToOpenInNewTab
          map <a-r> reload
          map gg scrollToTop
          map G scrollToBottom
          map j scrollDown
          map k scrollUp
          map h scrollLeft
          map l scrollRight
          map <a-c-u> scrollPageUp
          map <a-c-d> scrollPageDown
          map yy copyCurrentUrl
          map H goBack
          map L goForward
        '';

        searchEngines = ''
          # w: https://www.wikipedia.org/w/index.php?title=Special:Search&search=%s Wikipedia

          # More examples.
          #
          # (Vimium supports search completion Wikipedia, as
          # above, and for these.)
          # d: https://duckduckgo.com/?q=%s DuckDuckGo
        '';

        settingsVersion = "2.3.1";
        exclusionRules = [];
      };
    };

    programs.firefox.enable = true;
    programs.firefox.profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      extensions = {
        force = true;
        packages = with inputs.firefox-addons.packages."x86_64-linux"; lib.optionals hasFirefoxAddons [
          bitwarden
          vimium
          istilldontcareaboutcookies
          ublock-origin
          darkreader
          # vimium config location:
          # .mozilla/firefox/default/browser-extension-data/\{d7742d87-e61d-4b78-b8a1-b469842139fa\}/storage.js
          # youtube-shorts-block
          # user-agent-string-switcher
          # fakespot-fake-reviews-amazon
        ];
      };
      settings = {
        "signon.rememberSignons" = false;
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enabled" = false;
        "privacy.trackingprotection.enabled" = true;
        "browser.disableResetPrompt" = true;
        "browser.startup.homepage" = "about:home";
        "browser.download.panel.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "ui.key.menuAccessKeyFocuses" = false;
        "ui.key.menuAccessKey" = -1;
        "browser.uiCustomization.state" = ''
          {"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":[],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","unified-extensions-button","fxa-toolbar-menu-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","idcac-pub_guus_ninja-browser-action","ublock0_raymondhill_net-browser-action","_34daeb50-c2d2-4f14-886a-7160b24d66a4_-browser-action","addon_darkreader_org-browser-action","_44df5123-f715-9146-bfaa-c6e8d4461d44_-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"vertical-tabs":[],"PersonalToolbar":["personal-bookmarks"]},"seen":["save-to-pocket-button","idcac-pub_guus_ninja-browser-action","ublock0_raymondhill_net-browser-action","_34daeb50-c2d2-4f14-886a-7160b24d66a4_-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","developer-button","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","addon_darkreader_org-browser-action","_44df5123-f715-9146-bfaa-c6e8d4461d44_-browser-action"],"dirtyAreaCache":["unified-extensions-area","nav-bar","TabsToolbar","toolbar-menubar","vertical-tabs","PersonalToolbar"],"currentVersion":20,"newElementCount":4}
        '';
      };
      search = {
        force = true;
        default = "ddg";
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
