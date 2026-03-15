# Database Schema Specification (DSS)
## Njangi Mobile Application

**Version:** 1.0  
**Date:** March 2026

---

## Introduction

This document defines the database schema for the Njangi Mobile Application, translating data requirements into a relational structure for PostgreSQL. It ensures data integrity, security, and scalability for the digital management of Njangi groups.

---

## Naming Conventions

- **Tables:** Plural, snake\_case (e.g., `users`, `groups`).
- **Columns:** Snake\_case (e.g., `full_name`, `created_at`).
- **Primary Keys:** `id` (UUID recommended).
- **Foreign Keys:** `table_name_singular_id` (e.g., `user_id`).
- **Timestamps:** `created_at` and `updated_at`.

---

## Core Tables

### 1. Users
Stores registered users.
- **Columns:** `id`, `full_name`, `phone_number` (Unique), `email` (Unique), `password_hash`, `profile_photo_url`, `account_status`, `last_login_at`.

### 2. Groups
Stores Njangi groups created by users.
- **Columns:** `id`, `name`, `description`, `group_image_url`, `created_by` (FK → users), `privacy` (private/public), `status` (active/archived), `invite_code`.

### 3. Group Members
Manages membership and roles within groups.
- **Columns:** `id`, `group_id` (FK → groups), `user_id` (FK → users), `role` (admin/member), `membership_status`, `joined_at`.

### 4. Group Settings
Configuration for each group.
- **Columns:** `id`, `group_id` (FK → groups), `contribution_amount`, `frequency` (weekly/monthly/etc.), `start_date`, `payout_method`, `currency`.

### 5. Circles & Sessions
Tracks payout cycles and individual sessions.
- **Circle Columns:** `id`, `group_id`, `circle_number`, `start_date`, `end_date`, `total_sessions`, `status`.
- **Session Columns:** `id`, `circle_id`, `session_number`, `session_date`, `payout_member_id` (FK → users), `expected_amount`, `collected_amount`, `status`, `payout_confirmed`.

### 6. Payout Rotations
Defines payout order within a circle.
- **Columns:** `id`, `circle_id` (FK → circles), `member_id` (FK → users), `position`.

### 7. Contributions & Payouts
Financial transaction records.
- **Contribution Columns:** `id`, `session_id`, `group_id`, `user_id`, `amount`, `payment_method` (cash/external), `contribution_status`, `payment_date`, `recorded_by`.
- **Payout Columns:** `id`, `session_id`, `group_id`, `recipient_id`, `amount`, `payout_date`, `payout_status`, `confirmed_by`.

### 8. Transaction Log
History of all financial actions.
- **Columns:** `id`, `group_id`, `session_id`, `circle_id`, `transaction_type` (contribution/payout), `user_id`, `target_user_id`, `amount`, `payment_method`, `transaction_date`.

### 9. Engagement (Notifications & Messages)
Communication and alerts.
- **Notification Columns:** `id`, `user_id`, `group_id`, `notification_type`, `title`, `message`, `read_status`.
- **Message Columns:** `id`, `group_id`, `sender_id`, `message_type` (text/announcement), `content`, `sent_at`.

---

## Integrity Constraints & Security

- **Referential Integrity:** Foreign keys must be enforced for all relationships.
- **Uniqueness:** Phone numbers, invite codes, and group membership (user-group pairs) must be unique.
- **Validation:** Only one active circle per group and one active session per circle at any given time.
- **Auditability:** Immutability of transaction logs; only admins can record financial data.
- **Password Security:** Passwords must be hashed; never stored in plain text.
- **Enums:** Use controlled values for statuses (e.g., `account_status`, `role`, `session_status`).
