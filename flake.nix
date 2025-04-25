{
  description = "A bare minimum flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (sys:
      let pkgs = import nixpkgs { system = sys; };
          python = pkgs.python313.withPackages (ps: [ ps.ipython ps.aiohttp ps.toml ]);
      in rec {
        devShells.default = pkgs.mkShell {
          packages = [ python ];
        };

        packages.aptus-open = pkgs.stdenv.mkDerivation (self: {
          name = "aptus-open";
          src = ./. ;

          buildPhase = ''
            mkdir -p $out/bin
            cp -r $src/* $out/bin/
            rm $out/bin/secrets.toml.sample
            cat > $out/bin/${self.name} <<'EOF'
            #!/bin/sh
            ${python}/bin/python "$(dirname "$0")"/main.py "$@"
            EOF
            chmod a+x $out/bin/${self.name}
          '';
        });
      }
    );
}
