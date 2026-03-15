# Use Case Specification
## Njangi Mobile Application

**Version:** 1.0  
**Date:** March 2026

---

## Introduction

This document defines the use case specifications for the Njangi Mobile Application. It describes the interactions between users (actors) and the system to achieve specific goals, guiding development and testing.

---

## Actors

- **User:** A registered individual who uses the application to create or join groups.
- **Group Admin:** A user with administrative privileges within a group (manages members, sessions, and payments).
- **Group Member:** A user participating in a group without admin privileges.
- **System:** The Njangi Mobile Application itself, responsible for data management and notifications.

---

## Use Case Specifications

### Authentication & Profile
- **UC-01: Register User:** A new user creates an account by entering personal details (name, phone, email, password).
- **UC-02: Login User:** A registered user enters credentials to access the application dashboard.

### Group Management
- **UC-03: Create Njangi Group:** A user creates a new group, defines rules, and automatically becomes the first group admin.
- **UC-04: Join Njangi Group:** A user joins an existing group using an invite code or link, with optional admin approval.
- **UC-05: Manage Group Members:** An admin views the member list and can add, remove, or promote members to admin roles.

### Njangi Operations
- **UC-06: Configure Contribution Settings:** An admin sets or updates the group's contribution amount, frequency, and start date.
- **UC-07: Start Njangi Circle:** An admin starts a new cycle, triggering the system to generate sessions and determine the payout rotation.
- **UC-08: Manage Sessions:** An admin monitors session progress and views member payment status.
- **UC-09: Record Contribution:** An admin records a member's payment for an active session.
- **UC-10: Mark Physical Contribution:** An admin logs a payment made physically (cash) during a group meeting.
- **UC-11: Manage Payout Rotation:** An admin sets or updates the order in which members will receive payouts.
- **UC-12: Confirm Payout:** An admin confirms that a payout for a session has been completed, advancing the circle.

### Monitoring & Communication
- **UC-13: View Transaction History:** Users review financial records (contributions and payouts) within their groups.
- **UC-14: Generate Reports:** Admins generate summaries for financial performance and member participation.
- **UC-15: Receive Notifications:** Users receive alerts for contribution reminders, payout confirmations, and group updates.
- **UC-16: Group Communication:** Members send and receive messages or announcements within a group chat.
