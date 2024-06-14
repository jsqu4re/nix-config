{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darkmatter.url = "gitlab:VandalByte/darkmatter-grub-theme";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.tabula = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        darkmatter.nixosModule
        ./configuration.nix

        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.jsqu4re = import ./home.nix;

            home-manager.backupFileExtension = "backup";
          }
      ];
    };
  };
}
