# 📘 Documentation
This directory contains the supporting documentation for the Linux Privilege Escalation and Data Exfiltration Incident Response Lab.
The materials in this folder provide architectural context, detection logic explanations, and step-by-step investigation walkthroughs that complement the formal incident report.

> All documentation is aligned with SOC analyst workflows, NIST 800-61, and MITRE ATT&CK, and reflects hands-on detection engineering and investigation activities performed using Microsoft Defender for Endpoint and Microsoft Sentinel.

# 📂 Contents

## 🔹 attack_simulation_steps.md

Describes how the controlled attack simulation was executed on the Ubuntu Linux VM, including:

- Attacker user creation

- Privilege escalation logic

- Sensitive data staging

- Cloud exfiltration simulation

- Script self-deletion behavior

> This document provides context for the telemetry observed during detection and investigation.

## 🔹 detection_investigation.md

Explains how the malicious activity was detected and analyzed using:

- Microsoft Defender for Endpoint Advanced Hunting

- Process command-line analysis

- Parent/child process relationships

- Timeline correlation

> Includes rationale behind detection logic and how individual signals were validated.

## 🔹 lab_execution_steps.md

Provides a reproducible, step-by-step walkthrough for:

- Lab environment preparation

- Tooling setup (MDE, Sentinel, Azure)

- Running the attack simulation

- Validating telemetry ingestion

- Confirming detections and alerts

> This file enables other analysts to recreate the lab safely for learning or validation purposes.
