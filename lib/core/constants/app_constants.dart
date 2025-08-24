class AppConstants {
  static const String appName = 'BrightWay';
  
  // User roles
  static const String roleAdmin = 'admin';
  static const String roleUser = 'user';
  
  // Default role for new users
  static const String defaultRole = roleUser;
  
  // Firebase collections
  static const String usersCollection = 'users';
  
  // Error messages
  static const String errorInvalidEmail = 'Please enter a valid email address';
  static const String errorPasswordTooShort = 'Password must be at least 6 characters';
  static const String errorPasswordsDoNotMatch = 'Passwords do not match';
  static const String errorFieldRequired = 'This field is required';
}
