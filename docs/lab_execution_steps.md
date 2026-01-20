# Lab Execution Steps (Setup Phase)

This document shows how the lab setup script was executed on the Ubuntu VM to create test artifacts for the incident simulation.

## Script Used
- `scripts/00_setup_lab.sh`

## Purpose
Creates a hidden directory and a dummy “sensitive” file that will later be used to simulate data exfiltration.  
This step prepares artifacts so Microsoft Defender for Endpoint (MDE) can capture file creation activity.

## Prerequisites
- Ubuntu Linux VM (lab environment)
- Git installed
- (Optional) Microsoft Defender for Endpoint onboarded on the VM for telemetry collection

## Execution Steps (on the VM)

### 1) Clone the repository
```bash
git clone https://github.com/<YOUR_GITHUB_USERNAME>/INCIDENT-RESPONSE-LINUX-ESCALATION-DATA-EXFILTRATION.git
cd INCIDENT-RESPONSE-LINUX-ESCALATION-DATA-EXFILTRATION
```

### 2) Make the script executable
```
chmod +x scripts/00_setup_lab.sh
```
### 3) Run the script

```
./scripts/00_setup_lab.sh
```
## Validation (confirm artifacts exist)

### - Confirm the directory exists
```
ls -la /home/$USER/.secret_data
```
### - Confirm the file exists

```
cat /home/$USER/.secret_data/employee_records.txt

```

### - Confirm permissions were applied

```
stat /home/$USER/.secret_data
stat /home/$USER/.secret_data/employee_records.txt
```

### - Expected outcome:

- Directory permissions should be `700`
- File permissions should be `600`

### - Telemetry to Review in MDE (optional)

If MDE is onboarded, you should be able to hunt for:

- File/directory creation under `.secret_data`

- Command execution for `chmod`, `mkdir`, and `echo`

This setup phase is intentionally simple so the next phases (privilege escalation + exfiltration) are easy to correlate in an investigation timeline.
