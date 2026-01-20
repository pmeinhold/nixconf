### ❄️ My [NixOS](https://nixos.org) & [Home Manager](https://github.com/nix-community/home-manager) Configurations ❄️

Now using (my interpretation) of the
[_Dendritic pattern_](https://dendrix.oeiuwq.com/Dendritic.html)
powered by [`flake-parts`](https://flake.parts/)
and [`import-tree`](https://github.com/vic/import-tree):

```bash
flake.nix
modules/    # everything in here is auto-imported by import-tree
├── users.nix   # all user (home-manager) configs
├── machines/   # all machine (nixos) configs
│   └── <machine>/
│       ├── default.nix     # machine-specific nixos config
│       └── _hardware.nix   # machine-specific hardware config
└── features/   # feature modules are used in machine and user configs
    ├── <feature>.nix       # defines this feature module
    └── <feature>/
        ├── default.nix     # defines this feature module
        └── _<part>.nix     # is part of this feature module
```
