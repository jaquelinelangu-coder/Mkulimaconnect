# MkulimaConnect - Deployment Guide

## Prerequisites

- Flutter SDK 3.0+
- Firebase Account
- Android Studio or Xcode
- GitHub account for version control

## Firebase Setup

### 1. Create Firebase Project

```bash
# Using Firebase CLI
firebase init

# Select these features:
# - Firestore Database
# - Firebase Storage
# - Firebase Authentication
# - Cloud Functions
# - Firebase Hosting (optional for admin dashboard)
```

### 2. Configure Firebase Credentials

Update `lib/firebase_options.dart` with your Firebase project credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  databaseURL: 'https://YOUR_PROJECT.firebaseio.com',
  storageBucket: 'YOUR_PROJECT.appspot.com',
);
```

### 3. Set Firestore Rules

Deploy the security rules from `firebase/firestore_rules.json`:

```bash
firebase deploy --only firestore:rules
```

## Mobile App Deployment

### iOS

```bash
# Install pods
cd ios
pod install
cd ..

# Build for iOS
flutter build ios

# Deploy to TestFlight
open ios/Runner.xcworkspace
```

### Android

```bash
# Create signing key
keytool -genkey -v -keystore ~/mkulima-connect-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias mkulima-key

# Create signing configuration
# android/key.properties

# Build signed APK
flutter build apk --release

# Build app bundle (for Google Play)
flutter build appbundle --release
```

## Admin Dashboard Deployment

### Firebase Hosting

```bash
# Build web dashboard
cd admin
npm run build

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## Testing Checklist

### Authentication
- [ ] Phone OTP flow works
- [ ] User registration completes
- [ ] Profile creation saves to Firestore
- [ ] Login persists across sessions

### Farmer Features
- [ ] Can create produce listing
- [ ] Images upload to Firebase Storage
- [ ] Location selection works (GPS and manual)
- [ ] Can view own listings
- [ ] Can edit and delete listings
- [ ] Can mark listing as sold

### Buyer Features
- [ ] Can search by crop name
- [ ] Can filter by region
- [ ] Can view nearby listings
- [ ] Can contact farmer via Call/WhatsApp
- [ ] In-app messaging works
- [ ] Can see farmer details

### Admin Features
- [ ] Can view user statistics
- [ ] Can block/unblock users
- [ ] Can remove listings
- [ ] Analytics page displays correctly

### Performance
- [ ] App loads within 2 seconds
- [ ] Listings load with pagination
- [ ] Search filters respond quickly (<1s)
- [ ] No memory leaks during extended use

## Monitoring & Analytics

### Firebase Logging

Enable Firebase Analytics in `main.dart`:

```dart
FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
```

### Error Tracking

Errors are automatically captured via:
- `firebase_crashlytics` package
- Firestore error logs
- Cloud Functions error logs

## Post-Launch Tasks

1. **Set up Firestore indexes** for popular queries
2. **Configure Cloud Functions** for push notifications
3. **Enable rate limiting** to prevent abuse
4. **Set up monitoring alerts** in Firebase Console
5. **Create admin accounts** for moderators
6. **Set up analytics dashboard** to track KPIs

## Scaling Considerations

### Database Optimization
- Implement collection sharding for high-volume queries
- Archive old listings (>60 days) to separate collection
- Use caching strategy for popular crops

### Storage
- Compress images before upload
- Implement cleanup for deleted listings
- Set lifecycle policies for old data

### Cloud Functions
- Use background jobs for analytics aggregation
- Implement message queues for push notifications
- Auto-scale based on traffic

## Rollback Procedure

If issues arise:

```bash
# Rollback Firestore rules
firebase rollback

# Rollback Firebase functions
firebase functions:delete functionName

# Re-deploy working version
git checkout [working-commit]
firebase deploy
```

## Support & Troubleshooting

### Common Issues

**Issue**: Firestore permission denied
- **Solution**: Check Firestore security rules match user role

**Issue**: Images not uploading
- **Solution**: Verify Storage bucket rules and user permissions

**Issue**: Push notifications not arriving
- **Solution**: Check FCM tokens and topic subscriptions

---

For detailed logs, check Firebase Console → Cloud Functions → Logs
