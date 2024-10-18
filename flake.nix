{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    binwalk-git = {
      url = "github:ReFirmLabs/binwalk";
      flake = false;
    };
  };

  outputs = {
    self,
    flake-utils,
    naersk,
    nixpkgs,
    binwalk-git,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        naersk' = pkgs.callPackage naersk {};
        built = naersk'.buildPackage {
          pname = "binwalk";
          version = "3-beta";
          src = "${binwalk-git}";
          nativeBuildInputs = with pkgs; [pkg-config];
          buildInputs = with pkgs; [
            fontconfig.dev
            xz.dev
            zlib
            xz
            gzip
            bzip2
            gnutar
            p7zip
            cabextract
            squashfsTools
            cramfsprogs
            cramfsswap
            sasquatch
          ];
        };
      in {
        packages.default = built;
        apps = flake-utils.lib.mkApp {drv = built;};
      }
    );
}
