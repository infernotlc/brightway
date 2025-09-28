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


## Usage

### Authentication Flow

1. **First Launch**: App shows login screen
2. **Registration**: New users can create accounts (default role: user)
3. **Login**: Existing users can sign in
4. **Password Reset**: Users can reset passwords via email

### Role-Based Navigation

- **Admin Users**: Navigate to admin dashboard with management features
- **Regular Users**: Navigate to user dashboard with basic features



## Architecture Overview

### Core Layer
- **Models**: Data structures and business entities
- **Services**: External service integrations
- **BLoCs**: Business logic and state management
- **Constants**: App-wide configuration

### Presentation Layer
- *Screens**: Full-page UI components
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


