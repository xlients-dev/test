#!/usr/bin/env bash
set -euo pipefail

echo "[+] Welcome to obscat!"

# Download area
INSTALL_DIR="$HOME/.local/obscat"
BIN_DIR="/usr/local/obscat/bin"

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "[+] Downloading obscat@latest version..."
wget -q --show-progress https://github.com/xlients-dev/test/releases/download/test/obscat.tar.gz

echo "[+] Extracting..."
tar -xzf obscat.tar.gz
rm -f obscat.tar.gz

echo "[+] Making binaries executable..."
chmod +x bin/obscat bin/obscatd

echo "[+] Moving binaries to $BIN_DIR..."
sudo mkdir -p /usr/local/obscat
sudo mv bin /usr/local/obscat/

# Persistent PATH update
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "export PATH=\$PATH:$BIN_DIR"
  export PATH="$PATH:$BIN_DIR"
fi

echo "[+] Testing obscat binary..."
obscat version || {
  echo "[-] Failed to run obscat"
  exit 1
}

echo "[+] Installing dependencies..."
sudo apt update -y
sudo apt install -y nginx postgresql

# Add PostgreSQL bin to PATH (persistent)
PG_BIN="/usr/lib/postgresql/17/bin"
if [[ -d "$PG_BIN" && ":$PATH:" != *":$PG_BIN:"* ]]; then
  echo "export PATH=\$PATH:$PG_BIN"
  export PATH="$PATH:$PG_BIN"
fi

echo "[+] Setting up database..."
bash "$INSTALL_DIR/setupdb.sh"

echo "[✓] Installation complete! Please restart your shell or run: source"
