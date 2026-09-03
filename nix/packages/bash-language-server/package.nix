{
  lib,
  symlinkJoin,
  makeWrapper,
  bash-language-server,
  shellcheck,
}:
symlinkJoin {
  inherit bash-language-server;
  name = "bash-language-server-wrapped-${bash-language-server.version}";
  paths = [ bash-language-server ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/bash-language-server --prefix PATH : ${lib.makeBinPath [ shellcheck ]}
  '';
}
