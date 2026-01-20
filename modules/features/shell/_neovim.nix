{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
  ];
  programs.neovim = {
    enable = lib.mkDefault true;
    defaultEditor = lib.mkDefault true;
    vimAlias = lib.mkDefault true;

    extraLuaConfig = #lua
    ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ','

      -- disable netrw at the very start of your init.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      vim.opt.clipboard = "unnamedplus"
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.timeout = false
      vim.opt.encoding = "utf-8"
      vim.opt.cursorline = true
      vim.opt.splitbelow = true
      vim.opt.splitright = true
      vim.opt.wrap = false
      vim.opt.termguicolors = true
      vim.opt.colorcolumn = "100" -- Rust style guide: max line width is 100
      vim.opt.scrolloff = 8

      vim.opt.hlsearch = true
      vim.opt.ignorecase = true
      vim.opt.showmatch = true

      vim.opt.cindent = false
      vim.opt.autoindent = true
      vim.opt.smarttab = true

      vim.opt.backup = false
      vim.opt.writebackup = false

      -- better split navigation
      vim.keymap.set('n', '<leader>wj', '<C-w>w', {})
      vim.keymap.set('n', '<leader>wk', '<C-w>W', {})

      -- LSP
      --vim.lsp.config['nixd'] = {
      --  -- Command and arguments to start the server.
      --  cmd = { 'nixd' },
      --  -- Filetypes to automatically attach to.
      --  filetypes = { 'nix' },
      --  -- Sets the "root directory" to the parent directory of the file in the
      --  -- current buffer that contains either a ".nix.json" or a
      --  -- ".nix.jsonc" file. Files that share a root directory will reuse
      --  -- the connection to the same LSP server.
      --  root_markers = { '.nix.json', '.nix.jsonc' },
      --  -- Specific settings to send to the server. The schema for this is
      --  -- defined by the server. For example the schema for lua-language-server
      --  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
      --  settings = {
      --    nixd = {
      --      nixpkgs = {
      --        expr = "import <nixpkgs> { }",
      --      },
      --      formatting = {
      --        command = { "nixfmt" },
      --      },
      --      options = {};
      --    }
      --  },
      --}
      --vim.lsp.enable('nixd')
    '';

    plugins = with pkgs.vimPlugins; [
      colorizer
      nvim-autopairs
      vim-surround
      zen-mode-nvim
      markdown-preview-nvim
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.css
      nvim-treesitter-parsers.kdl
      nvim-treesitter-parsers.bash
      nvim-treesitter-parsers.rasi
      nvim-treesitter-parsers.hyprlang
      typst-vim
      {
        plugin = noice-nvim;
        type = "lua";
        config = #lua
        ''
          require("noice").setup({
            -- you can enable a preset for easier configuration
            presets = {
              bottom_search = false, -- use a classic bottom cmdline for search
              command_palette = true, -- position the cmdline and popupmenu together
              long_message_to_split = true, -- long messages will be sent to a split
              inc_rename = false, -- enables an input dialog for inc-rename.nvim
            },
          })
        '';
      }
      {
        plugin = vim-commentary;
        type = "viml";
        config = #vim
        ''
          autocmd FileType nix setlocal commentstring=#\ %s
        '';
      }
      {
        plugin = flash-nvim;
        type = "lua";
        config = #lua
        ''
        '';
      }
      {
        plugin = nvim-treesitter;
        type = "lua";
        config = #lua
        ''
          local treesitter = require("nvim-treesitter.configs")
          treesitter.setup({ -- enable syntax highlighting
            highlight = {
              enable = true,
            },
            indent = { enable = true },
          })
        '';
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = #lua
        ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
          vim.keymap.set('n', '<leader>fo', builtin.vim_options, {})
        '';
      }
      {
        plugin = lightline-vim;
        type = "viml";
        config = #lua
        ''
          \ let g:lightline = {
          \     'colorscheme': 'catppuccin',
          \     'active': {
          \         'left': [
          \             [ 'mode', 'paste', 'showcmd'],
          \             [ 'readonly', 'relativepath', 'modified', 'helloworld' ]
          \         ]
          \     },
          \     'component': {
          \     },
          \ }
        '';
      }
      # {
        # DEBUGGER API
        # Check https://igorlfs.github.io/neovim-cpp-dbg
        # plugin = nvim-dap;
        # type = "lua";
      # }
      # {
      #   plugin = harpoon2;
      #   type = "lua";
      #   config = ''
      #     local harpoon = require("harpoon")
      #     harpoon:setup() -- REQUIRED
      #     -- Add buffer to harpoon list
      #     vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
      #     -- Toggle previous & next buffers stored within Harpoon list
      #     vim.keymap.set("n", "<leader>hk", function() harpoon:list():prev() end)
      #     vim.keymap.set("n", "<leader>hj", function() harpoon:list():next() end)
      #     -- Direct target entries
      #     for i=1,9 do
      #       vim.keymap.set("n", string.format("<leader>%d", i), function() harpoon:list():select(i) end)
      #     end
      #                                                                                                                                                                                         local file_paths = {}
      #     vim.keymap.set("n", "<leader>hh",
      #       function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      #   '';
      # }
    ];
  };
}
