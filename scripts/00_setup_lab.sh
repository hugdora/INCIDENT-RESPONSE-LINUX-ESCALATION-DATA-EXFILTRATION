#!/bin/bash
# Sets up lab artifacts for incident simulation

STAGE_DIR="/home/$USER/.secret_data"
SECRET_FILE="$STAGE_DIR/employee_records.txt"

sudo mkdir -p "$STAGE_DIR"
echo "Employee: Jane Doe | SSN: 123-45-6789" > "$SECRET_FILE"

sudo chmod 700 "$STAGE_DIR"
sudo chmod 600 "$SECRET_FILE"

echo "[+] Lab setup complete. Sensitive file created."


