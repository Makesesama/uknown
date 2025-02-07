{
  description = "An Elixir development shell.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    lexical.url = "github:lexical-lsp/lexical/support_1_18";

    # use fork of mix2nix because of https://github.com/ydlr/mix2nix/issues/3
    mix2nix.url = "github:Makesesama/mix2nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      lexical,
      mix2nix,
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems =
        function:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          function {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      packages = forAllSystems (
        { pkgs }:
        {
          default = pkgs.callPackage ./nix/package.nix {
          };
        }
      );
      devShells = forAllSystems (
        { pkgs }:
        {
          default =
            let
              opts =
                with pkgs;
                lib.optional stdenv.isLinux inotify-tools
                ++ lib.optionals stdenv.isDarwin (
                  with darwin.apple_sdk.frameworks;
                  [
                    CoreServices
                    Foundation
                  ]
                );
            in
            pkgs.mkShell {
              inputsFrom = [ self.packages.${pkgs.system}.default ];
              packages = [
                mix2nix.packages.${pkgs.system}.default

                lexical.packages.${pkgs.system}.default
              ] ++ opts;
              shellHook = ''
                # Set up `mix` to save dependencies to the local directory
                mkdir -p .nix-mix
                mkdir -p .nix-hex
                export MIX_HOME=$PWD/.nix-mix
                export HEX_HOME=$PWD/.nix-hex
                export PATH=$MIX_HOME/bin:$PATH
                export PATH=$HEX_HOME/bin:$PATH

                # BEAM-specific
                export LANG=en_US.UTF-8
                export ERL_AFLAGS="-kernel shell_history enabled"
              '';
            };
        }
      );
      nixosModules = {
        uknown = import ./nix/module.nix inputs;
      };
    };

}
