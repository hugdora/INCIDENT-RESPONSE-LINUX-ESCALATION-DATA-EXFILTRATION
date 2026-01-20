# Lab Execution Steps (Attack Simulation Phase)

This document describes how attacker behavior was simulated on the Ubuntu VM after the lab setup phase.
The actions performed represent common post-compromise techniques observed in real-world incidents.

---

## Script Used
- `scripts/01_attack_simulation.sh`

---

## Attack Objectives
The simulated attacker performs the following actions:

1. Escalates privileges by adding a user to the `sudo` group
2. Accesses sensitive data created during the setup phase
3. Simulates data exfiltration to an external destination
4. Attempts to reduce evidence by deleting the attack script

---

## Prerequisites
- Lab setup phase completed (`00_setup_lab.sh`)
- Ubuntu Linux VM
- User session with sufficient privileges to execute the script
- (Optional) Microsoft Defender for Endpoint onboarded for telemetry collection

---

## Execution Steps (on the VM)

### 1) Make the attack script executable
```bash
chmod +x scripts/01_attack_simulation.sh
```
### 2) Execute the attack simulation

```bash
./scripts/01_attack_simulation.sh

```
---
### Simulated Attacker Actions (What Happens)

During execution, the script performs the following:

- Modifies user group membership using usermod

- Reads the sensitive file created in the setup phase

- Executes commands consistent with data staging or exfiltration

- Deletes itself to mimic attacker cleanup behavior

### Validation (Expected Effects)
---
Privilege escalation

Confirm the user was added to the sudo group:
`groups <attacker_user>`

### Script removal
Confirm the attack script is no longer present: `ls scripts/`

---

## Telemetry to Review in Microsoft Defender for Endpoint

If MDE is onboarded, the following activity should be observable:

- Process execution for `usermod`

- Command-line activity modifying group membership

- File access to `.secret_data/employee_records.txt`

- Script execution followed by file deletion

These signals are intentionally generated to support detection and investigation during the incident response phase.
---
## Notes

This attack simulation is intentionally simplified and designed for defensive learning.
No real data is exfiltrated, and all activity occurs in an isolated lab environment.
