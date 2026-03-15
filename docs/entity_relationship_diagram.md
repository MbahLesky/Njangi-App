# Entity Relationship Diagram (ERD) Specification
## Njangi Mobile Application

**Version:** 1.0  
**Date:** March 2026

---

## Introduction

This document defines the Entity Relationship Diagram (ERD) for the Njangi Mobile Application. It describes the main entities, their attributes, and the relationships between them, serving as the conceptual foundation for database implementation.

---

## Core Entities

The system identifies the following main entities:
- **User:** A registered person using the application.
- **Group:** A digital Njangi group.
- **GroupMember:** Resolution of the many-to-many relationship between User and Group.
- **GroupSetting:** Configuration for a group's contribution and payout rules.
- **Circle & Session:** Payout rounds and individual contribution/payout periods.
- **PayoutRotation:** Order of fund distribution within a circle.
- **Contribution & Payout:** Records of money movements.
- **Transaction:** Unified financial audit log.
- **Engagement (Notification & Message):** Alerts and group communication.

---

## Entity Relationships

### 1. User & Group
- **Relationship:** User (1) —— (M) Group (Created by).
- **Membership:** User (M) —— (N) Group (Joined as member).
- **Join Table:** `GroupMember` resolves this relationship.

### 2. Group & Settings
- **Relationship:** Group (1) —— (1) GroupSetting.
- **Role:** Defines contribution amount, frequency, and payout method.

### 3. Group & Cycles
- **Relationship:** Group (1) —— (M) Circle.
- **Circle Details:** Circle (1) —— (M) Session (Contribution/Payout periods).

### 4. Circles & Rotations
- **Relationship:** Circle (1) —— (M) PayoutRotation.
- **Role:** Links a User to a specific Position within a Circle.

### 5. Financial Operations
- **Session & Contribution:** Session (1) —— (M) Contribution (Member payments).
- **Session & Payout:** Session (1) —— (1) Payout (Distribution of funds).

### 6. Transactions & Auditing
- **Relationship:** Group (1) —— (M) Transaction (Financial history).
- **Relationship:** User (1) —— (M) Transaction (Personal history).

### 7. Engagement
- **User & Notification:** User (1) —— (M) Notification.
- **Group & Message:** Group (1) —— (M) Message (Chat/Announcements).

---

## Business Rules Reflected

- A user can belong to multiple groups.
- Each group has exactly one active configuration (settings).
- A circle contains multiple sessions; each session has one payout recipient.
- A member contributes once per session.
- Contributions and payouts generate transaction logs for transparency.
- Notifications are tied to users and may reference groups or sessions.
- Admins have exclusive rights to record financial data and manage settings.
