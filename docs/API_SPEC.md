## API Specification - MkulimaConnect

All endpoints use Firebase REST API + Cloud Functions

### Base URL
```
https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/default/documents
```

---

## Authentication Endpoints

### 1. Send OTP
**POST** `/auth/sendOtp`

**Request:**
```json
{
  "phoneNumber": "+255654123456"
}
```

**Response:**
```json
{
  "success": true,
  "message": "OTP sent to phone",
  "sessionId": "session_xyz123"
}
```

---

### 2. Verify OTP & Create/Login User
**POST** `/auth/verifyOtp`

**Request:**
```json
{
  "phoneNumber": "+255654123456",
  "otp": "123456",
  "sessionId": "session_xyz123"
}
```

**Response:**
```json
{
  "success": true,
  "userId": "uuid-abc123",
  "idToken": "firebase_token_here",
  "isNewUser": true
}
```

---

## User Endpoints

### 3. Create User Profile (Farmer/Buyer)
**POST** `/users`

**Request:**
```json
{
  "userId": "uuid-abc123",
  "userType": "farmer",
  "name": "John Farmers",
  "phone": "+255654123456",
  "region": "Dar es Salaam",
  "district": "Ilala",
  "location": {
    "latitude": -6.8000,
    "longitude": 39.2833,
    "address": "Magomeni, Dar es Salaam"
  },
  "farmName": "John's Farm",
  "cropSpecialties": ["maize", "beans", "rice"],
  "preferredContact": "whatsapp"
}
```

**Response:**
```json
{
  "success": true,
  "userId": "uuid-abc123",
  "createdAt": "2024-06-07T10:30:00Z"
}
```

---

### 4. Get User Profile
**GET** `/users/{userId}`

**Response:**
```json
{
  "userId": "uuid-abc123",
  "userType": "farmer",
  "name": "John Farmers",
  "phone": "+255654123456",
  "region": "Dar es Salaam",
  "district": "Ilala",
  "profileImage": "https://storage.googleapis.com/...",
  "isVerified": true,
  "createdAt": "2024-06-07T10:30:00Z",
  "lastLogin": "2024-06-07T15:45:00Z"
}
```

---

### 5. Update User Profile
**PATCH** `/users/{userId}`

**Request:**
```json
{
  "name": "John Updated Farmers",
  "cropSpecialties": ["maize", "beans", "rice", "tomatoes"],
  "preferredContact": "both"
}
```

**Response:**
```json
{
  "success": true,
  "updatedAt": "2024-06-07T16:00:00Z"
}
```

---

## Produce Listings Endpoints

### 6. Create Produce Listing
**POST** `/produce_listings`

**Request:**
```json
{
  "farmerId": "uuid-abc123",
  "cropName": "Maize",
  "description": "Fresh yellow maize, just harvested",
  "quantity": 500,
  "unit": "kg",
  "price": 500000,
  "pricePerUnit": "1000 TSH per kg",
  "location": {
    "latitude": -6.8000,
    "longitude": 39.2833,
    "address": "Magomeni, Dar es Salaam",
    "district": "Ilala",
    "region": "Dar es Salaam"
  },
  "harvestDate": "2024-06-07",
  "status": "available",
  "quality": "premium",
  "certifications": ["organic"],
  "images": ["https://storage.googleapis.com/...image1.jpg"]
}
```

**Response:**
```json
{
  "success": true,
  "listingId": "uuid-listing123",
  "createdAt": "2024-06-07T11:00:00Z",
  "status": "available"
}
```

---

### 7. Get Listing Details
**GET** `/produce_listings/{listingId}`

**Response:**
```json
{
  "listingId": "uuid-listing123",
  "farmerId": "uuid-abc123",
  "farmer": {
    "name": "John Farmers",
    "phone": "+255654123456",
    "region": "Dar es Salaam",
    "profileImage": "https://..."
  },
  "cropName": "Maize",
  "description": "Fresh yellow maize, just harvested",
  "quantity": 500,
  "unit": "kg",
  "price": 500000,
  "pricePerUnit": "1000 TSH per kg",
  "location": { ... },
  "harvestDate": "2024-06-07",
  "status": "available",
  "quality": "premium",
  "images": ["https://...", "https://..."],
  "views": 45,
  "contacted": 12,
  "createdAt": "2024-06-07T11:00:00Z",
  "updatedAt": "2024-06-07T11:00:00Z"
}
```

---

### 8. Search/Filter Listings
**GET** `/produce_listings/search?cropName=maize&region=dar&status=available&limit=20`

**Response:**
```json
{
  "success": true,
  "listings": [
    {
      "listingId": "uuid-listing123",
      "cropName": "Maize",
      "quantity": 500,
      "unit": "kg",
      "price": 500000,
      "district": "Ilala",
      "region": "Dar es Salaam",
      "farmerName": "John Farmers",
      "createdAt": "2024-06-07T11:00:00Z",
      "images": ["https://..."]
    }
  ],
  "total": 45,
  "page": 1,
  "pageSize": 20
}
```

**Query Parameters:**
- `cropName` (optional): Filter by crop
- `region` (optional): Filter by region
- `district` (optional): Filter by district
- `quantity_min` (optional): Minimum quantity
- `quantity_max` (optional): Maximum quantity
- `status` (optional): "available", "sold", "pending"
- `limit` (optional, default: 20): Results per page
- `page` (optional, default: 1): Page number
- `sort` (optional): "newest", "oldest", "closest"

