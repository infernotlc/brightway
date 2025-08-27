# Firebase Setup Guide for BrightWay

## 🔥 **Step 1: Get Firebase Configuration**

### **For Web App:**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (or create one)
3. Click **Project Settings** (gear icon)
4. Scroll down to **Your apps** section
5. Click **Add app** → **Web** (</>)
6. Register your app with a nickname (e.g., "BrightWay Web")
7. Copy the configuration object

### **For Android App:**
1. In Firebase Console → Project Settings
2. **Your apps** section
3. Click **Add app** → **Android**
4. Enter your package name: `com.example.brightway`
5. Download `google-services.json` (already in your project)

## 📝 **Step 2: Update Configuration Files**

### **Update `lib/firebase_options.dart`:**
Replace the placeholder values with your actual Firebase config:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_API_KEY',
  appId: 'YOUR_ACTUAL_APP_ID',
  messagingSenderId: 'YOUR_ACTUAL_SENDER_ID',
  projectId: 'YOUR_ACTUAL_PROJECT_ID',
  authDomain: 'YOUR_ACTUAL_AUTH_DOMAIN',
  storageBucket: 'YOUR_ACTUAL_STORAGE_BUCKET',
);
```

### **Update `web/index.html`:**
Replace the placeholder values in the script section:

```javascript
const firebaseConfig = {
  apiKey: "YOUR_ACTUAL_API_KEY",
  authDomain: "YOUR_ACTUAL_AUTH_DOMAIN",
  projectId: "YOUR_ACTUAL_PROJECT_ID",
  storageBucket: "YOUR_ACTUAL_STORAGE_BUCKET",
  messagingSenderId: "YOUR_ACTUAL_SENDER_ID",
  appId: "YOUR_ACTUAL_APP_ID"
};
```

## ⚙️ **Step 3: Enable Firebase Services**

### **Authentication:**
1. Firebase Console → **Authentication**
2. Click **Get started**
3. **Sign-in method** tab
4. Enable **Email/Password**

### **Firestore Database:**
1. Firebase Console → **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select a location close to your users

## 🔒 **Step 4: Security Rules (Optional but Recommended)**

In Firestore Database → **Rules**, add:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Admins can read all user data
    match /users/{userId} {
      allow read: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## 🚀 **Step 5: Test Your Setup**

1. Run `flutter pub get`
2. Run `flutter run -d chrome` (for web)
3. Check console for "Firebase initialized successfully"

## ❌ **Common Issues & Solutions**

### **"FirebaseOptions cannot be null" Error:**
- Make sure you've updated `firebase_options.dart` with real values
- Check that `web/index.html` has the correct config
- Verify your Firebase project is active

### **"Permission denied" Error:**
- Check Firestore security rules
- Ensure Authentication is enabled
- Verify your app is registered in Firebase

### **"Network error" Error:**
- Check your internet connection
- Verify Firebase project location
- Check if Firebase services are enabled

## 📱 **Platform-Specific Notes**

- **Web**: Requires both `firebase_options.dart` and `index.html` config
- **Android**: Only needs `google-services.json` (already configured)
- **iOS**: Would need `GoogleService-Info.plist` if you add iOS support

## 🆘 **Need Help?**

1. Check [Firebase Documentation](https://firebase.google.com/docs)
2. Verify your configuration values match exactly
3. Check browser console for detailed error messages
4. Ensure all Firebase services are enabled in your project
