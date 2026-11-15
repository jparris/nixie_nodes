{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication {
  pname = "juicepassproxy";
  # v0.5.1 plus the NXDOMAIN fallback and amperage mapping fixes.
  version = "0.5.1-unstable-2026-11-11";

  src = fetchFromGitHub {
    owner = "JuiceRescue";
    repo = "juicepassproxy";
    rev = "619be99f8fbfd54d15f5e1e8cd991406a6fd965e";
    hash = "sha256-2KOzNhLN7PN81DYN/g+3ynDKoT/qIfu+ODfcmXVPDEE=";
  };

  # Upstream is a flat directory of scripts with no packaging metadata.
  pyproject = false;

  # Upstream pins ha-mqtt-discoverable to 0.13.1. Its pydantic 1 style calls
  # still work on the current release, but Subscriber no longer accepts a
  # `user_data` argument, so pass it to the callback through a closure instead.
  postPatch = ''
    substituteInPlace juicebox_mqtthandler.py \
      --replace-fail \
        'command_callback=self._callback,' \
        'command_callback=lambda client, _, message: self._callback(client, self._kwargs.get("user_data", None), message),' \
      --replace-fail \
        'user_data=self._kwargs.get("user_data", None),' \
        ""
  '';

  dependencies = with python3Packages; [
    aiorun
    asyncio-dgram
    dnspython
    ha-mqtt-discoverable
    paho-mqtt
    pyyaml
    telnetlib3
  ];

  installPhase = ''
    runHook preInstall

    # The modules have generic names like `const`, so keep them out of
    # site-packages and only on this program's own path.
    install -Dm644 -t $out/share/juicepassproxy *.py
    rm $out/share/juicepassproxy/test_*.py
    install -Dm755 juicepassproxy.py $out/bin/juicepassproxy

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    "${placeholder "out"}/share/juicepassproxy"
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  # Builds a dns.resolver.Resolver, which needs /etc/resolv.conf.
  disabledTests = [ "test_resolve_nxdomain_returns_none" ];

  meta = {
    description = "UDP proxy for JuiceBox EV chargers that publishes to MQTT with Home Assistant discovery";
    homepage = "https://github.com/JuiceRescue/juicepassproxy";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "juicepassproxy";
  };
}
