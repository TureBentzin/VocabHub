{
  description = "VocabHub";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      jdk23 = pkgs.jdk23;
      maven = pkgs.maven;
    in
    {
      packages.x86_64-linux.default = maven.buildMavenPackage rec {
        pname = "VocabHub";
        version = "1.0-SNAPSHOT";

        src = ./.;

        mvnHash = "";

        nativeBuildInputs = with pkgs; [ makeWrapper ];

        installPhase = ''
          mkdir -p $out/bin $out/share/vocabhub
          install -Dm644 ./target/VocabHub-1.0-SNAPSHOT.jar $out/share/VocabHub-1.0-SNAPSHOT.jar

          makeWrapper ${jdk23}/bin/java $out/bin/vocabhub \
            --add-flags "-jar $out/share/vocabhub/VocabHub-1.0-SNAPSHOT.jar"
        '';
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          jdk23
          maven
        ];
      };
    };

}
