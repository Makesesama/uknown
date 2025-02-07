{
  pkgs,
  lib,
}:
let
  version = "0.1.1";
  src = ../.;

  translatedPlatform =
    {
      aarch64-darwin = "macos-arm64";
      aarch64-linux = "linux-arm64";
      armv7l-linux = "linux-armv7";
      x86_64-darwin = "macos-x64";
      x86_64-linux = "linux-x64";
    }
    .${pkgs.system};

  erl = pkgs.beam.interpreters.erlang_27;
  beamPackages = pkgs.beam.packagesWith erl;
  elixir = beamPackages.elixir_1_18;

  mixNixDeps = import ./deps.nix {
    inherit beamPackages lib;
  };
in
beamPackages.mixRelease {
  inherit src version mixNixDeps;
  pname = "uknown";
  removeCookie = false;

  postBuild = ''
    ln -s ${pkgs.tailwindcss}/bin/tailwindcss _build/tailwind-${translatedPlatform}
    ln -s ${pkgs.esbuild}/bin/esbuild _build/esbuild-${translatedPlatform}

    mix do deps.loadpaths --no-deps-check, tailwind pokequiz --minify + esbuild pokequiz --minify
  '';

  passthru = {
    inherit elixir;
  };
}
