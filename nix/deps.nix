{
  lib,
  beamPackages,
  overrides ? (x: y: { }),
}:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages =
    with beamPackages;
    with self;
    {
      bandit = buildMix rec {
        name = "bandit";
        version = "1.6.7";

        src = fetchHex {
          pkg = "bandit";
          version = "${version}";
          sha256 = "551ba8ff5e4fc908cbeb8c9f0697775fb6813a96d9de5f7fe02e34e76fd7d184";
        };

        beamDeps = [
          hpax
          plug
          telemetry
          thousand_island
          websock
        ];
      };

      bunt = buildMix rec {
        name = "bunt";
        version = "1.0.0";

        src = fetchHex {
          pkg = "bunt";
          version = "${version}";
          sha256 = "dc5f86aa08a5f6fa6b8096f0735c4e76d54ae5c9fa2c143e5a1fc7c1cd9bb6b5";
        };

        beamDeps = [ ];
      };

      castore = buildMix rec {
        name = "castore";
        version = "1.0.11";

        src = fetchHex {
          pkg = "castore";
          version = "${version}";
          sha256 = "e03990b4db988df56262852f20de0f659871c35154691427a5047f4967a16a62";
        };

        beamDeps = [ ];
      };

      cc_precompiler = buildMix rec {
        name = "cc_precompiler";
        version = "0.1.10";

        src = fetchHex {
          pkg = "cc_precompiler";
          version = "${version}";
          sha256 = "f6e046254e53cd6b41c6bacd70ae728011aa82b2742a80d6e2214855c6e06b22";
        };

        beamDeps = [ elixir_make ];
      };

      credo = buildMix rec {
        name = "credo";
        version = "1.7.11";

        src = fetchHex {
          pkg = "credo";
          version = "${version}";
          sha256 = "56826b4306843253a66e47ae45e98e7d284ee1f95d53d1612bb483f88a8cf219";
        };

        beamDeps = [
          bunt
          file_system
          jason
        ];
      };

      db_connection = buildMix rec {
        name = "db_connection";
        version = "2.7.0";

        src = fetchHex {
          pkg = "db_connection";
          version = "${version}";
          sha256 = "dcf08f31b2701f857dfc787fbad78223d61a32204f217f15e881dd93e4bdd3ff";
        };

        beamDeps = [ telemetry ];
      };

      decimal = buildMix rec {
        name = "decimal";
        version = "2.3.0";

        src = fetchHex {
          pkg = "decimal";
          version = "${version}";
          sha256 = "a4d66355cb29cb47c3cf30e71329e58361cfcb37c34235ef3bf1d7bf3773aeac";
        };

        beamDeps = [ ];
      };

      dialyxir = buildMix rec {
        name = "dialyxir";
        version = "1.4.5";

        src = fetchHex {
          pkg = "dialyxir";
          version = "${version}";
          sha256 = "b0fb08bb8107c750db5c0b324fa2df5ceaa0f9307690ee3c1f6ba5b9eb5d35c3";
        };

        beamDeps = [ erlex ];
      };

      dns_cluster = buildMix rec {
        name = "dns_cluster";
        version = "0.1.3";

        src = fetchHex {
          pkg = "dns_cluster";
          version = "${version}";
          sha256 = "46cb7c4a1b3e52c7ad4cbe33ca5079fbde4840dedeafca2baf77996c2da1bc33";
        };

        beamDeps = [ ];
      };

      ecto = buildMix rec {
        name = "ecto";
        version = "3.12.5";

        src = fetchHex {
          pkg = "ecto";
          version = "${version}";
          sha256 = "6eb18e80bef8bb57e17f5a7f068a1719fbda384d40fc37acb8eb8aeca493b6ea";
        };

        beamDeps = [
          decimal
          jason
          telemetry
        ];
      };

      ecto_sql = buildMix rec {
        name = "ecto_sql";
        version = "3.12.1";

        src = fetchHex {
          pkg = "ecto_sql";
          version = "${version}";
          sha256 = "aff5b958a899762c5f09028c847569f7dfb9cc9d63bdb8133bff8a5546de6bf5";
        };

        beamDeps = [
          db_connection
          ecto
          telemetry
        ];
      };

      ecto_sqlite3 = buildMix rec {
        name = "ecto_sqlite3";
        version = "0.18.1";

        src = fetchHex {
          pkg = "ecto_sqlite3";
          version = "${version}";
          sha256 = "ce223f0eda408437e7dc2b5f2a9dab306c7a709dc865f96172ba5eadfea3ce48";
        };

        beamDeps = [
          decimal
          ecto
          ecto_sql
          exqlite
        ];
      };

      elixir_make = buildMix rec {
        name = "elixir_make";
        version = "0.9.0";

        src = fetchHex {
          pkg = "elixir_make";
          version = "${version}";
          sha256 = "db23d4fd8b757462ad02f8aa73431a426fe6671c80b200d9710caf3d1dd0ffdb";
        };

        beamDeps = [ ];
      };

      erlex = buildMix rec {
        name = "erlex";
        version = "0.2.7";

        src = fetchHex {
          pkg = "erlex";
          version = "${version}";
          sha256 = "3ed95f79d1a844c3f6bf0cea61e0d5612a42ce56da9c03f01df538685365efb0";
        };

        beamDeps = [ ];
      };

      esbuild = buildMix rec {
        name = "esbuild";
        version = "0.8.2";

        src = fetchHex {
          pkg = "esbuild";
          version = "${version}";
          sha256 = "558a8a08ed78eb820efbfda1de196569d8bfa9b51e8371a1934fbb31345feda7";
        };

        beamDeps = [
          castore
          jason
        ];
      };

      expo = buildMix rec {
        name = "expo";
        version = "1.1.0";

        src = fetchHex {
          pkg = "expo";
          version = "${version}";
          sha256 = "fbadf93f4700fb44c331362177bdca9eeb8097e8b0ef525c9cc501cb9917c960";
        };

        beamDeps = [ ];
      };

      exqlite = buildMix rec {
        name = "exqlite";
        version = "0.29.0";

        src = fetchHex {
          pkg = "exqlite";
          version = "${version}";
          sha256 = "a75f8a069fcdad3e5f95dfaddccd13c2112ea3b742fdcc234b96410e9c1bde00";
        };

        preConfigure = ''
          export ELIXIR_MAKE_CACHE_DIR="$TMPDIR/.cache"
        '';

        beamDeps = [
          cc_precompiler
          db_connection
          elixir_make
        ];
      };

      file_system = buildMix rec {
        name = "file_system";
        version = "1.1.0";

        src = fetchHex {
          pkg = "file_system";
          version = "${version}";
          sha256 = "bfcf81244f416871f2a2e15c1b515287faa5db9c6bcf290222206d120b3d43f6";
        };

        beamDeps = [ ];
      };

      finch = buildMix rec {
        name = "finch";
        version = "0.19.0";

        src = fetchHex {
          pkg = "finch";
          version = "${version}";
          sha256 = "fc5324ce209125d1e2fa0fcd2634601c52a787aff1cd33ee833664a5af4ea2b6";
        };

        beamDeps = [
          mime
          mint
          nimble_options
          nimble_pool
          telemetry
        ];
      };

      floki = buildMix rec {
        name = "floki";
        version = "0.37.0";

        src = fetchHex {
          pkg = "floki";
          version = "${version}";
          sha256 = "516a0c15a69f78c47dc8e0b9b3724b29608aa6619379f91b1ffa47109b5d0dd3";
        };

        beamDeps = [ ];
      };

      gettext = buildMix rec {
        name = "gettext";
        version = "0.26.2";

        src = fetchHex {
          pkg = "gettext";
          version = "${version}";
          sha256 = "aa978504bcf76511efdc22d580ba08e2279caab1066b76bb9aa81c4a1e0a32a5";
        };

        beamDeps = [ expo ];
      };

      hpax = buildMix rec {
        name = "hpax";
        version = "1.0.2";

        src = fetchHex {
          pkg = "hpax";
          version = "${version}";
          sha256 = "2f09b4c1074e0abd846747329eaa26d535be0eb3d189fa69d812bfb8bfefd32f";
        };

        beamDeps = [ ];
      };

      jason = buildMix rec {
        name = "jason";
        version = "1.4.4";

        src = fetchHex {
          pkg = "jason";
          version = "${version}";
          sha256 = "c5eb0cab91f094599f94d55bc63409236a8ec69a21a67814529e8d5f6cc90b3b";
        };

        beamDeps = [ decimal ];
      };

      mime = buildMix rec {
        name = "mime";
        version = "2.0.6";

        src = fetchHex {
          pkg = "mime";
          version = "${version}";
          sha256 = "c9945363a6b26d747389aac3643f8e0e09d30499a138ad64fe8fd1d13d9b153e";
        };

        beamDeps = [ ];
      };

      mint = buildMix rec {
        name = "mint";
        version = "1.7.1";

        src = fetchHex {
          pkg = "mint";
          version = "${version}";
          sha256 = "fceba0a4d0f24301ddee3024ae116df1c3f4bb7a563a731f45fdfeb9d39a231b";
        };

        beamDeps = [
          castore
          hpax
        ];
      };

      nimble_options = buildMix rec {
        name = "nimble_options";
        version = "1.1.1";

        src = fetchHex {
          pkg = "nimble_options";
          version = "${version}";
          sha256 = "821b2470ca9442c4b6984882fe9bb0389371b8ddec4d45a9504f00a66f650b44";
        };

        beamDeps = [ ];
      };

      nimble_pool = buildMix rec {
        name = "nimble_pool";
        version = "1.1.0";

        src = fetchHex {
          pkg = "nimble_pool";
          version = "${version}";
          sha256 = "af2e4e6b34197db81f7aad230c1118eac993acc0dae6bc83bac0126d4ae0813a";
        };

        beamDeps = [ ];
      };

      phoenix = buildMix rec {
        name = "phoenix";
        version = "1.7.19";

        src = fetchHex {
          pkg = "phoenix";
          version = "${version}";
          sha256 = "ba4dc14458278773f905f8ae6c2ec743d52c3a35b6b353733f64f02dfe096cd6";
        };

        beamDeps = [
          castore
          jason
          phoenix_pubsub
          phoenix_template
          plug
          plug_crypto
          telemetry
          websock_adapter
        ];
      };

      phoenix_ecto = buildMix rec {
        name = "phoenix_ecto";
        version = "4.6.3";

        src = fetchHex {
          pkg = "phoenix_ecto";
          version = "${version}";
          sha256 = "909502956916a657a197f94cc1206d9a65247538de8a5e186f7537c895d95764";
        };

        beamDeps = [
          ecto
          phoenix_html
          plug
        ];
      };

      phoenix_html = buildMix rec {
        name = "phoenix_html";
        version = "4.2.0";

        src = fetchHex {
          pkg = "phoenix_html";
          version = "${version}";
          sha256 = "9713b3f238d07043583a94296cc4bbdceacd3b3a6c74667f4df13971e7866ec8";
        };

        beamDeps = [ ];
      };

      phoenix_live_dashboard = buildMix rec {
        name = "phoenix_live_dashboard";
        version = "0.8.6";

        src = fetchHex {
          pkg = "phoenix_live_dashboard";
          version = "${version}";
          sha256 = "1681ab813ec26ca6915beb3414aa138f298e17721dc6a2bde9e6eb8a62360ff6";
        };

        beamDeps = [
          ecto
          mime
          phoenix_live_view
          telemetry_metrics
        ];
      };

      phoenix_live_reload = buildMix rec {
        name = "phoenix_live_reload";
        version = "1.5.3";

        src = fetchHex {
          pkg = "phoenix_live_reload";
          version = "${version}";
          sha256 = "b4ec9cd73cb01ff1bd1cac92e045d13e7030330b74164297d1aee3907b54803c";
        };

        beamDeps = [
          file_system
          phoenix
        ];
      };

      phoenix_live_view = buildMix rec {
        name = "phoenix_live_view";
        version = "1.0.4";

        src = fetchHex {
          pkg = "phoenix_live_view";
          version = "${version}";
          sha256 = "a9865316ddf8d78f382d63af278d20436b52d262b60239956817a61279514366";
        };

        beamDeps = [
          floki
          jason
          phoenix
          phoenix_html
          phoenix_template
          plug
          telemetry
        ];
      };

      phoenix_pubsub = buildMix rec {
        name = "phoenix_pubsub";
        version = "2.1.3";

        src = fetchHex {
          pkg = "phoenix_pubsub";
          version = "${version}";
          sha256 = "bba06bc1dcfd8cb086759f0edc94a8ba2bc8896d5331a1e2c2902bf8e36ee502";
        };

        beamDeps = [ ];
      };

      phoenix_template = buildMix rec {
        name = "phoenix_template";
        version = "1.0.4";

        src = fetchHex {
          pkg = "phoenix_template";
          version = "${version}";
          sha256 = "2c0c81f0e5c6753faf5cca2f229c9709919aba34fab866d3bc05060c9c444206";
        };

        beamDeps = [ phoenix_html ];
      };

      plug = buildMix rec {
        name = "plug";
        version = "1.16.1";

        src = fetchHex {
          pkg = "plug";
          version = "${version}";
          sha256 = "a13ff6b9006b03d7e33874945b2755253841b238c34071ed85b0e86057f8cddc";
        };

        beamDeps = [
          mime
          plug_crypto
          telemetry
        ];
      };

      plug_crypto = buildMix rec {
        name = "plug_crypto";
        version = "2.1.0";

        src = fetchHex {
          pkg = "plug_crypto";
          version = "${version}";
          sha256 = "131216a4b030b8f8ce0f26038bc4421ae60e4bb95c5cf5395e1421437824c4fa";
        };

        beamDeps = [ ];
      };

      swoosh = buildMix rec {
        name = "swoosh";
        version = "1.17.10";

        src = fetchHex {
          pkg = "swoosh";
          version = "${version}";
          sha256 = "277f86c249089f4fc7d70944987151b76424fac1d348d40685008ba88e0a2717";
        };

        beamDeps = [
          bandit
          finch
          jason
          mime
          plug
          telemetry
        ];
      };

      tailwind = buildMix rec {
        name = "tailwind";
        version = "0.2.4";

        src = fetchHex {
          pkg = "tailwind";
          version = "${version}";
          sha256 = "c6e4a82b8727bab593700c998a4d98cf3d8025678bfde059aed71d0000c3e463";
        };

        beamDeps = [ castore ];
      };

      telemetry = buildRebar3 rec {
        name = "telemetry";
        version = "1.3.0";

        src = fetchHex {
          pkg = "telemetry";
          version = "${version}";
          sha256 = "7015fc8919dbe63764f4b4b87a95b7c0996bd539e0d499be6ec9d7f3875b79e6";
        };

        beamDeps = [ ];
      };

      telemetry_metrics = buildMix rec {
        name = "telemetry_metrics";
        version = "1.1.0";

        src = fetchHex {
          pkg = "telemetry_metrics";
          version = "${version}";
          sha256 = "e7b79e8ddfde70adb6db8a6623d1778ec66401f366e9a8f5dd0955c56bc8ce67";
        };

        beamDeps = [ telemetry ];
      };

      telemetry_poller = buildRebar3 rec {
        name = "telemetry_poller";
        version = "1.1.0";

        src = fetchHex {
          pkg = "telemetry_poller";
          version = "${version}";
          sha256 = "9eb9d9cbfd81cbd7cdd24682f8711b6e2b691289a0de6826e58452f28c103c8f";
        };

        beamDeps = [ telemetry ];
      };

      thousand_island = buildMix rec {
        name = "thousand_island";
        version = "1.3.9";

        src = fetchHex {
          pkg = "thousand_island";
          version = "${version}";
          sha256 = "25ab4c07badadf7f87adb4ab414e0ed374e5f19e72503aa85132caa25776e54f";
        };

        beamDeps = [ telemetry ];
      };

      websock = buildMix rec {
        name = "websock";
        version = "0.5.3";

        src = fetchHex {
          pkg = "websock";
          version = "${version}";
          sha256 = "6105453d7fac22c712ad66fab1d45abdf049868f253cf719b625151460b8b453";
        };

        beamDeps = [ ];
      };

      websock_adapter = buildMix rec {
        name = "websock_adapter";
        version = "0.5.8";

        src = fetchHex {
          pkg = "websock_adapter";
          version = "${version}";
          sha256 = "315b9a1865552212b5f35140ad194e67ce31af45bcee443d4ecb96b5fd3f3782";
        };

        beamDeps = [
          bandit
          plug
          websock
        ];
      };
    };
in
self
