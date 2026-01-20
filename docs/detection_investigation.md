# Detection & Investigation Phase

This phase focuses on detecting, correlating, and reconstructing attacker activity generated during the attack simulation phase using Microsoft Defender for Endpoint (MDE) Advanced Hunting.

The objective is to demonstrate how a SOC analyst would identify malicious behavior, validate attacker techniques, and build a timeline of compromise.

---

## Data Source

- Microsoft Defender for Endpoint (MDE)
- Advanced Hunting tables:
  - DeviceProcessEvents
  - DeviceFileEvents

---

## Detection Strategy

Each detection query targets a specific attacker technique observed during the simulation. Queries are executed independently and then correlated to build a full incident timeline.

---

## Individual Detection Queries

### Privilege Escalation – Account Manipulation
**Query:** `01_privilege_escalation_usermod.kql`  
**Technique:** T1098 – Account Manipulation  

Detects abuse of the `usermod` command to add a user to the `sudo` group, indicating privilege escalation.

---

### Persistence – Local Account Creation
**Query:** `02_user_creation_useradd.kql`  
**Technique:** T1136.001 – Create Account (Local)  

Identifies creation of new local users that may be used for persistence.

---

### Data Staging
**Query:** `03_data_staging_copy_to_tmp_stage.kql`  
**Technique:** T1074 – Data Staged  

Detects copying of sensitive files to a staging directory prior to exfiltration.

---

### Data Exfiltration – Cloud Storage
**Query:** `04_azure_blob_upload_exfil.kql`  
**Technique:** T1567 – Exfiltration to Cloud Storage  

Monitors Azure CLI usage indicative of uploads to external blob storage.

---

### Defense Evasion – Indicator Removal
**Query:** `05_script_self_delete.kql`  
**Technique:** T1070.004 – Indicator Removal (File Deletion)  

Detects deletion of the attack script to reduce forensic evidence.

---

## Timeline Reconstruction

### Master Timeline Query
**Query:** `06_master_timeline_reconstruction.kql`

This query correlates:
- Process execution events
- File creation, access, and deletion events

It produces a unified, chronological view of attacker activity and maps each action to its corresponding MITRE ATT&CK technique.

---

## Investigation Outcome

The reconstructed timeline confirms:

- Initial privilege escalation
- Unauthorized account manipulation
- Access to sensitive data
- Data staging and exfiltration behavior
- Attempted attacker cleanup

This sequence is consistent with real-world post-compromise attacker behavior.

---

## Analyst Takeaways

- Endpoint telemetry provides high-fidelity detection for Linux attacks
- Timeline reconstruction is critical for understanding attacker intent
- MITRE ATT&CK mapping improves investigation clarity and reporting
