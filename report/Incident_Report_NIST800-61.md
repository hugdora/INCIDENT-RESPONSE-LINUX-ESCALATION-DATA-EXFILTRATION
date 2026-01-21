# Incident Report: Linux Privilege Escalation + Data Exfiltration

## Executive Summary

- **Overview:** A simulated security incident was identified on an Ubuntu Linux virtual machine as part of an incident response lab exercise designed to validate detection and investigation capabilities.

- **Impact:** The activity involved unauthorised privilege escalation, access to sensitive data, data staging, a simulated cloud exfiltration attempt, and partial attacker cleanup activity.

- **Detection & Investigation:** Microsoft Defender for Endpoint (MDE) telemetry and Advanced Hunting queries were used to detect, investigate, and reconstruct the attacker’s actions. The investigation confirmed that a local user escalated privileges by modifying group membership, accessed a sensitive file, staged the data in a temporary directory, simulated data exfiltration using a cloud storage CLI tool, and attempted to remove evidence by deleting the attack script.

- **Business Risk:** No production systems or real customer data were impacted. All activity occurred within an isolated lab environment for defensive training, detection engineering, and incident response validation purposes.


## Incident Classification

| Category         | Details                                  |
| ---------------- | ---------------------------------------- |
| Incident Type    | Privilege Escalation + Data Exfiltration |
| Platform         | Linux (Ubuntu)                           |
| Detection Source | Microsoft Defender for Endpoint          |
| Severity         | Medium (Lab Simulation – Confirmed Malicious Behavior)                  |
| Status           | Contained                                |
| Environment      | Isolated lab VM                          |

## Scope

- **Affected device(s):** Ubuntu Linux virtual machine
- **Affected user account(s):** Local user account `badactor`
- **Data involved:** Simulated sensitive file `.secret_data/employee_records.txt`


## Impact

- Privilege escalation to the `sudo` group
- Unauthorised access to sensitive data
- Data staging within `/tmp/.stage`
- Simulated cloud exfiltration attempt
- Partial evidence removal via script self-deletion

No lateral movement, persistence mechanisms, or additional compromised accounts were observed.


## Timeline (UTC)

| Time (UTC) | Activity                                          |
| ---------- | ------------------------------------------------- |
| T0         | Lab setup script created sensitive data artifacts |
| T1         | Privilege escalation using `usermod`              |
| T2         | Sensitive file accessed                           |
| T3         | Data staged to `/tmp/.stage`                      |
| T4         | Simulated cloud exfiltration via Azure CLI        |
| T5         | Attack script deleted                             |

All timestamps were reconstructed using Microsoft Defender for Endpoint telemetry and correlated via the master timeline query.

> Detailed reconstruction was performed using `06_master_timeline_reconstruction.kql.`

## NIST 800-61 Phases

### 1) Preparation
- Logging/EDR present (MDE)
- Storage account created (exfil destination)
- Baseline expectations

### 2) Detection & Investigation
####      Detection Methods

Each activity was validated through process command-line analysis, parent-child process relationships, and associated file events.

The incident was detected using Microsoft Defender for Endpoint Advanced Hunting queries, including:

- Privilege escalation detection (`usermod`)

- User creation (`useradd`)

- Data staging (`cp`)

- Exfiltration simulation (`az storage blob upload`)

- Script self-deletion (`rm`)

####      Key Queries Used

- `01_privilege_escalation_usermod.kql`

- `02_user_creation_useradd.kql`

- `03_data_staging_copy_to_tmp_stage.kql`

- `04_azure_blob_upload_exfil.kql`

- `05_script_self_delete.kql`

- `06_master_timeline_reconstruction.kql`

####      MITTRE ATT&CK Mapping

| Technique ID | Technique                         |
| ------------ | --------------------------------- |
| T1136.001    | Create Account (Local)            |
| T1098        | Account Manipulation              |
| T1074        | Data Staged                       |
| T1567        | Exfiltration to Cloud Storage     |
| T1070.004    | Indicator Removal (File Deletion) |


### 3) Containment
- The affected user account was disabled or restricted
- Unauthorised sudo group membership was removed
- The attack script execution was halted
- The affected VM was isolated from external connectivity



### 4) Eradication

- Removed unauthorised `sudo` group membership

- Deleted staged data in `/tmp/.stage`

- Verified no additional malicious files or users existed

- Restored VM to a known-good state

### 5) Recovery
- Restored least privilege
- Validated no further suspicious activity
- Monitored with detections


## 6) Lessons Learned

### What Worked Well
- MDE successfully captured detailed process and file telemetry
- Timeline reconstruction clearly correlated attacker actions
- MITRE ATT&CK mapping improved investigation clarity and reporting

### Gaps Identified
- No real-time alerting was configured for Linux privilege escalation events
- Cloud exfiltration activity relied on hunting rather than automated alerts

## Recommendations

1. Enable real-time alerts for Linux privilege escalation events
2. Monitor cloud CLI usage on non-administrative systems
3. Increase visibility into hidden directories under user home paths
4. Enforce least-privilege access for local users
5. Implement automated response actions for detected escalation events
6. Regularly validate detection logic using controlled simulations

## Conclusion

This incident response simulation demonstrated end-to-end detection, investigation, and response capabilities for a Linux-based privilege escalation and data exfiltration scenario. The exercise validated the effectiveness of Microsoft Defender for Endpoint telemetry and Advanced Hunting queries in reconstructing attacker behavior, supporting analyst decision-making, and aligning investigative findings with established frameworks such as NIST 800-61 and MITRE ATT&CK.

This lab highlights practical SOC-level investigation skills, detection engineering, and incident response methodology in a controlled environment.


