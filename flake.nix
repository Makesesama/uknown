{
  description = "An Elixir development shell.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    lexical.url = "github:lexical-lsp/lexical";

    # use fork of mix2nix because of https://github.com/ydlr/mix2nix/issues/3
    mix2nix.url = "github:Makesesama/mix2nix";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      lexical,
      mix2nix,
      treefmt-nix,
      pre-commit-hooks,
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      overlays = [
        (
          final: prev:
          let
            beamPkgs = final.beam.packagesWith final.beam.interpreters.erlang_27;
          in
          rec {
            beamPackages = beamPkgs;
            elixir = beamPkgs.elixir_1_18;
            hex = beamPkgs.hex;
          }
        )
      ];

      forAllSystems =
        function:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          function {
            pkgs = import nixpkgs { inherit overlays system; };
          }
        );

      treefmtEval = forAllSystems ({ pkgs }: treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix);
    in
    {
      packages = forAllSystems (
        { pkgs }:
        {
          default = pkgs.callPackage ./nix/package.nix {
          };
        }
      );
      checks = forAllSystems (
        { pkgs }:
        {
          pre-commit-check = inputs.pre-commit-hooks.lib.${pkgs.system}.run {
            src = ./.;
            hooks = {
            };
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
      formatter = forAllSystems ({ pkgs }: treefmtEval.${pkgs.system}.config.build.wrapper);

      nixosModules = {
        uknown = import ./nix/module.nix inputs;
      };
    };

}
