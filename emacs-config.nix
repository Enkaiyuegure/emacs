{ inputs }: final: prev: 
with final.pkgs.lib; let
  pkgs = final;

  # Function to build Emacs configuration
  mkEmacs = { 
    config ? ./emacs/init.el,
    package ? pkgs.emacs,
    extraPackages ? epkgs: [],
    alwaysEnsure ? true,
    defaultInitFile ? true
  }: pkgs.emacsWithPackagesFromUsePackage {
    inherit config package alwaysEnsure defaultInitFile;
    extraEmacsPackages = extraPackages;
  };

  # Define any extra packages needed across different Emacs configurations
  commonExtraPackages = epkgs: with epkgs; [
    # Add common packages here, for example:
    # org-roam requires sqlite
    # pkgs.sqlite
  ];

in {
  # The main Emacs package exposed by the overlay
  emacs-pkg = mkEmacs {
    package = pkgs.emacs;
    extraPackages = commonExtraPackages;
  };
} 
