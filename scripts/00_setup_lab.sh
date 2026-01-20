#!/bin/bash
# Sets up lab artifacts for incident simulation

SECRET_DIR="/home/$USER/.secret_data"
SECRET_FILE="$SECRET_DIR/employee_records.txt"

mkdir -p "$SECRET_DIR"
echo "Employee: Jane Doe | SSN: 123-45-6789" > "$SECRET_FILE"

chmod 700 "$SECRET_DIR"
chmod 600 "$SECRET_FILE"

echo "[+] Lab setup complete. Sensitive file created."


