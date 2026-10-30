{ ... }:
{
  flake.modules.homeManager.feature-editorconfig = { pkgs, ... }:
  {
    # EditorConfig is awesome: https://editorconfig.org
    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          charset = "utf-8";
          end_of_line = "lf";
          trim_trailing_whitespace = true;
          # My own defaults
          insert_final_newline = true;
          indent_style = "space";
          indent_size = 4;

          # 'max_line_length' is only supported by:
          # - Emacs, Vim, Neovim, and Atom,
          # - ReSharper and Rider,
          # - AppCode, IntelliJ IDEA, PhpStorm, PyCharm, RubyMine, and WebStorm,
          # - Kakoune, Prettier
          # https://github.com/editorconfig/editorconfig/wiki/EditorConfig-Properties#supported-by-a-limited-number-of-editors
          max_line_length = 100;
        };

        # Nix, other markup languages
        "*.{nix,typ,tex,yml,yaml,css,scss,html}" = {
          indent_size = 2;
        };

        # SCIP https://scipopt.org/doc/html/CODE.php
        "**scip/**.{c,h}" = {
          indent_size = 3;
          max_line_length = 120;
        };

        "*.{diff,patch}" = {
          end_of_line = "unset";
          insert_final_newline = "unset";
          trim_trailing_whitespace = "unset";
        };
      };
    };
  };
}
