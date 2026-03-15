# System Architecture Document (SAD)
## Njangi Mobile Application

**Version:** 1.0  
**Date:** March 2026

---

## Introduction

This document defines the system architecture of the Njangi Mobile Application. It describes the overall structure of the system, its major components, and the technologies used to support the application's digital Njangi group management.

---

## Architectural Style

The system follows a **3-tier, client-server architecture**, consisting of:

1.  **Presentation Layer:** Mobile Client Application.
2.  **Application Layer:** Backend Application Server.
3.  **Data Layer:** Database and File Storage.

---

## High-Level Architecture

### Mobile Client Application (Flutter)
The frontend used by end users for all interactions.
- **Responsibilities:** Displaying UI, navigation, input validation, and communication with the backend.

### Backend Application Server (Node.js/Express)
The core business logic layer.
- **Responsibilities:** User authentication, group and member management, processing circles and sessions, contribution/payout management, and report generation.

### Database Server (PostgreSQL)
The persistent data storage layer.
- **Responsibilities:** Storing users, groups, memberships, sessions, contributions, payouts, and transaction logs.

### Supporting Services
- **Notification Service:** Firebase Cloud Messaging (FCM) for push notifications and reminders.
- **File Storage:** Cloud storage for profile photos and group images.

---

## Proposed Technology Stack

- **Mobile Application:** Flutter (Single codebase for Android and iOS).
- **Backend API:** Node.js with Express or NestJS (REST API).
- **Database:** PostgreSQL (Relational database for structured financial data).
- **Authentication:** JWT (Access and Refresh token flow).
- **Notifications:** Firebase Cloud Messaging (FCM).

---

## Core System Modules

The backend is organized into the following feature-based modules:
- **Authentication & User:** Registration, login, and profile management.
- **Group & Membership:** Group creation, join/invite flow, and member role assignment.
- **Njangi Engine (Circle & Session):** Lifecycle logic for payout rounds and individual sessions.
- **Financial (Contribution & Payout):** Record-keeping and validation for all payments.
- **Transaction & Reporting:** Auditable history and financial aggregation.
- **Engagement (Notification & Chat):** Real-time alerts and group communication.

---

## Security Architecture

- **Authentication:** Secure login with JWT access tokens and periodic refreshes.
- **Authorization:** Role-Based Access Control (RBAC). Admins only for group settings and financial recording; group members only for internal group data.
- **Encryption:** Password hashing (bcrypt) and HTTPS communication for all API requests.
- **Auditability:** Immutability of transaction logs for financial traceability.
