{
  lib,
  pkgs,
  stdenv,
  callPackage,
  auto-patchelf,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  unzip,
  libGL,
  glib,
  fontconfig,
  libglvnd,
  xorg,
  dbus,
  libxkbcommon,
  wayland,
  kdePackages,
  python3,
  libxml2,
  requireFile,
  qt6,
  zlib,

  forceWayland ? false,
}:
let
  desktopIcon = ./binaryninja.svg;
  source = builtins.path {
    path = ./binaryninja_linux_5.3.9434_personal.zip;
    name = "binaryninja_linux_5.3.9434_personal";
  };
in
stdenv.mkDerivation rec {
  pname = "binaryninja";
  version = "5.3.9434";
  description = "Binary Ninja: A Reverse Engineering Platform";
  src = source;

  nativeBuildInputs = [
    makeWrapper
    auto-patchelf
    autoPatchelfHook
    python3.pkgs.wrapPython
    kdePackages.wrapQtAppsHook
    copyDesktopItems
  ];
  buildInputs = with pkgs;[
    unzip
    libGL
    glib
    fontconfig
    libXi
    libXrender
    libxcb-image
    libxcb-render-util
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtwayland
    libxkbcommon
    dbus
    wayland
    libxml2.out
  ];
  pythonDeps = [ python3.pkgs.pip ];
  appendRunpaths = [ "${lib.getLib python3}/lib" ];
  buildPhase = ":";
  desktop = makeDesktopItem {
    name = "Binary Ninja Personal";
    exec = "binaryninja";
    icon = pname;
    comment = description;
    desktopName = "Binary Ninja Personal";
    categories = [ "Utility" ];
  };
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/opt/binaryninja
    mkdir -p $out/share/pixmaps
    cp -r * $out/opt/binaryninja
    find $out/opt/binaryninja \
      -type f \
      -name '*.so' \
      -name '*.so.*' \
      -not -name 'libbinaryninjacore.so.*' \
      -not -name 'libbinaryninjaui.so.*' \
      -not -name 'liblldb.so.*' \
      -not -name 'libshiboken6.abi*.so.*' \
      -not -name 'libpyside6.abi*.so.*' \
      -delete
    cp ${desktopIcon} $out/share/pixmaps/binaryninja.png
    chmod +x $out/opt/binaryninja/binaryninja
    buildPythonPath "$pythonDeps"
    makeWrapper $out/opt/binaryninja/binaryninja $out/bin/binaryninja \
      --set DATA_DIR "$out/opt/binaryninja" \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      --set QT_QPA_PLATFORM wayland \
      --set QT_PLUGIN_PATH "$out/opt/binaryninja/qt" \
      --unset QT_STYLE_OVERRIDE
    runHook postInstall
  '';
  # libxml2 soname changes now follow ABI breaks.
  # https://gitlab.gnome.org/GNOME/libxml2/-/issues/751
  # This is of course ultimately good, but we can't recompile binja
  # So let's just force it to use whatever NixOS has. It's Probably Fine™
  preFixup = ''
    patchelf $out/opt/binaryninja/plugins/lldb/lib/liblldb.so.* \
      --replace-needed libxml2.so.2 libxml2.so
  '';
  dontWrapQtApps = true;
  meta = {
    homepage = "https://binary.ninja/";
    description = description;
    platforms = [ "x86_64-linux" ];
    mainProgram = "binaryninja";
    maintainers = [ "binaryninja" ];
  };
}
