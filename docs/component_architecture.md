# Component Architecture Document
## Njangi Mobile Application

**Version:** 1.0  
**Date:** March 2026

---

## Introduction

This document defines the component architecture of the Njangi Mobile Application, breaking the system into logical modules that can be developed and maintained independently.

---

## High-Level System Structure

The Njangi system follows a **3-tier architecture**:

1.  **Presentation Layer:** Mobile Client (Flutter App).
2.  **Application Layer:** Backend API (Node.js/Express).
3.  **Data Layer:** PostgreSQL Database and Cloud Storage.

---

## Component Responsibilities

### Mobile Application Components (Flutter)
- **Auth UI:** Login, register, and password reset interfaces.
- **Dashboard UI:** Group list and activity overview.
- **Group Management UI:** Group creation and settings configuration.
- **Financial UI:** Contribution recording (digital/physical), payout distribution, and report visualization.
- **Engagement UI:** Group chat, announcements, and notification center.

### Backend API Components (Node.js/Express)
- **Auth & User Module:** Handles registration, tokens, and profiles.
- **Group & Member Module:** CRUD operations for groups, membership, and roles.
- **Njangi Engine Module:** Logic for circles, sessions, and payout rotations.
- **Financial Module:** Validating and recording contributions and payouts.
- **Transaction & Reporting Module:** Audit logs and summary report generation.
- **Engagement Module:** Managing in-app notifications and messaging.

### Supporting Services
- **Notification Service:** Firebase Cloud Messaging (FCM).
- **Storage Service:** Cloud storage for profile and group photos.
- **Database Service:** PostgreSQL for persistent relational data.

---

## Component Interaction Flow

Example: **Recording a Contribution**
1.  **Mobile App:** Sends contribution request to the **Financial API**.
2.  **Financial Module:** Validates permissions and session state.
3.  **Database:** Records the contribution and creates a financial log.
4.  **Notification Module:** Triggers an alert via the **Notification Service**.
5.  **Mobile App:** Receives confirmation and updates the UI.

---

## Conclusion

The system's modular component design ensures clear separation of responsibilities, promoting maintainability and scalability as the Njangi application grows beyond its MVP version.
