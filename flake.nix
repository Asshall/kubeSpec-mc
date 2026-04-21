{
  description = "My Kubernetes cluster managed with nixidy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixidy.url = "github:arnarg/nixidy";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      nixidy,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # Define your environments
        nixidyEnvs = nixidy.lib.mkEnvs {
          inherit pkgs;

          envs = {
            dev.modules = [ ./env/dev.nix ];
          };
        };

        # Make nixidy CLI available
        packages.nixidy = nixidy.packages.${system}.default;

        # Development shell with nixidy
        devShells.default = pkgs.mkShell {
          buildInputs = [ nixidy.packages.${system}.default ];
        };
      }
    );
}
