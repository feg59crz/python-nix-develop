{
  description = "A devShell example";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    # rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem 
  (system:
      let
        overlays = [ ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        mppackages = p: with p; [
          transformers
          pandas
          numpy
          scipy
          requests
          notebook
          matplotlib
          scikit-learn
        ];
        python-with-my-packages = with pkgs; python3.withPackages mppackages;
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            openssl
            pkg-config
            stdenv
          ];
          packages = [
            python-with-my-packages
          ];

          shellHook = ''
          '';
        };
    }
  );
}
