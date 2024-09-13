{
  buildNpmPackage,
  fetchFromGitHub,
  writeShellScriptBin,
} :

let
  quartz-src = fetchFromGitHub {
    owner = "jackyzha0";
    repo = "quartz";
    rev = "v4.3.1";
    hash = "sha256-kID0R/n3ij5uvZ/CXjiLa3oqjghX2U4Zu82huejG6/Q=";
  };
  quartz = buildNpmPackage {
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
  };
in
writeShellScriptBin "quartz-live" ''
  tempdir=$(mktemp -d)

  echo "tempdir: $tempdir"
  echo "quartz: ${quartz}"

  mkdir $tempdir/lib
  cp -rL ${quartz}/lib $tempdir
  chmod -R 0777 $tempdir/lib

  cd $tempdir/lib/node_modules/@jackyzha0/quartz
  ${quartz}/bin/quartz build --directory $1 --serve
  # rm -rf $tempdir/lib
''
