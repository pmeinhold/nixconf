{ stdenv, pkgs }:
stdenv.mkDerivation rec {
  name = "hp-laser-107w${version}";
  version = "1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/share/cups/model/
    cp HP_Laser_10x_Series.ppd $out/share/cups/model/
    # If you need to patch the path to files outside the nix store, you can do it this way
    # (if the ppd also comes with executables you may need to also patch the executables)
    substituteInPlace $out/share/cups/model/HP_Laser_10x_Series.ppd \
      --replace "rastertospl" "${pkgs.samsung-unified-linux-driver}/lib/cups/filter/rastertospl"
  '';
}
