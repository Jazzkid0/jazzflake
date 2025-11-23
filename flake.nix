{
    description = "jazzflake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixos-hardware.url = "github:nixos/nixos-hardware/master";
        deploy-rs.url = "github:serokell/deploy-rs";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        agenix = {
            url = "github:ryantm/agenix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixos-hardware, deploy-rs, home-manager, agenix, ... }@inputs:
        let
            mkSystem = { hostname, user, modules }: nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs; };
                modules = [
                    ./hosts/${hostname}/default.nix
                    ./modules/common/common.nix
                    agenix.nixosModules.default
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        # home-manager.useUserPkgs = true;
                        home-manager.extraSpecialArgs = { inherit inputs; };
                        home-manager.users.${user} = import ./users/${user}/home.nix;
                    }
                ] ++ modules;
            };
        in {
            nixosConfigurations = {
                jazzpc = mkSystem {
                    hostname = "jazzpc";
                    user = "jazzkid";
                    modules = [
                        # gui modules go here
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
                nodes = {
                    jazzserver = {
                        hostname = "100.112.41.121";
                        profiles.system = {
                            user = "root";
                            nodes = {
                                jazzserver = {
                                    hostname = "dev.jazzkid.xyz";
                                    profiles.system = {
                                        user = "root";
                                        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.jazzserver;
                                    };
                                };
                            };
                        };
                    };
                };
            };
            checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
        };
}
