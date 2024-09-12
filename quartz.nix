{
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  lib,
  content,
} :

let
  fileset = lib.fileset;
  quartz-src = fetchFromGitHub {
    owner = "jackyzha0";
    repo = "quartz";
    rev = "v4.3.1";
    hash = "sha256-kID0R/n3ij5uvZ/CXjiLa3oqjghX2U4Zu82huejG6/Q=";
  };
  quartz-derivation = buildNpmPackage {
    name = "quartz";
    npmDepsHash = "sha256-qgAzMTtFTShj3xUut73DBCbkt7yTwVjthL8hEgRFdIo=";
    src = quartz-src;
    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall
      npmInstallHook
      cd $out/lib/node_modules/@jackyzha0/quartz
      $out/bin/quartz build
      ls -la $out/lib/node_modules/@jackyzha0/quartz/quartz/
    '';
  };
in
stdenv.mkDerivation {
  name = "quartz-notes";
  buildInputs = [ quartz-derivation ];
  src = fileset.toSource {
    root = dirOf content;
    fileset = content;
  };
  installPhase = ''
    mkdir $out
    # We need write permission for lib because
    # quartz writes stuff in it when executed
    cp -rL ${quartz-derivation}/lib $out/lib
    chmod -R 0777 $out/lib

    # quartz depends on it's build files to be in the current diretory
    cd $out/lib/node_modules/@jackyzha0/quartz
    ${quartz-derivation}/bin/quartz build --directory ${content} --output $out/public
    rm -rf $out/lib
  '';
}
