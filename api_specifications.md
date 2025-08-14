# Health Activity Visualization API Specifications

## Overview

This document defines the REST API specifications for the Health Activity Visualization app backend. The API provides endpoints for user management, health data synchronization, subscription management, and social features.

## Base URL

```
Production: https://api.healthviz.app/v1
Development: https://dev-api.healthviz.app/v1
Local: http://localhost:8080/api/v1
```

## Authentication

All API endpoints (except registration and login) require authentication using Bearer tokens.

```
Authorization: Bearer <access_token>
```

## Common Response Format

### Success Response
```json
{
  "success": true,
  "data": {
    // Response data
  },
  "message": "Operation completed successfully"
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": "Additional error details"
  }
}
```

## User Management API

### Register User
```
POST /users/register
```

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "password": "securePassword123",
  "dailyStepGoal": 8000,
  "timezone": "UTC",
  "language": "en"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_123",
      "name": "John Doe",
      "email": "john.doe@example.com",
      "dailyStepGoal": 8000,
      "timezone": "UTC",
      "language": "en",
      "privacyLevel": "friends",
      "notificationsEnabled": true,
      "createdAt": "2024-01-15T10:30:00Z",
      "updatedAt": "2024-01-15T10:30:00Z"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expiresIn": 3600
    }
  }
}
```

### Login User
```
POST /users/login
```

**Request Body:**
```json
{
  "email": "john.doe@example.com",
  "password": "securePassword123"
}
```

**Response:** Same as register response

### Get User Profile
```
GET /users/profile
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "user_123",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "dailyStepGoal": 8000,
    "avatarUrl": "https://example.com/avatar.jpg",
    "age": 30,
    "height": 175.0,
    "weight": 70.0,
    "timezone": "UTC",
    "language": "en",
    "privacyLevel": "friends",
    "notificationsEnabled": true,
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T10:30:00Z"
  }
}
```

### Update User Profile
```
PUT /users/profile
```

**Request Body:**
```json
{
  "name": "John Smith",
  "dailyStepGoal": 10000,
  "age": 31,
  "height": 175.0,
  "weight": 68.0,
  "privacyLevel": "public",
  "notificationsEnabled": false
}
```

### Delete User Account
```
DELETE /users/account
```

## Health Data API

### Sync Health Data
```
POST /health/sync
```

**Request Body:**
```json
{
  "healthData": [
    {
      "date": "2024-01-15",
      "stepCount": 8500,
      "distance": 6.8,
      "caloriesBurned": 340,
      "activeTime": 85,
      "activityLevel": 3
    }
  ]
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "syncedCount": 1,
    "conflicts": [],
    "lastSyncTime": "2024-01-15T15:30:00Z"
  }
}
```

### Get Health Data
```
GET /health/data?start_date=2024-01-01&end_date=2024-01-31
```

**Query Parameters:**
- `start_date` (required): Start date in YYYY-MM-DD format
- `end_date` (required): End date in YYYY-MM-DD format

**Response:**
```json
{
  "success": true,
  "data": {
    "healthData": [
      {
        "date": "2024-01-15",
        "stepCount": 8500,
        "distance": 6.8,
        "caloriesBurned": 340,
        "activeTime": 85,
        "activityLevel": 3,
        "syncStatus": "synced",
        "createdAt": "2024-01-15T10:30:00Z",
        "updatedAt": "2024-01-15T15:30:00Z"
      }
    ],
    "totalRecords": 31,
    "dateRange": {
      "startDate": "2024-01-01",
      "endDate": "2024-01-31"
    }
  }
}
```

### Get Health Statistics
```
GET /health/statistics?period=week|month|year
```

**Query Parameters:**
- `period` (required): Statistics period (week, month, year)

**Response:**
```json
{
  "success": true,
  "data": {
    "period": "month",
    "totalDays": 31,
    "averageSteps": 7850.5,
    "maxSteps": 12500,
    "totalSteps": 243365,
    "averageDistance": 6.28,
    "totalDistance": 194.68,
    "averageCalories": 314.2,
    "totalCalories": 9740,
    "goalAchievementRate": 0.74,
    "streakDays": 5
  }
}
```

### Update Step Goal
```
PUT /health/goals
```

**Request Body:**
```json
{
  "dailyStepGoal": 10000
}
```

## Social Features API

### Send Friend Invitation
```
POST /social/friends/invite
```

**Request Body:**
```json
{
  "email": "friend@example.com",
  "message": "Let's be fitness buddies!"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "invitationId": "invite_123",
    "inviteCode": "ABC12345",
    "expiryDate": "2024-01-22T10:30:00Z"
  }
}
```

### Get Friends List
```
GET /social/friends
```

**Response:**
```json
{
  "success": true,
  "data": {
    "friends": [
      {
        "id": "user_456",
        "name": "Alice Johnson",
        "avatarUrl": "https://example.com/alice.jpg",
        "privacyLevel": "friends",
        "friendshipDate": "2024-01-10T10:30:00Z",
        "lastActivity": "2024-01-15T08:00:00Z"
      }
    ],
    "totalCount": 5,
    "maxFriendsAllowed": 50
  }
}
```

### Remove Friend
```
DELETE /social/friends/{friend_id}
```

### Get Weekly Ranking
```
GET /social/ranking?period=week|month
```

**Query Parameters:**
- `period` (optional): Ranking period (default: week)

**Response:**
```json
{
  "success": true,
  "data": {
    "period": "week",
    "ranking": [
      {
        "rank": 1,
        "user": {
          "id": "user_456",
          "name": "Alice Johnson",
          "avatarUrl": "https://example.com/alice.jpg"
        },
        "totalSteps": 65000,
        "averageSteps": 9286,
        "goalAchievementRate": 0.86
      }
    ],
    "currentUserRank": 3,
    "totalParticipants": 10
  }
}
```

### Update Privacy Settings
```
PUT /social/privacy
```

**Request Body:**
```json
{
  "privacyLevel": "public",
  "shareStepCount": true,
  "shareDistance": true,
  "shareCalories": false,
  "allowFriendRequests": true,
  "showInRanking": true
}
```

## Subscription API

### Verify Subscription
```
POST /subscription/verify
```

**Request Body:**
```json
{
  "platform": "ios|android",
  "transactionId": "1000000123456789",
  "productId": "premium_monthly",
  "purchaseToken": "purchase_token_here"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "valid": true,
    "subscription": {
      "type": "premium",
      "isActive": true,
      "availableFeatures": [
        "detailed_analytics",
        "data_export",
        "ad_free",
        "unlimited_friends",
        "custom_goals"
      ],
      "expiryDate": "2024-02-15T10:30:00Z",
      "purchaseDate": "2024-01-15T10:30:00Z",
      "autoRenew": true,
      "originalTransactionId": "1000000123456789",
      "productId": "premium_monthly"
    }
  }
}
```

### Get Subscription Status
```
GET /subscription/status
```

**Response:**
```json
{
  "success": true,
  "data": {
    "type": "premium",
    "isActive": true,
    "availableFeatures": [
      "detailed_analytics",
      "data_export",
      "ad_free",
      "unlimited_friends",
      "custom_goals"
    ],
    "expiryDate": "2024-02-15T10:30:00Z",
    "daysRemaining": 15,
    "autoRenew": true
  }
}
```

### Subscription Webhook (Server-to-Server)
```
POST /subscription/webhook
```

**Request Body:**
```json
{
  "eventType": "subscription_renewed|subscription_expired|subscription_cancelled",
  "userId": "user_123",
  "transactionId": "1000000123456789",
  "productId": "premium_monthly",
  "eventDate": "2024-01-15T10:30:00Z",
  "subscriptionData": {
    "expiryDate": "2024-02-15T10:30:00Z",
    "autoRenew": true
  }
}
```

## Error Codes

### Authentication Errors
- `AUTH_001`: Invalid credentials
- `AUTH_002`: Token expired
- `AUTH_003`: Token invalid
- `AUTH_004`: User not found

### Validation Errors
- `VAL_001`: Missing required field
- `VAL_002`: Invalid field format
- `VAL_003`: Field value out of range

### Health Data Errors
- `HEALTH_001`: Health data sync failed
- `HEALTH_002`: Invalid date range
- `HEALTH_003`: Data conflict detected

### Social Errors
- `SOCIAL_001`: Friend not found
- `SOCIAL_002`: Friend limit exceeded
- `SOCIAL_003`: Privacy settings conflict

### Subscription Errors
- `SUB_001`: Invalid subscription
- `SUB_002`: Subscription expired
- `SUB_003`: Purchase verification failed

## Rate Limiting

- Authentication endpoints: 5 requests per minute
- Health data sync: 10 requests per minute
- Other endpoints: 60 requests per minute

## Data Retention

- Health data: Retained for 2 years after account deletion
- User data: Deleted within 30 days of account deletion request
- Subscription data: Retained for 7 years for compliance

## Security

- All endpoints use HTTPS
- Passwords are hashed using bcrypt
- Health data is encrypted at rest
- API keys are rotated every 90 days
- Rate limiting and DDoS protection enabled

## Versioning

API versions are specified in the URL path. Current version is v1.
Breaking changes will result in a new version (v2, v3, etc.).

## Support

For API support, contact: api-support@healthviz.app