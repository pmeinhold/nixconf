{ inputs, ... }:
{
  # A Guide on How to Use papis Sensibly
  # https://gist.github.com/avonmoll/e435f0e478fbdc6c1eee7557b221a7e2

  flake.modules.homeManager.feature-papis = { pkgs, ... }:
  {
    programs.papis = {
      # 'packaging' is a dependency of 'habanero' is a dependency of papis.
      # it is not listed in the nix package in 26.05, i.e., we need to override the inputs
      # https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/development/python-modules/habanero/default.nix
      # https://github.com/papis/papis/issues/1129
      package = pkgs.papis.overridePythonAttrs (old: {
        dependencies = old.dependencies ++ [ pkgs.python3Packages.packaging ];
      });

      enable = true;
      libraries."bib" = {
        isDefault = true;
        settings = {
          dir = "~/dev/bib";
        };
      };

      settings = {
        editor = "nvim";
        editmode = "vi";
        file-browser = "yazi";

        # Ask for confirmation when doing papis add ...
        add-confirm = true;

        # Edit the info.yaml file before adding a doc into the library
        # Equivalent to 'papis add --edit'
        add-edit = true;

        # Open the files before adding a document into the library
        # Equivalent to 'papis add --open'
        add-open = true;

        bibtex-unicode = false;

        # Change the cite key format (papis "ref")
        ref-format = "{doc[author_list][0][family]}{doc[year]}";
        # Default folder name for newly added documents
        add-folder-name = "{doc[author_list][0][family]} - {doc[title]}";
        # Default file name
        add-file-name = "{doc[author_list][0][family]} - {doc[title]}";
      };
    };

    # Neovim Plugin & the 'yq-go' dependency, which is missing from the nix package
    # home.packages = with pkgs; [ yq-go ];
    # programs.neovim.plugins = [{
    #   plugin = pkgs.vimPlugins.papis-nvim;
    #   type = "lua";
    #   config = #lua
    #   ''
    #     require("papis").setup({
    #       -- Enable the default keymaps (defaults to `false`)
    #       enable_keymaps = true,

    #       -- You might want to change the filetypes activating papis.nvim
    #       -- init_filetypes = { "markdown", "norg", "yaml", "typst" },

    #       -- If you don't have an appropriate font (like Nerd Font), you
    #       -- may want to disable icons. This may require a `:Papis reload data`.
    #       -- to take effect.
    #       -- enable_icons = false,

    #       -- You can enable disabled modules (e.g. the 'ask' module) like so:
    #       -- ["ask"] = {
    #       --   enable = true,
    #       -- },
    #     })
    #   '';
    # }];
  };
}
