# Lab Execution Steps (Attack Simulation Phase)

This document describes how attacker behavior was simulated on the Ubuntu VM after the lab setup phase.
The actions performed represent common post-compromise techniques observed in real-world incidents.

---

## Script Used

```
 01_attack_simulation.sh
```
---

## Attack Objectives
The simulated attacker performs the following actions:

1. Creates or reuses a local attacker-controlled user account
2. Escalates privileges by adding the user to the `sudo` group
3. Accesses a protected sensitive data file
4. Stages the data locally in a hidden temporary directory
5. Simulates data exfiltration to Azure Blob Storage
6. Deletes the attack script to mimic attacker cleanup behavior


---

## Prerequisites

- Lab setup phase completed (`00_setup_lab.sh`)
- Ubuntu Linux virtual machine
- User session with sufficient privileges to execute the script
- Microsoft Defender for Endpoint onboarded for telemetry collection
- Azure CLI installed for cloud exfiltration simulation

---

## Execution Steps (on the VM)

### 1) Make the attack script executable

```
chmod +x 01_attack_simulation.sh

```

### 2) Enable Cloud Exfiltration Simulation

Cloud exfiltration only occurs if all required Azure environment variables are set at runtime:
```
export AZURE_STORAGE_ACCOUNT=<account_name>
export AZURE_STORAGE_CONTAINER=<container_name>
export AZURE_STORAGE_KEY=<storage_key>
```

### 3) Enable Script Self-Deletion (Attacker Cleanup)

To simulate attacker cleanup behavior:

```
export SELF_DELETE=true
```
### 4) Execute the attack simulation

```
./01_attack_simulation.sh

```

---
### Simulated Attacker Actions (What Happens)

During execution, the script performs the following:

- Modifies user group membership using `usermod`

- Reads the sensitive file created in the setup phase
  
- Copies the file to a hidden staging directory (`/tmp/.stage`)

- Executes commands consistent with data staging or exfiltration

- Deletes itself to mimic attacker cleanup behaviour


## Validation (Expected Effects)
---
### Privilege escalation

Confirm the user was added to the sudo group:
```
groups badactor

```
### Data Staging

Confirm the staged file exists: 
```
ls /tmp/.stage
```

### Script removal
Confirm the attack script is no longer present
```
ls 
```
> Note: Script self-deletion only occurs if the environment variable

> `SELF_DELETE=true` is set before execution.


---

## Telemetry to Review in Microsoft Defender for Endpoint

If MDE is onboarded, the following activity should be observable:

- Process execution for `usermod`

- Command-line activity modifying group membership

- File access to `.secret_data/employee_records.txt`

- Script execution followed by file deletion
  
- File copy activity from home directory to `/tmp/.stage`

---

> These signals are intentionally generated to support detection and investigation during the incident response phase.

## Notes

- This attack simulation is intentionally simplified and designed solely for defensive learning.

- No real data is exfiltrated.

- All activity occurs within an isolated lab environment.

- The generated telemetry supports detection engineering, hunting, and incident response exercises.
