{ ... }:
{
  flake.modules.homeManager.feature-tmux = { pkgs, lib, ... }:
  let
    # Full keybinding reference, paged. Used both as a prefix binding and as a
    # row in the which-key menu below, hence the let-binding.
    #   -aN      also lists binds carrying no note; plain -N hides them, which
    #            would drop sesh's key (the sesh module binds it without one).
    #   2 tables  the M-* fast paths live in root, not prefix.
    #   grep -v   else the root table is ~20 lines of mouse bindings whose
    #            inline display-menu bodies run to hundreds of characters.
    #   less -S   chop long lines to one screen row rather than wrapping.
    # `sh -c` because display-popup uses 'default-shell', which is fish here.
    keysPopup = ''
      display-popup -E -w 80% -h 80% -T " keybindings " "sh -c 'tmux list-keys -aN -T prefix; echo; tmux list-keys -aN -T root' | grep -vE 'Mouse|Wheel|Click' | less -S"'';

    # The sesh picker, lifted verbatim out of what
    # programs.sesh.enableTmuxIntegration generates. It lives in its own
    # script for two reasons: the pipeline contains `{2..}`, a literal brace
    # pair that tmux's command-block parser would try to read as a nested
    # block if it were inlined into a display-menu entry; and this way the
    # menu row and the prefix binding below are the same single definition.
    # enableTmuxIntegration is therefore off -- otherwise the module would add
    # a second, independently-maintained copy of this on the prefix table.
    seshConnect = pkgs.writeShellScript "sesh-connect" ''
      sesh connect "$(
        sesh list --icons | fzf --tmux 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list --icons -t)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list --icons -c)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list --icons -z)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}' \
          -- --ansi
      )"
    '';

    # which-key, one source of truth. Every entry below becomes BOTH a real
    # tmux binding and a row in the M-Enter menu, generated from the same
    # data -- so the menu cannot drift from the bindings. That is precisely
    # what tmux-which-key could not do: its config.yaml was a second,
    # hand-synced copy that never saw the real key tables.
    #
    #   key    selects the row in the menu, and is the key that gets bound
    #   desc   menu label, and the -N note that `list-keys -N` prints
    #   cmd    tmux command(s) to run
    #   root   also bind prefix-free in the root table, as a fast path you
    #          can hit without opening the menu first (default false)
    #   prefix also bind in the C-b prefix table (default false)
    #   menu   include a row in the menu (default true)
    #   sep    horizontal rule instead of an entry
    wk = [
      # Windows
      { key = "Enter";     desc = "New window";           cmd = "new-window"; }
      { key = "M-S-Enter"; desc = "New window";           cmd = "new-window";      root = true; menu = false; }
      { key = "M-l";       desc = "Next window";          cmd = "next-window";     root = true; }
      { key = "M-h";       desc = "Previous window";      cmd = "previous-window"; root = true; }
      { key = ",";         desc = "Rename window";        cmd = ''command-prompt -I "#W" { rename-window "%%" }''; }
      { key = "&";         desc = "Kill window";          cmd = ''confirm-before -p "kill window #W? (y/n)" kill-window''; }
      { sep = true; }
      # Panes
      { key = "-";         desc = "Split below";          cmd = "split-window -v"; }
      { key = "|";         desc = "Split right";          cmd = "split-window -h"; }
      { key = "z";         desc = "Zoom pane";            cmd = "resize-pane -Z"; }
      { key = "x";         desc = "Kill pane";            cmd = "kill-pane"; }
      { sep = true; }
      # Sessions and misc
      { key = "s";         desc = "Sessions (sesh)";      cmd = ''run-shell "${seshConnect}"''; prefix = true; }
      { key = "w";         desc = "Choose window/session"; cmd = "choose-tree -Zs"; }
      { key = "[";         desc = "Copy mode";            cmd = "copy-mode"; }
      { key = "M-q";       desc = "Detach client";        cmd = "detach-client";   root = true; }
      { key = "M-:";       desc = "Command prompt";       cmd = "command-prompt";  root = true; }
      { sep = true; }
      { key = "?";         desc = "List all keybindings"; cmd = keysPopup; }
    ];

    # Brace-delimited commands, so a cmd containing quotes needs no escaping.
    mkRow = e: if e ? sep then ''""'' else ''"${e.desc}" ${e.key} { ${e.cmd} }'';
    wkMenu = ''display-menu -T " tmux " -x C -y C ''
      + lib.concatStringsSep " " (map mkRow (lib.filter (e: e.menu or true) wk));

    wkBinds = lib.concatStringsSep "\n" (
         map (e: ''bind-key -n -N "${e.desc}" ${e.key} ${e.cmd}'') (lib.filter (e: e.root   or false) wk)
      ++ map (e: ''bind-key    -N "${e.desc}" ${e.key} ${e.cmd}'') (lib.filter (e: e.prefix or false) wk)
    );
  in
  # Multiplexer Duties
  # - Multiplexing (tabs, panes, etc.)
  # - Sessions
  # - Handle scrollback and scrolling
  # - Copy/Paste to/from the system that zellij runs on

  {
    programs.sesh = {
      enable = true;
      # The tmux binding is defined in the `wk` list instead, so the picker is
      # one definition shared by the M-Enter menu row and the C-b s binding.
      # Left on, this module appends its own `bind-key s` *after* extraConfig
      # and silently wins, giving two divergent copies of the same picker.
      enableTmuxIntegration = false;
      settings = {
        "Downloads" = {
          startup_command = "yazi";
        };
      };
    };

    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };

    programs.tmux = {
      enable = true;
      mouse = true;
      terminal = "tmux-256color";
      # prefix = "M-Space";
      # prefix = "M-Enter";
      #
      # M-Enter is now the which-key trigger instead of the prefix. It cannot
      # be both: tmux checks the prefix key *before* consulting the root key
      # table, so a root binding on the prefix key never fires -- verified,
      # it just switches to the prefix table as usual. C-b stays as a plain
      # prefix so tmux's ~90 default prefix bindings remain reachable for
      # anything the menu does not cover (including sesh on C-b s).
      prefix = "C-b";
      plugins = with pkgs.tmuxPlugins; [
        sensible
      ];
      extraConfig = #bash
      ''
        set-option -sa terminal-overrides ",xterm*:Tc"
        set-option -g status-position top

        # Prefix-free fast paths, generated from `wk` -- the same list that
        # builds the menu. The -N notes are what `list-keys -N` renders.
        ${wkBinds}

        # which-key. display-menu (not display-popup) is the primitive that
        # makes this work: a popup is a pane, so it swallows every keystroke
        # for its own process, whereas display-menu captures single keys,
        # dispatches them to commands, and closes itself. Press M-Enter, press
        # Enter, you get a new window and the menu disappears.
        bind-key -n -N "which-key menu" M-Enter ${wkMenu}

        # Full reference, also reachable as `?` inside the menu above.
        bind-key -N "List all keybindings" ? ${keysPopup}

        # Catppuccin
        set -g @catppuccin_window_status_style "rounded" #"basic"
        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_application}"
        set -ag status-right "#{E:@catppuccin_status_session}"
        # set -ag status-right "#{E:@catppuccin_status_uptime}"
        # set -agF status-right "#{E:@catppuccin_status_cpu}"
        # set -agF status-right "#{E:@catppuccin_status_battery}"
      '';
    };

    programs.zellij = {
      enable = false; # Enable this if KDL conversion has improved
      settings = {
        simplified_ui   = true;
        mouse_mode      = true;
        copy_on_select  = true;
        pane_frames     = false;
        default_layout  = "compact";
        keybinds = {
          _props.clear-defaults = true;
          shared._children = [
            { bind = { _args = [ "Alt Enter" ]; NewPane = {}; }; }
            { bind = { _args = [ "Alt j" ]; FocusNextPane = {}; }; }
            { bind = { _args = [ "Alt k" ]; FocusPreviousPane = {}; }; }
            { bind = { _args = [ "Alt Shift Enter" ]; NewTab = {}; }; }
            { bind = { _args = [ "Alt h" ]; GoToPreviousTab = {}; }; }
            { bind = { _args = [ "Alt l" ]; GoToNextTab = {}; }; }
            { bind = { _args = [ "Alt Shift h" ]; MoveTab = ["Left"]; }; }
            { bind = { _args = [ "Alt Shift l" ]; MoveTab = ["Right"]; }; }
            { bind = { _args = [ "Alt n" ]; NewPane = {}; }; }
            { bind = { _args = [ "Alt q" ]; Detach = {}; }; }
            { bind = { _args = [ "Alt Ctrl u" ]; PageScrollUp = {}; }; }
            { bind = { _args = [ "Alt Ctrl d" ]; PageScrollDown = {}; }; }
            {
              bind = {
                _args = [ "Alt f" ];
                _children = [
                  {
                    LaunchOrFocusPlugin = {
                      _args = [ "session-manager" ];
                      _children = [ { floating = true; } { move_to_focused_tab = true; } ];
                    };
                  }
                  { SwitchToMode = ["Normal"]; }
                ];
              };
            }
          ];
        };
      };
    };
  };
    #           bind "Alt Shift r"      { SwitchToMode "RenameTab"; TabNameInput 0; }
    #           bind "Alt Ctrl j" { ScrollDown; }
    #           bind "Alt Ctrl k" { ScrollUp; }
    #           bind "Alt Ctrl h" { HalfPageScrollUp; }
    #           bind "Alt Ctrl l" { HalfPageScrollDown; }
    #           bind "Alt Ctrl e" { EditScrollback; }
    #           bind "Alt Ctrl Down" { ScrollDown; }
    #           bind "Alt Ctrl Up" { ScrollUp; }
    #           bind "PageDown"   { PageScrollDown; }
    #           bind "PageUp"     { PageScrollUp; }
    #           bind "Home"       { ScrollToTop; }
    #           bind "End"        { ScrollToBottom; }
}
