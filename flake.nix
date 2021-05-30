{
  description = "My flakes copnfig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }@inputs: {
  #outputs = { self, nixpkgs, unstable, ... }@inputs: {

    nixosConfigurations = {
      nixtst = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ (import ./configuration.nix) ];
        specialArgs = { inherit inputs; };
      };
    };

  nixtst = self.nixosConfigurations.nixtst.config.system.build.toplevel;

#  defaultPackage.x86_64-linux = (builtins.head (builtins.attrValue self.nisosConfigurations)).pkgs;
  };
}
