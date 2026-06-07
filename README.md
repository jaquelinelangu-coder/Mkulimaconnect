# MkulimaConnect - Agricultural Marketplace MVP

A Flutter-based mobile marketplace connecting farmers and buyers in East Africa.

## 🎯 Project Vision

Enable farmers to list their produce and allow buyers (traders, wholesalers, restaurants, processors) to discover and contact them directly.

## 📋 MVP Scope

### Core Features
- **Farmer Registration** - Phone number, location, district
- **Produce Listings** - Crop type, quantity, harvest date, price, location
- **Buyer Search** - Filter by crop, region, quantity
- **Direct Contact** - Call or WhatsApp farmer directly
- **Admin Dashboard** - Manage users, listings, view analytics

### Out of Scope (Phase 2+)
- Payments integration
- Logistics/delivery
- AI forecasting
- Smart contracts
- Ratings/reviews

## 🛠 Tech Stack

| Component | Technology |
|-----------|-----------|
| Mobile App | Flutter |
| Backend | Firebase |
| Database | Firestore |
| Authentication | Phone Number OTP |
| Notifications | Firebase Cloud Messaging |
| Storage | Firebase Storage |

## 📁 Project Structure

```
MkulimaConnect/
├── mobile/                 # Flutter app
│   ├── lib/
│   │   ├── models/        # Data models
│   │   ├── screens/       # UI screens
│   │   ├── services/      # Firebase services
│   │   ├── widgets/       # Reusable components
│   │   └── main.dart
│   ├── pubspec.yaml
│   └── README.md
├── firebase/              # Firebase configuration
│   ├── firestore_rules.json
│   ├── storage_rules.json
│   └── README.md
├── docs/                  # Documentation
│   ├── API_SPEC.md
│   ├── DATABASE_SCHEMA.md
│   ├── USER_FLOWS.md
│   └── DEPLOYMENT.md
├── admin/                 # Admin dashboard (web)
│   ├── src/
│   └── README.md
└── README.md
```

## 📅 5-Week Timeline

- **Week 1**: UI Design & Database Setup
- **Week 2**: Authentication & Farmer Registration
- **Week 3**: Produce Listing Functionality
- **Week 4**: Search & Filtering
- **Week 5**: Buyer Contact Features & Deployment

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Firebase account
- Dart 3.0+

### Installation

```bash
# Clone the repository
git clone https://github.com/jaquelinelangu-coder/MkulimaConnect.git
cd MkulimaConnect

# Navigate to mobile app
cd mobile

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📊 Success Metrics

- Number of registered farmers
- Number of active listings
- Number of buyer-farmer contacts initiated
- % of produce sold through platform

## 📝 Database Schema

See `docs/DATABASE_SCHEMA.md` for detailed Firestore structure.

## 🔒 Security

- Phone number OTP authentication
- Firestore security rules
- User role-based access (Farmer/Buyer/Admin)

## 📞 Support

For questions or issues, please open a GitHub issue.

## 📄 License

MIT License - see LICENSE file for details.
