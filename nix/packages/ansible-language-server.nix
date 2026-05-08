{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "ansible-language-server";
  version = "26.4.6";

  src = fetchurl {
    url = "https://registry.npmjs.org/@ansible/ansible-language-server/-/ansible-language-server-${version}.tgz";
    hash = "sha256-/tRYT8D8Soq9irsDrl/t0P6T9YjJB1HGK54CmyRRwk0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/@ansible/ansible-language-server
    cp -r . $out/lib/node_modules/@ansible/ansible-language-server/
    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/ansible-language-server \
      --add-flags "$out/lib/node_modules/@ansible/ansible-language-server/dist/cli.cjs"
    runHook postInstall
  '';

  meta = {
    description = "Ansible language server";
    homepage = "https://github.com/ansible/ansible-language-server";
    license = lib.licenses.gpl3Only;
    mainProgram = "ansible-language-server";
  };
}
