# Cachy Hyprland Modules

The original CachyOS Hyprland setup, ported to reusable NixOS + Home Manager modules.

## Usage

1. Add the flake as an input:

   ```nix
   inputs.hyprland-config.url = "github:ktechmidas/nixos-cachy-hyprland";
   inputs.hyprland-config.inputs.nixpkgs.follows = "nixpkgs";
   ```

2. Import the pieces you want. The `default` module already pulls in `home-manager` and the full desktop stack:

   ```nix
   outputs = { self, nixpkgs, hyprland-config, ... }: {
     nixosConfigurations.mach = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [
         hyprland-config.nixosModules.default
         {
           modules.hyprland-desktop = {
             enable = true;
             user = "alice";
             terminal = "alacritty";
             fileManager = "nautilus";
             wallpaper = "/home/alice/Pictures/wallpaper.jpg";
           };
         }
       ];
     };
   };
   ```

3. Alternatively, import individual modules and wire them into your own `home-manager` setup:

   ```nix
   {
     imports = [
       home-manager.nixosModules.home-manager
       hyprland-config.nixosModules.hyprland
       hyprland-config.nixosModules.waybar
     ];

     modules.hyprland = {
       enable = true;
       user = "alice";
     };

     modules.waybar = {
       enable = true;
       user = "alice";
     };
   }
   ```

Each module exposes a `user` option so the Home Manager configuration can be attached to the right account. Set the other options (`terminal`, `fileManager`, `wallpaper`, `cursorSize`, etc.) as needed.

Run `nix flake lock --update-input hyprland-config` after adding the dependency to pin it in your project.

## Credits

Original settings: <https://github.com/CachyOS/cachyos-hyprland-settings>

Thanks to @Shendisx for the upstream work.
