#!/usr/bin/env bash
set -euo pipefail
ARCH="$(dpkg --print-architecture)"
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
elif command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
else
  echo "This installer needs root privileges. Re-run as root or install sudo." >&2
  exit 1
fi

run_privileged() {
  if [ -n "$SUDO" ]; then
    "$SUDO" "$@"
  else
    "$@"
  fi
}

curl -fsSL 'https://rocketresearch-inc.github.io/compair-packages/gpg.key' | run_privileged gpg --dearmor --batch --yes -o /usr/share/keyrings/compair-archive-keyring.gpg
echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/compair-archive-keyring.gpg] https://rocketresearch-inc.github.io/compair-packages/apt stable main" | run_privileged tee /etc/apt/sources.list.d/compair.list >/dev/null
if ! run_privileged apt-get update; then
  echo "Warning: full apt metadata refresh failed, likely due to another configured repository." >&2
  echo "Attempting a Compair-only refresh so the install can continue." >&2
  run_privileged apt-get update \
    -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/compair.list \
    -o Dir::Etc::sourceparts=- \
    -o APT::Get::List-Cleanup=0
fi
run_privileged apt-get install -y compair
