# BrightWay - Flutter App with Clean Architecture


A Flutter application built with clean architecture principles, featuring Firebase authentication and role-based navigation.

## Features

- 🔐 **Firebase Authentication**
  - User registration and login
  - Password reset functionality
  - Secure authentication state management

- 👥 **Role-Based Access Control**
  - Admin and User roles
  - Automatic role assignment (default: user)
  - Role-based navigation and UI

- 🏗️ **Clean Architecture**
  - Separation of concerns
  - BLoC pattern for state management
  - Repository pattern for data access
  - Dependency injection ready

- 🎨 **Modern UI/UX**
  - Material Design 3
  - Responsive layouts
  - Beautiful animations and transitions

## Project Structure

```
lib/
├── core/
│   ├── blocs/           # Business Logic Components
│   ├── constants/       # App constants and configuration
│   ├── models/          # Data models
│   ├── services/        # External services (Firebase, API)
│   └── utils/           # Utility functions and helpers
├── presentation/
│   ├── screens/         # UI screens
│   │   ├── auth/        # Authentication screens
│   │   ├── admin/       # Admin-specific screens
│   │   └── user/        # User-specific screens
│   └── widgets/         # Reusable UI components
└── main.dart            # App entry point
```

## Setup Instructions

### 1. Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project

### 2. Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use existing one

2. **Enable Authentication**
   - Go to Authentication > Sign-in method
   - Enable Email/Password authentication

3. **Setup Firestore Database**
   - Go to Firestore Database
   - Create database in test mode
   - Set up security rules (see below)

4. **Configure Flutter App**
   - Add your Android/iOS apps to Firebase project
   - Download and add configuration files:
     - `google-services.json` for Android (place in `android/app/`)
     - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)

### 3. Firestore Security Rules

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

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

## Usage

### Authentication Flow

1. **First Launch**: App shows login screen
2. **Registration**: New users can create accounts (default role: user)
3. **Login**: Existing users can sign in
4. **Password Reset**: Users can reset passwords via email

### Role-Based Navigation

- **Admin Users**: Navigate to admin dashboard with management features
- **Regular Users**: Navigate to user dashboard with basic features

### Making a User Admin

To assign admin role to a user, you need to manually update the user's document in Firebase:

1. **Go to Firebase Console** → Firestore Database
2. **Navigate to** `users` collection
3. **Find the user** you want to make admin
4. **Edit the document** and change the `role` field from `"user"` to `"admin"`
5. **Save the changes**

**Example document structure:**
```json
{
  "email": "admin@example.com",
  "role": "admin",
  "displayName": "Admin User",
  "createdAt": "2024-01-01T00:00:00.000Z",
  "lastLoginAt": "2024-01-01T00:00:00.000Z"
}
```

**Note:** This approach is more secure as it prevents unauthorized role changes from within the app.

## Architecture Overview

### Core Layer
- **Models**: Data structures and business entities
- **Services**: External service integrations
- **BLoCs**: Business logic and state management
- **Constants**: App-wide configuration

### Presentation Layer
- **Screens**: Full-page UI components
- **Widgets**: Reusable UI components
- **Navigation**: Role-based routing

### Key Design Patterns

- **BLoC Pattern**: For state management
- **Repository Pattern**: For data access abstraction
- **Dependency Injection**: For service management
- **Observer Pattern**: For reactive UI updates

## Dependencies

- `firebase_core`: Firebase core functionality
- `firebase_auth`: Authentication services
- `cloud_firestore`: Database operations
- `flutter_bloc`: State management
- `flutter`: UI framework

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository.


<img width="768" height="125" alt="app_flow_diagram" src="https://github.com/user-attachments/assets/0539fbff-959a-4cc7-a709-57edb1b56a11" />

