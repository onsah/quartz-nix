{
  buildNpmPackage,
  fetchFromGitHub,
} :

let
  quartz-src = fetchFromGitHub {
    owner = "jackyzha0";
    repo = "quartz";
    rev = "v4.3.1";
    hash = "sha256-kID0R/n3ij5uvZ/CXjiLa3oqjghX2U4Zu82huejG6/Q=";
  };
in
buildNpmPackage {
  name = "quartz";
  npmDepsHash = "sha256-qgAzMTtFTShj3xUut73DBCbkt7yTwVjthL8hEgRFdIo=";
  src = quartz-src;
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall
    npmInstallHook
    cd $out/lib/node_modules/@jackyzha0/quartz
    $out/bin/quartz build
  '';
}
