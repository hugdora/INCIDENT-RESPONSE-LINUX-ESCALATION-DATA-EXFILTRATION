# Incident Report

This directory contains the formal incident response report for a simulated Linux security incident involving privilege escalation and data exfiltration.  
The report was produced as part of a hands-on defensive security lab to demonstrate detection engineering, investigation workflows, and incident response practices.

## Overview

The incident scenario simulates an attacker performing the following actions on an Ubuntu Linux virtual machine:

- Privilege escalation through modification of sudo group membership
- Unauthorised access to sensitive data
- Local data staging in a temporary directory
- Simulated data exfiltration to cloud storage
- Attempted evidence removal via script self-deletion

All activity occurred within an isolated Azure-hosted lab environment and did **not** impact production systems or real customer data.

## Methodology

The investigation and response process follows the **NIST SP 800-61 Incident Response Lifecycle**, including:

1. Preparation  
2. Detection and Analysis  
3. Containment  
4. Eradication  
5. Recovery  
6. Lessons Learned  

Endpoint telemetry was collected using **Microsoft Defender for Endpoint (MDE)** and correlated using **Microsoft Sentinel** analytics rules and hunting queries.

## Contents

The full incident report includes:

- Executive summary and impact assessment
- Scope and affected assets
- Detailed timeline with supporting evidence
- Detection logic and KQL queries
- MITRE ATT&CK technique mapping
- Containment, eradication, and recovery actions
- Lessons learned and security recommendations

## Purpose

This report demonstrates practical SOC-level skills, including:

- Linux endpoint investigation
- Advanced Hunting with KQL
- Detection rule development in Microsoft Sentinel
- Timeline reconstruction
- Incident documentation aligned with industry frameworks

The report is intended for **educational, defensive, and portfolio demonstration purposes only**.

---

