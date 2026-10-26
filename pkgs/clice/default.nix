{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  vimUtils,
}: let
  version = "0.1.2026102507";
  # Nightly prebuilt. nixpkgs does not package clice, and a from-source
  # build pulls clice's own LLVM. The binary looks up lib/clang next to
  # itself, so bin/ and lib/ must stay siblings.
  sources = {
    aarch64-darwin = {
      target = "aarch64-apple-darwin";
      hash = "sha256-8lKkerRs8Y0QaA8ZcQuJuPKVg81u2Q8wBQjRJydWdGk=";
    };
    x86_64-linux = {
      target = "x86_64-unknown-linux-gnu";
      hash = "sha256-Iv82QtvjdTeWoLB5R27ZQdw3Nl5ioXeVUPKpelcPsk0=";
    };
  };
  source =
    sources.${stdenv.hostPlatform.system}
    or (throw "clice has no prebuilt binary for ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation {
    pname = "clice";
    inherit version;

    src = fetchzip {
      url = "https://github.com/clice-io/clice/releases/download/v${version}/clice-${version}.${source.target}.tar.gz";
      hash = source.hash;
    };

    nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
    ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      stdenv.cc.libc
    ];

    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -a bin lib $out/
      runHook postInstall
    '';

    # Editor bits shipped with this binary: after/lsp/clice.lua (context
    # and refactor requests) and plugin/clice.lua (semantic-token links).
    passthru.nvim = vimUtils.buildVimPlugin {
      name = "clice-nvim";
      src = ./nvim;
      doCheck = false;
    };

    meta = {
      description = "C++ language server focused on performance and code intelligence";
      homepage = "https://github.com/clice-io/clice";
      license = lib.licenses.asl20;
      mainProgram = "clice";
      platforms = builtins.attrNames sources;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
