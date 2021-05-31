{

  description = "My flakes copnfig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-20.09";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };


  outputs = { nixpkgs, unstable, home-manager, nurpkgs, flake-utils, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      mudrii = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "mudrii";
        homeDirectory = "/home/mudrii";
        configuration = {
          imports = [
            ./home.nix
          ];
        };
      };
    };
    nixosConfigurations = {
      nixtst = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
        ];
      };
    };
  };

}
