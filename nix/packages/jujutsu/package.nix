{
  lib,
  symlinkJoin,
  makeWrapper,
  jujutsu,
  watchman,
}:
symlinkJoin {
  inherit jujutsu;
  name = "jujutsu-wrapped-${jujutsu.version}";
  paths = [ jujutsu ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/jj --prefix PATH : ${lib.makeBinPath [ watchman ]}
  '';
}
