{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "actions-languageserver";
  version = "0.3.53";

  src = fetchurl {
    url = "https://registry.npmjs.org/@actions/languageserver/-/languageserver-${version}.tgz";
    hash = "sha256-lW/3N3zymeRRYmwSisoYO6j9XrPXEcnJjo5UNNDNNnY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/@actions/languageserver
    cp -r . $out/lib/node_modules/@actions/languageserver/
    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/actions-languageserver \
      --add-flags "$out/lib/node_modules/@actions/languageserver/dist/cli.bundle.cjs"
    runHook postInstall
  '';

  meta = {
    description = "GitHub Actions language server";
    homepage = "https://github.com/actions/languageservices";
    license = lib.licenses.mit;
    mainProgram = "actions-languageserver";
  };
}
