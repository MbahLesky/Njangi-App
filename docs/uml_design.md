# UML Design Document
## Njangi Mobile Application

**Version:** 1.0  
**Date:** March 2026

---

## Introduction

This document defines the Unified Modeling Language (UML) representation for the Njangi Mobile Application. It provides a structural view of the system using UML models to describe actors, behavior, and interactions.

---

## Main Actors

- **User:** Registered individual participating in Njangi activities.
- **Group Admin:** User with management rights (members, sessions, payments).
- **Group Member:** Participant without administrative privileges.
- **System:** The application managing data and automated processes.

---

## Class Definitions

### Core Classes
- **User:** Handles registration, login, and profile updates.
- **Group:** Manages metadata, settings, and lifecycle (active/archived).
- **GroupMember:** Tracks membership, roles (Admin/Member), and status.
- **GroupSetting:** Defines contribution amounts and schedules.
- **Circle & Session:** Manages the Njangi cycles and individual payment periods.
- **Contribution & Payout:** Records individual payments and fund distributions.
- **Transaction:** Unified log for auditing financial movements.
- **Notification & Message:** Handles system alerts and group communication.

---

## Key Workflows (Sequence Diagrams)

### 1. Create Group
User inputs group details → System validates and creates group → System assigns user as Admin → Success.

### 2. Record Contribution
Admin selects member/session → Inputs payment details → System validates admin rights → System saves contribution and updates session totals → System triggers member notification.

### 3. Confirm Payout
Admin confirms payout → System validates recipient → System records payout and marks session complete → System advances to next session or closes circle.

---

## Lifecycle States

### Group States
- **Created:** Initial setup phase.
- **Active:** Normal operation (circles running).
- **Archived:** Historical view, no longer active.

### Circle & Session States
- **Pending:** Scheduled but not yet current.
- **Active:** Currently accepting contributions or pending payout.
- **Completed:** Payout confirmed and period closed.

---

## Conclusion

This UML design provides a structured representation of the Njangi MVP, ensuring a clear understanding of actor roles, class relationships, and core system workflows.
