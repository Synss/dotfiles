{
  lib,
  symlinkJoin,
  makeWrapper,
  bash-language-server,
  shellcheck,
}:
symlinkJoin {
  name = "bash-language-server-wrapped-${bash-language-server.version}";
  paths = [ bash-language-server ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/bash-language-server --prefix PATH : ${lib.makeBinPath [ shellcheck ]}
  '';
  meta = bash-language-server.meta;
}
