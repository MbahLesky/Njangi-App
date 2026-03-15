# Data Requirements Document (DRD)
## Njangi Mobile Application

**Version:** 1.0  
**Date:** March 2026

---

## Introduction

This document defines the data requirements for the Njangi Mobile Application. It describes the types of data the system must store, manage, and process to support core functionality, serving as the foundation for database design and the Entity Relationship Diagram (ERD).

---

## Data Categories

The system manages the following core data categories:
- **User Data:** Profiles and authentication.
- **Group Data:** Njangi groups and configurations.
- **Membership Data:** User-to-group relationships and roles.
- **Circle & Session Data:** Cycle tracking and individual sessions.
- **Contribution & Payout Data:** Financial transaction records.
- **Notifications & Messaging:** Communication logs and system alerts.

---

## Core Data Entities

### User
- **Identifier:** Unique User ID, Phone Number (Primary login), Email.
- **Profile:** Full Name, Photo, Password Hash.
- **Status:** Active, Suspended, or Inactive.
- **Timestamps:** Account creation and last login.

### Group
- **Metadata:** Name, Description, Group Image, Created By.
- **Configuration:** Contribution Amount, Frequency (weekly, monthly), Start Date.
- **Status:** Active, Inactive, or Archived.
- **Access:** Unique Invite Code.

### Membership
- **Relationship:** User ID and Group ID link.
- **Roles:** Admin or Member.
- **Attributes:** Join Date, Payout Position, and Status (Active/Removed).

### Circles & Sessions
- **Circle:** Full cycle tracking with start/end dates and total sessions.
- **Session:** Individual contribution period linked to a circle. Includes session number, due date, payout recipient, and collected amount.
- **Status:** Pending, Active, or Completed.

### Financial Transactions
- **Contribution:** Records of payments made by members (amount, method, date, note).
- **Payout:** Records of funds distributed to members (amount, recipient, confirmation date).
- **Transaction Log:** Unified history for auditing all financial events.

---

## Data Integrity and Security

- **Uniqueness:** Each user must have a unique account; members cannot duplicate in a group.
- **Validation:** Contributions must match group settings; one payout recipient per session.
- **Protection:** Passwords must be encrypted; role-based access control (RBAC) enforced.
- **Auditability:** Only admins can record financial data; transaction history must be immutable.
- **Storage:** Use of a relational database (PostgreSQL) to enforce referential integrity and transaction safety.
