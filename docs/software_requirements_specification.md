# Software Requirements Specification (SRS)
## Njangi Digital Management Application

**Version:** 1.0  
**Date:** March 2026

---

## Introduction

This document defines the software requirements for the **Njangi Digital Management Application**, focusing on the MVP scope for digital Njangi group management.

---

## Overall Description

### Product Perspective
The Njangi Application is a **mobile-only system**. Any registered user can create a group and automatically become that group’s admin. Users can belong to multiple groups and can be an admin in one while being a normal member in another.

### Product Goals
- Improve transparency in Njangi operations.
- Reduce manual errors in tracking contributions and payouts.
- Simplify member and rotation management.
- Provide clear financial records and reports.
- Support communication within groups.

---

## System Users and Roles

### Registered User
- Create an account, log in, and update profile.
- Create or join Njangi groups.

### Group Admin
- Edit group settings, manage members, and assign roles.
- Set contribution amounts, frequencies, and payout rotations.
- Start circles, manage sessions, and record contributions (including physical).
- Generate and view reports and send announcements.

### Group Member
- View group details, contribution schedules, and payout status.
- View personal transactions and receive notifications.
- Participate in group chat.

---

## Functional Requirements

### Authentication and Profile
- **Registration:** New users can register with name, phone, email/username, and password.
- **Login:** Secure login using phone/email and password.
- **Profile:** Users can view and update their profile details and photo.

### Group Management
- **Creation:** Users can create groups and automatically become the first admin.
- **Editing:** Admins can update group names, descriptions, images, and rules.
- **Membership:** Admins can approve, invite, or remove members and assign admin roles.

### Contribution & Payout Management
- **Settings:** Admins set contribution amounts and flexible schedules (daily, weekly, monthly, etc.).
- **Recording:** Admins record contributions (including physical/cash payments).
- **Rotation:** Admins define the payout sequence for each circle.
- **Confirmation:** Admins confirm when a payout for a session is complete, advancing the circle.

### Circle & Session Management
- **Cycles:** Admins start a new circle, which automatically generates sessions based on the group schedule.
- **Progress:** The system tracks circle progress, session states (pending, active, completed), and next payouts.

### Reporting & Transactions
- **History:** Transparent transaction history for all contributions and payouts.
- **Reports:** Summaries for group financial activity, member contributions, and session status.

### Communication & Notifications
- **Chat:** Real-time group chat and admin announcements.
- **Notifications:** Reminders for contributions, payout alerts, and payment confirmations.

---

## Non-Functional Requirements

### Usability
The app must be easy to use for non-technical users with simple, mobile-friendly navigation.

### Performance
Main screens should load quickly, and chat/notifications should update with minimal delay.

### Security
- Secure authentication (JWT) and hashed passwords.
- Role-based access control (RBAC) within groups.
- Protection of financial records and encrypted communication.

### Reliability
- Contribution and payout records must be preserved accurately.
- Financial transactions should follow strict validation and logging.

### Maintainability
The system should be modular to allow for future additions like back-payments and mobile money integration.
