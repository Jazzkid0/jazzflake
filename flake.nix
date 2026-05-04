{
  description = "jazzflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixarr = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-config = {
      url = "github:Jazzkid0/nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    ...
  } @ inputs: let
    nodes = {
      jazzpc = {
        user = "jazzkid";
        domain = "pc.jazzkid.xyz";
        gui = true;
      };
      jazznas = {
        user = "jazzkid";
        domain = "nas.jazzkid.xyz";
      };
      jazzserver = {
        user = "jazzkid";
        domain = "dev.jazzkid.xyz";
      };
    };

    sshKeys = import ./modules/common/ssh-keys.nix;

    mkSystem = name: cfg:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs self sshKeys;
          hostname = name;
          inherit (cfg) user domain;
          home-manager = inputs.home-manager;
          gui = cfg.gui or false;
        };
        modules = [
          inputs.agenix.nixosModules.default
          ./hosts/${name}
          ./modules/common
          ./users/${cfg.user}
        ];
      };

    mkDeploy = name: cfg: {
      hostname = cfg.domain;
      profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${name};
    };
  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem nodes;

    deploy = {
      sshUser = "root";
      user = "root";
      nodes = nixpkgs.lib.mapAttrs mkDeploy nodes;
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) {
      x86_64-linux = deploy-rs.lib.x86_64-linux;
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
