{
  description = "My Emacs Configuration Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }: let
    systems = builtins.attrNames nixpkgs.legacyPackages;

    emacs-config = import ./emacs-config.nix { inherit inputs; };
  in
    flake-utils.lib.eachSystem systems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ 
            emacs-config

            inputs.emacs-overlay.overlays.default
          ];
        };
      in
      {
        packages = rec {
          default = emacs;
          emacs = pkgs.emacs-pkg;
        };
      })
      // {
        overlays.default = emacs-config;
      };
} 
