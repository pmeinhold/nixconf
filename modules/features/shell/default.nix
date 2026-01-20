{ ... }:
{
  flake.modules.homeManager.feature-shell = { lib, pkgs, ... }:
  {
    imports = [
      ./_neovim.nix
      ./_tmux.nix
      ./_ssh.nix
      ./_editorconfig.nix
    ];

    home.packages = with pkgs; [
      sshfs
      unzip
      tree
      bitwarden-cli
      geteduroam-cli
    ];

    # SHELL
    programs.fish = {
      enable = true;
      shellAliases = {
        "za" = "zellij a";
      };
      interactiveShellInit = #fish
      ''
        fish_vi_key_bindings
        set -U fish_greeting
      '';
    };
    programs.yazi.enable = true;
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.git = {
      enable = true;
      ignores = [ ".direnv" ".envrc" ];
    };
    programs.btop = {
      enable = true;
      settings.vim_keys = true;
    };
    programs.starship = { # https://starship.rs/config/
      enable = true;
      settings = {
        add_newline = false;
        format = "$username@$hostname $directory $nix_shell$character";
        right_format = "$git_branch";
        username = {
          show_always = true;
          format = "[$user](teal)";
        };
        hostname = {
          ssh_only = false;
          format = "[$ssh_symbol$hostname](blue)";
        };
        directory = {
          format = "[$path](yellow)";
          truncate_to_repo = false;
          truncation_symbol = "…/";
        };
        nix_shell.format = "[󱄅 ](blue)";
        git_branch.format = "[ $branch(:$remote_branch)](teal)";
      };
    };
  };
}
