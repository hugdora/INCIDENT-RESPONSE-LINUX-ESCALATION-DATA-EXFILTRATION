# Incident Report: Linux Privilege Escalation and Data Exfiltration

## 1. Executive Summary

On 21 January 2026, a simulated security incident was identified on an Ubuntu Linux virtual machine as part of a controlled incident response laboratory exercise. The purpose of the exercise was to validate detection, investigation, and response capabilities for Linux-based threats using Microsoft Defender for Endpoint (MDE) and Microsoft Sentinel.

The activity simulated an attacker who temporarily gained root-level access, escalated privileges for a secondary user account, accessed sensitive data, staged that data locally, exfiltrated it to cloud storage, and attempted to remove evidence by deleting the attack script. All activity occurred within an isolated Azure-based lab environment and did not impact production systems or real customer data

- **Incident Date:** 21 January 2026  
- **Detection Window:** 19:20 – 19:21 UTC  
- **Environment:** Azure-hosted Ubuntu Linux Lab VM

- **Severity:** Medium (Confirmed malicious behavior in lab context)

- **Business Risk:** No production systems or real customer data were impacted. All activity occurred within an isolated lab environment for defensive training, detection engineering, and incident response validation purposes.


## 2. Incident Classification

| Category         | Details                                  |
| ---------------- | ---------------------------------------- |
| Incident Type    | Privilege Escalation + Data Exfiltration |
| Platform         | Linux (Ubuntu)                           |
| Detection Source | Microsoft Defender for Endpoint          |
| Severity         | Medium (Lab Simulation – Confirmed Malicious Behavior)                  |
| Status           | Contained                                |
| Environment      | Isolated lab VM                          |

## 3. Scope

- **Affected device(s):** Ubuntu Linux virtual machine (`ubuntu-lab.p2zfvso05mlezjev3ck4vqd3kd.cx.internal.cloudapp.net`)
- **Affected user account(s):** Local user account `badactor`
- **Sensitive Data:** Simulated sensitive file `.secret_data/employee_records.txt`


## 4. Impact Assessment

- Unauthorised privilege escalation via modification of `sudo` group membership
- Access to sensitive data file containing simulated PII
- Local data staging within `/tmp/.stage`
- Simulated data exfiltration to Azure Blob Storage
- Partial evidence removal via script self-deletion

> No persistence mechanisms, lateral movement, or additional compromised accounts were observed.

## 5. Timeline of Events (UTC)

| Time (UTC) | Event | Evidence |
|----------|------|-----------------|
| 2026-01-21 19:20:09 | Privilege escalation detected |`usermod -aG sudo badactor` |
| 2026-01-21 19:20:10 | Sensitive file accessed | Access to `employee_records.txt` |
| 2026-01-21 19:20:11 | Data staged | File copied to `/tmp/.stage` |
| 2026-01-21 19:20:12 | Data exfiltration | Storage blob upload |
| 2026-01-21 19:20:13 | Evidence removal (script self-deletion)|rm 01_attack_simulation.sh |

> All timestamps were reconstructed using Microsoft Defender for Endpoint telemetry and correlated via the master timeline hunting query.

## 6. Evidence Collected

## - **Endpoint Telemetry (Microsoft Defender for Endpoint)** 

The following command-line activities were captured and validated via Advanced Hunting:

  - Local user creation (`useradd badactor`)
  - Privilege escalation (`usermod -aG sudo badactor`)
  - Data staging (`cp .secret_data/employee_records.txt /tmp/.stage/`)
  - Cloud exfiltration: `az storage blob upload`
  - Script self-deletion (`rm 01_attack_simulation.sh`)

## - **Detection Correlation (Microsoft Sentinel)** 
A scheduled analytics rule correlated the above behaviors into a single incident using:
  - Device name
  - User account
  - Process command-line patterns
  - Time-based correlation


## 7.  Detection & Investigation (NIST 800-61)

### Phase 1: Preparation
- Endpoint telemetry enabled via Microsoft Defender for Endpoint
- Advanced Hunting queries preconfigured
- Cloud storage destination prepared for simulation

### Phase 2: Detection and Analysis
The incident was detected through manual hunting and later operationalized into a Microsoft Sentinel analytics rule. The following KQL queries were used during investigation:

-  `01_privilege_escalation_usermod.kql` (Privilege escalation detection)

- `02_user_creation_useradd.kql` (User creation )

-  `03_data_staging_copy_to_tmp_stage.kql` (Data staging)

-  `04_azure_blob_upload_exfil.kql` (Exfiltration simulation) 

-  `05_script_self_delete.kql` (Script self-deletion)
  
-  `06_master_timeline_reconstruction.kql` (Timeline reconstruction)

> Each query focused on a distinct stage of the attack lifecycle and contributed to a complete timeline reconstruction.

## 8. MITRE ATT&CK Mapping

| Technique ID | Technique                         |
| ------------ | --------------------------------- |
| T1136.001    | Create Account (Local)            |
| T1098        | Account Manipulation              |
| T1074        | Data Staged                       |
| T1567        | Exfiltration to Cloud Storage     |
| T1070.004    | Indicator Removal (File Deletion) |


## 9. Containment Actions
- Removed unauthorised sudo group membership
- Disabled or restricted the badactor account
- Deleted staged data from /tmp/.stage
- Isolated the VM from external network access
- Sentinel incident created and triaged


## 10. Eradication

- Verified no additional malicious users or scripts existed

- Confirmed no persistence mechanisms were deployed

- Restored system configuration to a known-good state

## 11. Recovery
- Reapplied least-privilege access controls
- Validated alerting and detection logic
- Continued monitoring via MDE and Sentinel


## 12. Lessons Learned

## - **What Worked Well** 
- MDE successfully captured detailed process and file telemetry
- Timeline reconstruction clearly correlated attacker actions
- MITRE ATT&CK mapping improved investigation clarity and reporting

## - **Gaps Identified** 
- No real-time alerting was configured for Linux privilege escalation events
- Cloud exfiltration activity relied on hunting rather than automated alerts

## 13. Recommendations

1. Enable real-time alerts for Linux privilege escalation events
2. Monitor cloud CLI usage on non-administrative systems
3. Increase visibility into hidden directories under user home paths
4. Enforce least-privilege access for local users
5. Implement automated response actions for detected escalation events
6. Regularly validate detection logic using controlled simulations

## 14. Conclusion

This incident response simulation demonstrated end-to-end detection, investigation, and response capabilities for a Linux-based privilege escalation and data exfiltration scenario. The exercise validated the effectiveness of Microsoft Defender for Endpoint telemetry and Advanced Hunting queries in reconstructing attacker behavior, supporting analyst decision-making, and aligning investigative findings with established frameworks such as NIST 800-61 and MITRE ATT&CK.

> This lab highlights practical SOC-level investigation skills, detection engineering, and incident response methodology in a controlled environment.


