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
  quartz-npm = buildNpmPackage {
    name = "quartz";
    npmDepsHash = "sha256-qgAzMTtFTShj3xUut73DBCbkt7yTwVjthL8hEgRFdIo=";
    src = quartz-src;
    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall
      npmInstallHook
      cd $out/lib/node_modules/@jackyzha0/quartz
      # Don't know why but we need to run this during installPhase otherwise it doesn't work
      $out/bin/quartz build
    '';
  };
in
writeShellScriptBin "quartz" ''
  # Because we `cd` later, we need to normalize paths in the arguments
  # First arg is always a command
  normalized_args=($1)
  shift

  for arg in "$@"; do
    # Check if the argument does not start with '-' (indicating it's not a flag)
    if expr "$arg" : "-*" 1>/dev/null; then
      # Otherwise, keep it as is (either a flag or an option value)
      normalized_args+=("$arg")
    else
      # If it's a file or directory, convert to absolute path using realpath
      abs_path=$(realpath "$arg")
      normalized_args+=("$abs_path")
    fi
  done

  tmpdir=$(mktemp -d)
  # We need write permission for lib because
  # quartz writes stuff in it when executed
  cp -rL ${quartz-npm}/lib $tmpdir/lib
  chmod -R 0777 $tmpdir/lib
  cd $tmpdir/lib/node_modules/@jackyzha0/quartz
  ${quartz-npm}/bin/quartz ''${normalized_args[@]}
''
