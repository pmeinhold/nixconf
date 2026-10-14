{ inputs, ... }:
{
  flake.modules.homeManager.feature-neovim = { config, lib, pkgs, ... }:
  {
    imports = [
      inputs.nixvim-unstable.homeModules.nixvim
    ];

    home.packages = with pkgs; [
      ripgrep
    ];

    programs.nixvim = {
      enable = lib.mkDefault true;
      vimAlias = true;
      defaultEditor = true;
      withPython3 = false;
      withRuby = false;
      clipboard.register = "unnamedplus";

      colorschemes.catppuccin = {
        enable = true;
        settings.flavour = "mocha";
      };

      globals = {
        mapleader = " ";      # Space
        maplocalleader = ","; # Comma
      };

      opts = {
        number = true;
        relativenumber = true;
        wrap = false;
        cursorline = true;
        splitbelow = true;
        splitright = true;
        termguicolors = true;
        colorcolumn = "100";  # Rust style guide: max line width is 100
        scrolloff = 8;        # minimum nr. of lines above and below cursor
        ignorecase = true;
        showmatch = true;     # briefly jump to matching bracket if insert one
        foldlevel = 99;
      };

      plugins = {
        comment.enable = true;
        which-key.enable = true;
        nvim-surround.enable = true;
        nvim-autopairs.enable = true;
        notify.enable = true;
        lualine.enable = true;
        noice.enable = true;
        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
            "<leader>fb" = "buffers";
            # "<leader>fh" = "help_tags";
            # "<leader>fo" = "vim_options";
          };
        };
        treesitter = {
          enable = true;
          highlight.enable = true;
          indent.enable = true;
          folding.enable = true;
          grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
            bash
            json
            lua
            make
            typst
            markdown
            markdown_inline
            nix
            regex
            toml
            vim
            vimdoc
            xml
            yaml
            ini
            kdl
            rasi
            rust
            python
            html
            css
          ];
        };
      };
    };
  };
}
