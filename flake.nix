{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
outputs = inputs@{ nixpkgs, home-manager, catppuccin, ... }:
let
  mkHost = hostDir: homeFile:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/common.nix
        hostDir
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.till = {
            imports = [ homeFile catppuccin.homeManagerModules.catppuccin ];
          };
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  in {
    nixosConfigurations = {
      renoir    = mkHost ./hosts/renoir    ./home/renoir.nix;
    };
  };
}