---

### 9. Update Listing
**PATCH** `/produce_listings/{listingId}`

**Request:**
```json
{
  "quantity": 300,
  "status": "available",
  "price": 450000,
  "pricePerUnit": "1500 TSH per kg"
}
```

**Response:**
```json
{
  "success": true,
  "updatedAt": "2024-06-07T16:00:00Z"
}
```

---

### 10. Mark Listing as Sold
**PATCH** `/produce_listings/{listingId}/sold`

**Response:**
```json
{
  "success": true,
  "status": "sold",
  "updatedAt": "2024-06-07T16:30:00Z"
}
```

---

### 11. Delete Listing
**DELETE** `/produce_listings/{listingId}`

**Response:**
```json
{
  "success": true,
  "message": "Listing deleted"
}
```

---

## Contact/Inquiry Endpoints

### 12. Initiate Contact (Buyer → Farmer)
**POST** `/contacts`

**Request:**
```json
{
  "buyerId": "uuid-buyer456",
  "farmerId": "uuid-abc123",
  "listingId": "uuid-listing123",
  "contactType": "whatsapp",
  "buyerName": "Jane Buyer",
  "buyerPhone": "+255654654654",
  "quantity_interested": 100,
  "message": "Are you available for delivery to Mbeya?"
}
```

**Response:**
```json
{
  "success": true,
  "contactId": "uuid-contact789",
  "createdAt": "2024-06-07T12:00:00Z",
  "farmerNotificationSent": true
}
```

---

### 13. Get Farmer's Contact Inquiries
**GET** `/contacts?farmerId={farmerId}&status=initiated`

**Response:**
```json
{
  "success": true,
  "contacts": [
    {
      "contactId": "uuid-contact789",
      "buyerId": "uuid-buyer456",
      "buyerName": "Jane Buyer",
      "buyerPhone": "+255654654654",
      "listingId": "uuid-listing123",
      "cropName": "Maize",
      "quantity_interested": 100,
      "contactType": "whatsapp",
      "message": "Are you available for delivery to Mbeya?",
      "status": "initiated",
      "createdAt": "2024-06-07T12:00:00Z"
    }
  ]
}
```

---

### 14. Update Contact Status
**PATCH** `/contacts/{contactId}`

**Request:**
```json
{
  "status": "completed",
  "notes": "Successfully completed the transaction"
}
```

**Response:**
```json
{
  "success": true,
  "updatedAt": "2024-06-07T16:45:00Z"
}
```

---

## Analytics Endpoints

### 15. Get Dashboard Analytics
**GET** `/analytics/dashboard`

**Response:**
```json
{
  "success": true,
  "metrics": {
    "totalFarmers": 234,
    "totalBuyers": 567,
    "activeFarmers": 189,
    "activeBuyers": 445,
    "totalListings": 890,
    "activeListings": 712,
    "soldListings": 125,
    "totalContacts": 432,
    "conversionRate": 28.9,
    "topCrops": [
      {"crop": "Maize", "count": 234},
      {"crop": "Beans", "count": 156},
      {"crop": "Rice", "count": 145}
    ],
    "listingsByRegion": {
      "Dar es Salaam": 234,
      "Morogoro": 156,
      "Iringa": 145
    }
  }
}
```

---

### 16. Get Monthly Analytics
**GET** `/analytics/month/{month}` (e.g., `/analytics/month/2024-06`)

**Response:**
```json
{
  "month": "2024-06",
  "totalFarmers": 234,
  "newFarmers": 45,
  "totalListings": 890,
  "newListings": 123,
  "soldListings": 45,
  "conversionRate": 28.9,
  "topCrops": [...],
  "regionsData": {...},
  "updatedAt": "2024-06-30T23:59:59Z"
}
```

---

## Admin Endpoints

### 17. Block/Unblock User
**PATCH** `/admin/users/{userId}/block`

**Request:**
```json
{
  "isBlocked": true,
  "reason": "Multiple fake listings"
}
```

**Response:**
```json
{
  "success": true,
  "userId": "uuid-abc123",
  "isBlocked": true,
  "logId": "uuid-log999"
}
```

---

### 18. Remove Listing
**DELETE** `/admin/listings/{listingId}`

**Request:**
```json
{
  "reason": "Fake listing - product doesn't exist",
  "notes": "Reported by 3 users"
}
```

**Response:**
```json
{
  "success": true,
  "listingId": "uuid-listing123",
  "removedAt": "2024-06-07T17:00:00Z",
  "logId": "uuid-log999"
}
```

---

## Error Responses

All errors follow this format:

```json
{
  "success": false,
  "error": {
    "code": "INVALID_REQUEST",
    "message": "Phone number is required",
    "details": {}
  }
}
```

### Common Error Codes:
- `INVALID_REQUEST`: Missing or invalid parameters
- `UNAUTHORIZED`: Missing or invalid auth token
- `FORBIDDEN`: User lacks permission
- `NOT_FOUND`: Resource not found
- `CONFLICT`: Resource already exists
- `INTERNAL_ERROR`: Server error

---

## Rate Limiting

- **Unauthenticated**: 30 requests per minute per IP
- **Authenticated**: 100 requests per minute per user
- **Admin**: 500 requests per minute

---

## Pagination

Use `limit` and `page` parameters:
```
GET /produce_listings/search?limit=20&page=1
```

Response includes:
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "total": 234,
    "hasNext": true,
    "hasPrev": false
  }
}
```

