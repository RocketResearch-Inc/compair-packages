#!/usr/bin/env bash
set -euo pipefail
ARCH="$(dpkg --print-architecture)"
curl -fsSL 'https://rocketresearch-inc.github.io/compair-packages/gpg.key' | sudo gpg --dearmor --batch --yes -o /usr/share/keyrings/compair-archive-keyring.gpg
echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/compair-archive-keyring.gpg] https://rocketresearch-inc.github.io/compair-packages/apt stable main" | sudo tee /etc/apt/sources.list.d/compair.list >/dev/null
if ! sudo apt-get update; then
  echo "Warning: full apt metadata refresh failed, likely due to another configured repository." >&2
  echo "Attempting a Compair-only refresh so the install can continue." >&2
  sudo apt-get update \
    -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/compair.list \
    -o Dir::Etc::sourceparts=- \
    -o APT::Get::List-Cleanup=0
fi
sudo apt-get install -y compair
