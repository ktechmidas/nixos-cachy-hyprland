{
  description = "Hyprland desktop modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      inherit (nixpkgs) lib;
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: lib.genAttrs supportedSystems (system: f system);
    in {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      nixosModules = {
        hyprland = import ./nixos/modules/hyprland.nix;
        hyprland-desktop = import ./nixos/modules/hyprland-desktop.nix;
        hyprpaper = import ./nixos/modules/hyprpaper.nix;
        mako = import ./nixos/modules/mako.nix;
        swaylock = import ./nixos/modules/swaylock.nix;
        waybar = import ./nixos/modules/waybar.nix;
        wlogout = import ./nixos/modules/wlogout.nix;
        wofi = import ./nixos/modules/wofi.nix;
        default = { ... }: {
          imports = [
            home-manager.nixosModules.home-manager
            (import ./nixos/modules/hyprland-desktop.nix)
          ];
        };
      };
    };
}
