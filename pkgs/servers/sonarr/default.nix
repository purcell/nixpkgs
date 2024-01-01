{ lib
, fetchFromGitHub
, nixosTests
, buildDotnetModule
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "sonarr";
  version = "4.0.0.748";

  src = fetchFromGitHub {
    owner = "Sonarr";
    repo = "Sonarr";
    rev = "v${version}";
    sha256 = "sha256-BTufEb4JNiu82cfqagn4Yl6HBScYgb/3pRJlALICV+0=";
  };

  projectFile = "src/Sonarr.sln";
  executables = [ "Sonarr" ];
  nugetDeps = ./nuget-deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;
  dotnetBuildFlags = [ "--no-self-contained" ];

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.sonarr;
  };

  meta = {
    description = "Smart PVR for newsgroup and bittorrent users";
    homepage = "https://sonarr.tv/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fadenb purcell ];
    mainProgram = "Sonarr";
    platforms = lib.platforms.all;
  };
}
