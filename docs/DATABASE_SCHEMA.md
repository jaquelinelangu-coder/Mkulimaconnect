## Database Schema - Firestore

### Collections Overview

#### 1. Users Collection

**Path**: `/users/{userId}`

```javascript
{
  userId: string (UUID),
  userType: "farmer" | "buyer" | "admin",
  name: string,
  phone: string,
  email: string (optional),
  region: string,
  district: string,
  location: {
    latitude: number,
    longitude: number,
    address: string
  },
  profileImage: string (URL to Firebase Storage),
  isVerified: boolean,
  isBlocked: boolean,
  createdAt: timestamp,
  updatedAt: timestamp,
  lastLogin: timestamp,
  
  // Farmer-specific fields
  farmName: string (optional),
  farmSize: number (optional, in acres),
  cropSpecialties: array<string>,
  
  // Contact preferences
  preferredContact: "call" | "whatsapp" | "both",
  allowNotifications: boolean
}
```

---

#### 2. Produce_Listings Collection

**Path**: `/produce_listings/{listingId}`

```javascript
{
  listingId: string (UUID),
  farmerId: string (reference to users collection),
  cropName: string,
  description: string (optional),
  quantity: number,
  unit: string ("kg", "bags", "tons", "liters", etc.),
  price: number (optional),
  pricePerUnit: string (e.g., "1000 TSH per kg"),
  location: {
    latitude: number,
    longitude: number,
    address: string,
    district: string,
    region: string
  },
  harvestDate: date,
  expectedHarvestDate: date (if not yet harvested),
  status: "available" | "sold" | "pending" | "expired",
  images: array<string> (URLs to Firebase Storage),
  
  // Quality information
  quality: string (optional, "premium", "standard", "bulk"),
  certifications: array<string> (optional, "organic", etc.),
  
  // Engagement tracking
  views: number,
  contacted: number,
  
  createdAt: timestamp,
  updatedAt: timestamp,
  expiresAt: timestamp (auto-archive after 30 days if unsold)
}
```

---

#### 3. Contacts Collection

**Path**: `/contacts/{contactId}`

Tracks buyer-farmer interactions

```javascript
{
  contactId: string (UUID),
  buyerId: string (reference to users),
  farmerId: string (reference to users),
  listingId: string (reference to produce_listings),
  
  contactType: "call" | "whatsapp" | "direct_message",
  
  // Contact details
  buyerName: string,
  buyerPhone: string,
  quantity_interested: number,
  message: string (optional),
  
  status: "initiated" | "responded" | "completed" | "no_response",
  
  createdAt: timestamp,
  respondedAt: timestamp (optional),
  completedAt: timestamp (optional),
  
  // Follow-up
  followUp: boolean,
  notes: string (optional, internal notes)
}
```

---

#### 4. Admin_Logs Collection

**Path**: `/admin_logs/{logId}`

Track admin actions for compliance

```javascript
{
  logId: string (UUID),
  adminId: string (reference to users),
  action: string ("user_approved", "user_blocked", "listing_removed", etc.),
  targetUserId: string (optional),
  targetListingId: string (optional),
  reason: string,
  
  createdAt: timestamp,
  details: object (any additional context)
}
```

---

#### 5. Analytics Collection

**Path**: `/analytics/{month}` (e.g., "2024-06")

Pre-computed analytics snapshots

```javascript
{
  month: string ("YYYY-MM"),
  
  // User metrics
  totalFarmers: number,
  totalBuyers: number,
  newFarmers: number,
  newBuyers: number,
  activeFarmers: number,
  activeBuyers: number,
  
  // Listing metrics
  totalListings: number,
  activeListings: number,
  soldListings: number,
  
  // Engagement metrics
  totalContacts: number,
  contactsInitiated: number,
  contactsCompleted: number,
  
  // Popular crops
  topCrops: array<{crop: string, count: number}>,
  
  // Regional data
  listingsByRegion: object,
  farmersByRegion: object,
  
  updatedAt: timestamp
}
```

---

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection - each user can only read/write their own document
    match /users/{userId} {
      allow read: if request.auth.uid == userId || 
                     request.auth.customClaims.role == 'admin';
      allow write: if request.auth.uid == userId;
    }
    
    // Produce listings - public read, farmers write their own
    match /produce_listings/{listingId} {
      allow read: if true; // Public listings
      allow create: if request.auth.uid != null && 
                       request.resource.data.farmerId == request.auth.uid;
      allow update, delete: if request.auth.uid == resource.data.farmerId ||
                              request.auth.customClaims.role == 'admin';
    }
    
    // Contacts - buyer creates, farmer/buyer can read their own
    match /contacts/{contactId} {
      allow create: if request.auth.uid != null;
      allow read: if request.auth.uid == resource.data.buyerId ||
                     request.auth.uid == resource.data.farmerId ||
                     request.auth.customClaims.role == 'admin';
      allow update: if request.auth.uid == resource.data.farmerId ||
                       request.auth.customClaims.role == 'admin';
    }
    
    // Admin logs - admin only
    match /admin_logs/{logId} {
      allow read: if request.auth.customClaims.role == 'admin';
      allow write: if request.auth.customClaims.role == 'admin';
    }
    
    // Analytics - public read
    match /analytics/{document=**} {
      allow read: if true;
      allow write: if request.auth.customClaims.role == 'admin';
    }
  }
}
```

---

### Indexes Required

| Collection | Fields | Type |
|-----------|--------|------|
| produce_listings | status, createdAt | Ascending |
| produce_listings | region, status | Ascending |
| produce_listings | cropName, status | Ascending |
| produce_listings | district, harvestDate | Ascending |
| contacts | farmerId, createdAt | Ascending |
| contacts | buyerId, createdAt | Ascending |
| users | region, userType | Ascending |

---

### Data Constraints & Validation

| Field | Constraint | Notes |
|-------|-----------|-------|
| phone | Required, unique | E.164 format |
| quantity | > 0 | Must be positive |
| status | Enum | Fixed set of values |
| coordinates | Valid lat/lon | -90 to 90, -180 to 180 |
| harvestDate | >= today | Cannot be in past |

