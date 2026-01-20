{ pkgs, ... }:

{
  editorconfig = {
    enable = true;
    settings = {
      # Global
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        # My own defaults
        indent_style = "space";
        indent_size = 4;
      };

      # Nix, other markup langs
      "*.{nix,typ,yml,yaml,css,scss}" = {
        indent_size = 2;
        insert_final_newline = true;
        trim_trailing_whitespace = true;
      };
      "*.{diff,patch}" = {
        end_of_line = "unset";
        insert_final_newline = "unset";
        trim_trailing_whitespace = "unset";
      };

      # C, Rust and stuff
      # "*.{c,h}" = {
      #   indent_style = "space";
      #   indent_size = 3; # for SCIP
      # };
      "*.rs" = {
        max_line_width = 100;
        indent_style = "space";
        indent_size = 4;
      };
      "*.php" = {
        indent_style = "space";
        indent_size = 3;
      };
      "**scip/**.{c,h}" = {
        indent_style = "space";
        indent_size = 3;
      };
    };
  };
}
