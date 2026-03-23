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
      url = "github:rasmus-kirk/nixarr";
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
    home-manager,
    agenix,
    nixarr,
    nixos-hardware,
    ...
  } @ inputs: let
    mkSystem = {
      hostname,
      user,
      domain,
      gui ? false,
      unfree-whitelist ? false,
      modules,
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs self agenix nixarr nixos-hardware gui unfree-whitelist domain;};
        modules =
          [
            ./hosts/${hostname}/default.nix
            ./modules/common/common.nix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = {inherit inputs gui;};
              home-manager.users.${user} = import ./users/${user}/home.nix;
            }
          ]
          ++ modules;
      };
  in {
    nixosConfigurations = {
      jazzpc = mkSystem {
        hostname = "jazzpc";
        user = "jazzkid";
        domain = "pc.jazzkid.xyz";
        gui = true;
        unfree-whitelist = true;
        modules = [
        ];
      };

      jazznas = mkSystem {
        hostname = "jazznas";
        user = "jazzkid";
        domain = "nas.jazzkid.xyz";
        modules = [
          nixarr.nixosModules.default
          ./modules/server/server.nix
          ./modules/services/samba.nix
          ./modules/services/nixarr.nix
          ./modules/services/transmission.nix
          ./modules/services/jellyfin.nix
          ./modules/services/prowlarr.nix
          ./modules/services/radarr.nix
          ./modules/services/sonarr.nix
          ./modules/services/lidarr.nix
          ./modules/services/readarr.nix
          ./modules/services/bazarr.nix
          ./modules/services/jellyseerr.nix
          ./modules/services/silverbullet.nix
          ./modules/services/attic.nix
          ./modules/services/cache-builder.nix
        ];
      };

      jazzserver = mkSystem {
        hostname = "jazzserver";
        user = "jazzkid";
        domain = "dev.jazzkid.xyz";
        modules = [
          ./modules/server/server.nix
        ];
      };
    };
    deploy = {
      sshUser = "root";
      user = "root";
      nodes = {
        jazzpc = {
          hostname = "pc.jazzkid.xyz";
          profiles.system = {
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.jazzpc;
          };
        };
        jazzserver = {
          hostname = "dev.jazzkid.xyz";
          profiles.system = {
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.jazzserver;
          };
        };

        jazznas = {
          hostname = "nas.jazzkid.xyz";
          profiles.system = {
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.jazznas;
          };
        };
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
