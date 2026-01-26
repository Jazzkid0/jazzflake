{
    description = "jazzflake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        # nixos-hardware.url = "github:nixos/nixos-hardware/master";
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
        claude-code = {
            url = "github:sadjow/claude-code-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        opencode = {
            url = "github:anomalyco/opencode";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, deploy-rs, home-manager, agenix, nixarr, ... }@inputs:
        let
            mkSystem = { hostname, user, modules }: nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs self agenix nixarr; };
                modules = [
                    ./hosts/${hostname}/default.nix
                    ./modules/common/common.nix
                    agenix.nixosModules.default
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.extraSpecialArgs = { inherit inputs; };
                        home-manager.users.${user} = import ./users/${user}/home.nix;
                    }
                ] ++ modules;
            };
        in {
            nixosConfigurations = {

                # jazzpc = mkSystem {
                #     hostname = "jazzpc";
                #     user = "jazzkid";
                #     modules = [
                #         # gui modules go here
                #     ];
                # };

                jazznas = mkSystem {
                    hostname = "jazznas";
                    user = "jazzkid";
                    modules = [
                        # NAS-specific modules will be added in Phase 5
                    ];
                };

                jazzserver = mkSystem {
                    hostname = "jazzserver";
                    user = "jazzkid";
                    modules = [
                        ./modules/server/server.nix
                    ];
                };
            };
            deploy = {
                sshUser = "root";
                user = "root";
                nodes = {
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
