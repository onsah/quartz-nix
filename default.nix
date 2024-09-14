{
  system ? builtins.currentSystem,
  sources ? import ./npins,
}:
let
  pkgs = import sources.nixpkgs { inherit system; };
in
{
  quartz = pkgs.callPackage ./quartz.nix {};
}
