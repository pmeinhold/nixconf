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
        mapleader = " ";        # Space
        maplocalleader = ",";   # Comma
        loaded_netrwPlugin = 1; # For yazi https://github.com/mikavilpas/yazi.nvim/issues/802
      };

      keymaps = [
        {
          action = "<cmd>Yazi<cr>";
          key = "<leader>y";
          mode = [ "n" "v" ];
          options.desc = "Open yazi at the current file";
        }
        {
          action.__raw = /*lua*/ ''function() require("flash").jump() end'';
          key = "s";
          mode = [ "n" "x" "o" ];
          options.desc = "Flash";
        }
        {
          action = "<C-w><C-h>";
          key = "<C-h>";
          options.desc = "Go to the left window";
        }
        {
          action = "<C-w><C-j>";
          key = "<C-j>";
          options.desc = "Go to the down window";
        }
        {
          action = "<C-w><C-k>";
          key = "<C-k>";
          options.desc = "Go to the up window";
        }
        {
          action = "<C-w><C-l>";
          key = "<C-l>";
          options.desc = "Go to the right window";
        }
        # {
        #   action = "gj";
        #   key = "j";
        #   mode = [ "n" "v" ];
        #   options.desc = "Go down one line or wrapped sub-line";
        # }
        # {
        #   action = "gk";
        #   key = "k";
        #   mode = [ "n" "v" ];
        #   options.desc = "Go up one line or wrapped sub-line";
        # }
      ];

      opts = {
        number = true;
        relativenumber = true;
        wrap = false;
        cursorline = true;
        splitbelow = true;
        splitright = true;
        termguicolors = true;
        # formatoptions = "cqj";   # dropped 't': no auto-wrap of plain text
        colorcolumn = "+1";   # relative to 'textwidth' which is normally set by .editorconfig.max_line_length
        scrolloff = 8;        # minimum nr. of lines above and below cursor
        ignorecase = true;
        showmatch = true;     # briefly jump to matching bracket if insert one
        foldlevel = 99;
      };

      plugins = {
        comment.enable = true;
        nvim-surround.enable = true;
        nvim-autopairs.enable = true;
        lualine.enable = true;
        noice.enable = true;
        flash.enable = true;
        which-key = {
          enable = true;
          settings.delay = 0;
        };
        notify = {
          enable = true;
          settings.render = "compact";
        };
        yazi = {
          enable = true;
          settings = {
            enable_mouse_support = true;
            open_for_directories = true;
          };
        };
        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
            "<leader>fb" = "buffers";
            "<leader>fm" = "marks";
            "<leader>fh" = "help_tags";
            "<leader>fs" = "lsp_document_symbols";
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
            latex
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
