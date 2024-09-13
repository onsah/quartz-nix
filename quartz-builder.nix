{
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  # Must be `SourceLike`
  content,
} :

let
  quartz = import ./quartz.nix {
    inherit buildNpmPackage fetchFromGitHub;
  };
in
stdenv.mkDerivation {
  name = "quartz-notes";
  buildInputs = [ quartz ];
  src = content;
  # We need this hacky
  installPhase = ''
    mkdir $out
    # We need write permission for lib because
    # quartz writes stuff in it when executed
    cp -rL ${quartz}/lib $out/lib
    chmod -R 0777 $out/lib

    # quartz depends on it's build files to be in the current diretory
    cd $out/lib/node_modules/@jackyzha0/quartz
    ${quartz}/bin/quartz build --directory /build/source --output $out/public
    rm -rf $out/lib
  '';
}
