# INCIDENT-RESPONSE-LINUX-ESCALATION & DATA-EXFILTRATION
Linux incident response privilege escalation and data exfiltration with investigation using Microsoft Defender for Endpoint and KQL.

## Overview
This project simulates a real-world Linux security incident involving:
- Unauthorised privilege escalation
- Data exfiltration to cloud storage
- Investigation using Microsoft Defender for Endpoint (MDE)
- Detection and hunting using KQL
- Incident reporting aligned with NIST 800-61

The goal of this lab is to demonstrate practical incident response skills, not exploitation.

---

## Scenario Summary
An attacker gains access to an unlocked administrative Linux session and deploys a malicious script that:
1. Escalates privileges by adding a user to the sudo group
2. Exfiltrates sensitive data to Azure Blob Storage
3. Attempts to remove evidence by deleting the script

The incident is detected and investigated using Microsoft Defender for Endpoint telemetry.

---

## Environment
- Ubuntu Linux (Azure VM)
- Microsoft Defender for Endpoint (Linux)
- Azure Storage Account (Blob)
- Azure CLI
- Bash
- KQL (Advanced Hunting)

---

## Repository Structure

- `scripts/` → Attack simulation and cleanup scripts
- `docs/` → Architecture and investigation walkthrough
- `kql/` → Defender Advanced Hunting queries
- `report/` → Formal incident report (NIST 800-61)

---

## Skills Demonstrated
- Linux privilege management and investigation
- Incident response lifecycle (NIST 800-61)
- Endpoint detection and response (EDR)
- Threat hunting with KQL
- Cloud data exfiltration analysis
- Security documentation and reporting

---

## Disclaimer
This project is for **educational and defensive purposes only** and was conducted in an isolated lab environment using test data.

