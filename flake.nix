{
  description = "Axone ontology development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { self, nixpkgs, ... }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      mkCoolRdf =
        pkgs:
        pkgs.stdenvNoCC.mkDerivation {
          pname = "cool-rdf-cli";
          version = "2.0.0";
          src = pkgs.fetchurl {
            url = "https://github.com/cool-rdf/cool-rdf/releases/download/v2.0.0/cool-rdf-cli-2.0.0.jar";
            hash = "sha256-SrnrTYlLlRnL++4SqJxgDVjC1FuipFj59a1ZfznhUbs=";
          };

          dontUnpack = true;
          nativeBuildInputs = [ pkgs.makeWrapper ];

          installPhase = ''
            install -Dm444 "$src" "$out/share/cool-rdf/cool-rdf-cli.jar"
            makeWrapper ${pkgs.jdk25}/bin/java "$out/bin/cool-rdf" \
              --add-flags "-jar $out/share/cool-rdf/cool-rdf-cli.jar"
          '';
        };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          coolRdf = mkCoolRdf pkgs;
        in
        {
          cool-rdf = coolRdf;
          default = coolRdf;
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          python = pkgs.python312.withPackages (
            ps:
            let
              pyld = ps.buildPythonPackage rec {
                pname = "pyld";
                version = "3.2.0";
                pyproject = true;

                src = pkgs.fetchPypi {
                  inherit pname version;
                  hash = "sha256-uiNCNUuxEe978rLmyEdhC2p7HQV91Av48/0RbgyB4AA=";
                };

                build-system = [ ps.setuptools ];
                dependencies = [
                  ps.cachetools
                  ps.frozendict
                  ps.lxml
                ];
              };
            in
            with ps;
            [
              click
              flake8
              jinja2
              mypy
              pyld
              rdflib
              requests
            ]
          );
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.apache-jena
              pkgs.actionlint
              pkgs.bash-language-server
              pkgs.bc
              pkgs.coreutils
              pkgs.curl
              pkgs.deadnix
              pkgs.dockerfile-language-server
              pkgs.gawk
              pkgs.git
              pkgs.gnumake
              pkgs.gnused
              pkgs.gnutar
              pkgs.jdk25
              pkgs.markdownlint-cli
              pkgs.marksman
              pkgs.nixd
              pkgs.nixfmt
              pkgs.nil
              pkgs.poetry
              pkgs.pyright
              self.packages.${system}.cool-rdf
              python
              pkgs.ruff
              pkgs.statix
              pkgs.taplo
              pkgs.vscode-langservers-extracted
              pkgs.wget
              pkgs.yaml-language-server
            ];

            shellHook = ''
              echo "Axone ontology development environment loaded"
            '';
          };
        }
      );
    };
}
