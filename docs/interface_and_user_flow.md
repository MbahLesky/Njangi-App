# Interface Requirements and User Flow
## Njangi Mobile Application

**Version:** 1.0  
**Date:** March 2026

---

## Introduction

This document defines the interface requirements and user flows for the Njangi Mobile Application. It describes how users interact with the system and the navigation flow between screens to ensure a consistent and intuitive experience.

---

## Interface Design Principles

- **Simplicity:** Easy to use for users with varying levels of digital literacy.
- **Transparency:** Clear visibility of contributions, payouts, and group progress.
- **Accessibility:** Important information is accessible with minimal navigation.
- **Consistency:** Unified design patterns and layouts across all screens.
- **Feedback:** Clear indicators for user actions (confirmations, loading states).

---

## Application Navigation Structure

The application uses a **Bottom Navigation** bar as the primary global navigation system with the following tabs:

1.  **Home:** User dashboard with an overview of activities.
2.  **Groups:** Central hub for group discovery and management.
3.  **Activity:** Feed of recent group actions and logs.
4.  **Notifications:** System alerts and reminders.
5.  **Profile:** Account settings and personal details.

---

## Core Interfaces

### Home Dashboard
Acts as the central landing page.
- **Greeting:** Personalized welcome.
- **Summary Cards:** Quick stats on joined groups, pending contributions, and upcoming payouts.
- **Active Status:** Current circle/session progress and next payout recipient.
- **Quick Actions:** Buttons for "Create Group", "Join Group", and "Record Contribution".

### Groups Management
- **Groups List:** Cards showing group name, image, member count, and status.
- **Create Group:** Form for name, description, amount, frequency, and start date.
- **Join Group:** Entry for invite codes or handling invite links.

### Group Details (Tabbed Interface)
- **Overview:** Summary of group rules and current status.
- **Members:** List of participants with roles (Admin/Member).
- **Sessions:** List of individual sessions and their payment/payout status.
- **Chat:** Real-time communication and announcements.
- **Reports:** Summarized financial data and participation reports.

### Financial Operations
- **Session Details:** Detailed view of a specific session's progress.
- **Contribution Recording:** Form for admins to log digital or physical payments.
- **Payout Management:** Interface to confirm payout completion and advance the rotation.

---

## User Flow Overview

1.  **Entry:** User registers or logs in and lands on the **Home Dashboard**.
2.  **Group Setup:** User creates a new group or joins an existing one via invite.
3.  **Initialization:** Admin configures settings (amount, frequency) and starts a **Circle**.
4.  **Cycle:** System generates **Sessions**; members contribute; admin records payments.
5.  **Payout:** Admin confirms payout for the current session; system advances to the next session.
6.  **Monitoring:** Users check **Activity**, **Transaction History**, and **Reports** to stay informed.
7.  **Interaction:** Members use **Group Chat** for coordination.
