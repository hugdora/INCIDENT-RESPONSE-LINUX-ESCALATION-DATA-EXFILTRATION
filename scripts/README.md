# Scripts

This directory contains Bash scripts used to simulate attacker behavior
and support incident response investigation in a controlled lab environment.

## Script Overview

| Script | Description |
|------|------------|
| `00_setup_lab.sh` | Creates sensitive files and directories used in the incident simulation |
| `01_attack_simulation.sh` | Simulates privilege escalation and data exfiltration |
| `02_cleanup.sh` | Removes attacker artifacts and restores system state |

## Execution Notes
- Scripts are executed on an Ubuntu Linux virtual machine
- All activity is monitored by Microsoft Defender for Endpoint
- Scripts are intended for **educational and defensive purposes only**

