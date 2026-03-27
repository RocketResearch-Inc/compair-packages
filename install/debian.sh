#!/usr/bin/env bash
set -euo pipefail
curl -fsSL 'https://rocketresearch-inc.github.io/compair-packages/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/compair-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/compair-archive-keyring.gpg] https://rocketresearch-inc.github.io/compair-packages/apt stable main' | sudo tee /etc/apt/sources.list.d/compair.list >/dev/null
sudo apt-get update
sudo apt-get install -y compair
