{
  description = "bonnetje: EPSON TMX CUPS Thermal Receipt Utilities";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { pkgs, self', ... }: {
        packages = {
          epson-drivers = pkgs.stdenv.mkDerivation rec {
            pname = "bonnetje";
            version = "3.0.0.0";

            sourceRoot = "Thermal Receipt";

            src = pkgs.fetchurl {
              url = "https://ftp.epson.com/drivers/pos/tmx-cups-src-ThermalReceipt-${version}.tar.gz";
              hash = "sha256-gQU0DyKw/wwwjK1cyF4Nnh6F1k6lCgIPq6ctmCfUjB0=";
            };

            nativeBuildInputs = with pkgs; [
              cmake
            ];

            buildInputs = with pkgs; [
              cups
            ];

            patchPhase = ''
              sed --in-place 's/VERSION 2.8/VERSION 3.10/g' CMakeLists.txt
            '';

            dontUseCmakeConfigure = true;

            buildPhase = ''
              cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
              cmake --build build
            '';

            installPhase = ''
              mkdir -p "$out/lib/cups/filter"
              mkdir -p "$out/share/cups/model/EPSON"

              install -Dm755 build/rastertotmtr \
                "$out/lib/cups/filter/rastertotmtr"

              install -Dm644 ppd/*.ppd \
                "$out/share/cups/model/EPSON/"
            '';
          };

          bonnetje = pkgs.rustPlatform.buildRustPackage {
            pname = "bonnetje";
            version = "0.1.0";
            src = ./.;

            # Upstream does not version-control their Cargo.lock :(
            cargoLock = {
              lockFile = ./Cargo.lock;
            };

            # postPatch = "ln -s ${./Cargo.lock} Cargo.lock  ";

            nativeBuildInputs = [
              pkgs.pkg-config
            ];
            buildInputs = [
              pkgs.libudev-zero
            ];

          };
        };

        devShells.default = pkgs.mkShell {
          name = "bonnetje";

          inputsFrom = with self'.packages; [
            epson-drivers
            bonnetje
          ];

          packages = with pkgs; [
            cmake
            cargo
            rustc
            pkg-config
          ];
        };
      };
    };
}
