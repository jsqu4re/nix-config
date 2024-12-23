{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grub2-theme = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, grub2-theme, nixos-hardware, ... }@inputs: {
    nixosConfigurations.tabula = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machine/tabula/configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jsqu4re = import ./home.nix;
          home-manager.backupFileExtension = "backup";
        }

        grub2-theme.nixosModules.default
      ];
    };
    nixosConfigurations.mutabilix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machine/mutabilix/configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jsqu4re = import ./home.nix;
          home-manager.backupFileExtension = "backup";
        }

        nixos-hardware.nixosModules.microsoft-surface-pro-intel
        grub2-theme.nixosModules.default
      ];
    };
  };
}
