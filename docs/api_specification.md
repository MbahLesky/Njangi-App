# API Specification Document (ASD)
## Njangi Mobile Application

**Version:** 1.0  
**Date:** March 2026

---

## Introduction

This document defines the RESTful API for the Njangi Mobile Application. It specifies the endpoints, request/response structures, and authentication requirements for the MVP.

---

## API Overview

- **Architecture:** RESTful API
- **Data Format:** JSON
- **Base URL:** `/api/v1`
- **Authentication:** JWT (Access Token + Refresh Token)
- **Authorization:** Role-based (Admin vs. Member)

---

## Authentication Endpoints

### Register User
`POST /auth/register`
- **Request:** `fullName`, `phoneNumber`, `email`, `password`
- **Response:** User object + `accessToken` + `refreshToken`

### Login User
`POST /auth/login`
- **Request:** `identifier` (phone/email), `password`
- **Response:** User object + tokens

---

## Group & Member Endpoints

### Groups
- `POST /groups`: Create a new Njangi group.
- `GET /groups`: List all groups the user belongs to.
- `GET /groups/:groupId`: Fetch detailed group information.
- `PUT /groups/:groupId`: Update group settings (Admin only).

### Members
- `POST /groups/join`: Join a group via invite code.
- `GET /groups/:groupId/members`: List all group members.
- `PATCH /groups/:groupId/members/:memberId/role`: Update member role (Admin only).
- `DELETE /groups/:groupId/members/:memberId`: Remove a member (Admin only).

---

## Njangi Engine Endpoints

### Circles & Sessions
- `POST /groups/:groupId/circles`: Start a new payout circle (Admin only).
- `GET /groups/:groupId/circles`: List all circles in a group.
- `GET /circles/:circleId/sessions`: List all sessions in a circle.
- `GET /sessions/:sessionId`: Fetch specific session details.

### Payout Rotation
- `POST /circles/:circleId/payout-rotation`: Set member payout order (Admin only).
- `GET /circles/:circleId/payout-rotation`: View rotation order.

---

## Financial Endpoints

### Contributions
- `POST /sessions/:sessionId/contributions`: Record a payment (Admin only).
- `POST /sessions/:sessionId/contributions/physical`: Record a cash payment (Admin only).
- `GET /sessions/:sessionId/contributions`: List all contributions for a session.

### Payouts
- `POST /sessions/:sessionId/payout`: Confirm fund distribution (Admin only).
- `GET /sessions/:sessionId/payout`: View payout record for a session.

### Transactions
- `GET /groups/:groupId/transactions`: Filterable history of all group transactions.
- `GET /users/me/transactions`: Personal financial history.

---

## Engagement Endpoints

### Notifications
- `GET /notifications`: Fetch user notifications.
- `PATCH /notifications/:notificationId/read`: Mark as read.

### Chat & Announcements
- `GET /groups/:groupId/messages`: Fetch chat history.
- `POST /groups/:groupId/messages`: Send a message.
- `POST /groups/:groupId/announcements`: Post an admin announcement.
