{ ... }:
{
  flake.modules.homeManager.feature-vimium = { ... }:
  {
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

        settingsVersion = "2.4.2";
        exclusionRules = [];
      };
    };
  };
}
