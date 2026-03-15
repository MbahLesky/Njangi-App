# Project Plan: Njangi Digital Management Application
## Planning and Requirements Analysis

**Version:** 1.0  
**Date:** March 2026

---

## Project Overview

The Njangi Digital Management Application is a mobile platform designed to simplify the management of traditional rotating savings groups commonly known as *Njangi*. These groups allow members to contribute a fixed amount periodically, with the collected funds distributed to members in rotation.

The application provides a digital environment where users can create Njangi groups, manage members, track contributions, schedule payouts, and maintain transparent financial records.

---

## Problem Statement

Njangi groups are commonly managed manually through notebooks, spreadsheets, or informal communication methods. This introduces several challenges:
- Difficulty tracking contributions over long periods.
- Calculation errors in contributions and payouts.
- Lack of transparency among group members.
- Disputes regarding payments or payout order.
- Loss or mismanagement of financial records.

---

## Project Objectives

### Primary Objective
To design and develop a mobile application that enables users to manage Njangi groups digitally while ensuring transparency, accountability, and efficient financial tracking.

### Specific Objectives
- Allow users to create and manage Njangi groups from a mobile application.
- Enable administrators to manage group members and assign administrative roles.
- Provide tools for setting contribution amounts and schedules.
- Track member contributions and payout rotations.
- Maintain accurate records of transactions within each group.
- Facilitate communication among group members through in-app messaging.

---

## Project Scope

### In Scope (Version 1 - MVP)
- **User Management:** Registration, login, and profile management.
- **Group Management:** Create groups, manage members, and assign admins.
- **Contribution Management:** Set amounts, schedule due dates, and record payments (including cash).
- **Payout Management:** Manage rotation order and track completion.
- **Circle & Session Management:** Track payout cycles and individual sessions.
- **Reporting:** Contribution/payout history and transparent logs.
- **Notifications:** Reminders and alerts.
- **Communication:** Group chat and announcements.

### Out of Scope (Initial Version)
- Mobile money integration.
- Direct bank integration.
- Automated payment processing.

---

## Feasibility Analysis

### Technical Feasibility
The system will be implemented using:
- **Mobile:** Flutter (Cross-platform)
- **Backend:** Node.js / Express
- **Database:** PostgreSQL
- **Authentication:** JWT-based

### Operational Feasibility
The application will be designed with an intuitive interaction model (similar to messaging apps) to ensure easy adoption by users familiar with traditional Njangi systems.

---

## Project Deliverables
- Planning Documentation
- Software Requirement Specification (SRS)
- System Architecture Design
- Database Design Document
- UI/UX Wireframes
- Mobile Application & Backend API
- User Guide
