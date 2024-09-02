{
  buildNpmPackage,
  fetchFromGitHub,
  content,
} :

let
  quartz-src = fetchFromGitHub {
    owner = "jackyzha0";
    repo = "quartz";
    rev = "v4";
    hash = "sha256-GUlN/VPrRv7tVtwZClhaTteiLn1DjdIFAAeeidwv6oE=";
  };
in
buildNpmPackage {
  name = "quartz";
  npmDepsHash = "sha256-1G0bT1l/Itmkr9rbTnO3pyoUG/R6WCnjAsP4vnlxij8=";
  src = quartz-src;
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall
    npmInstallHook
    cd $out/lib/node_modules/@jackyzha0/quartz
    rm -rf ./content
    mkdir content
    cp -r ${content}/* ./content
    $out/bin/quartz build
    mv ./public $out/public
    runHook postInstall
  '';
}
