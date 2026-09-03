{
  lib,
  symlinkJoin,
  makeWrapper,
  nil,
  nixfmt,
}:
symlinkJoin {
  inherit nil;
  name = "nil-wrapped-${nil.version}";
  paths = [ nil ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nil --prefix PATH : ${lib.makeBinPath [ nixfmt ]}
  '';
}
