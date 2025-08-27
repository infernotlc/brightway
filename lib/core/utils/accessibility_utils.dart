import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility utilities for making the app accessible to blind users
class AccessibilityUtils {
  // Common semantic labels
  static const String loginButtonLabel = 'Login to your account';
  static const String registerButtonLabel = 'Create new account';
  static const String emailFieldLabel = 'Email address input field';
  static const String passwordFieldLabel = 'Password input field';
  static const String forgotPasswordLabel = 'Reset your password';
  static const String appTitleLabel = 'BrightWay - Your Bright Path Forward';
  static const String welcomeMessageLabel = 'Welcome back to BrightWay';
  static const String loadingIndicatorLabel = 'Loading, please wait';
  static const String errorMessageLabel = 'Error occurred';
  static const String successMessageLabel = 'Operation completed successfully';
  
  // Common semantic hints
  static const String emailFieldHint = 'Enter your email address to sign in';
  static const String passwordFieldHint = 'Enter your password to sign in';
  static const String loginButtonHint = 'Double tap to sign in with your credentials';
  static const String registerButtonHint = 'Double tap to create a new account';
  static const String forgotPasswordHint = 'Double tap to reset your password';
  static const String visibilityToggleHint = 'Double tap to toggle password visibility';
  
  /// Creates a semantic label for form fields
  static String getFormFieldLabel(String fieldName, {String? additionalInfo}) {
    if (additionalInfo != null) {
      return '$fieldName field. $additionalInfo';
    }
    return '$fieldName field';
  }
  
  /// Creates a semantic hint for form fields
  static String getFormFieldHint(String fieldName, {String? validationRule}) {
    if (validationRule != null) {
      return 'Enter your $fieldName. $validationRule';
    }
    return 'Enter your $fieldName';
  }
  
  /// Creates a semantic label for buttons
  static String getButtonLabel(String buttonText, {String? action}) {
    if (action != null) {
      return '$buttonText button. $action';
    }
    return '$buttonText button';
  }
  
  /// Creates a semantic hint for buttons
  static String getButtonHint(String action) {
    return 'Double tap to $action';
  }
  
  /// Creates a semantic label for navigation elements
  static String getNavigationLabel(String destination, {String? currentLocation}) {
    if (currentLocation != null) {
      return 'Navigate to $destination from $currentLocation';
    }
    return 'Navigate to $destination';
  }
  
  /// Creates a semantic label for status messages
  static String getStatusLabel(String status, {String? context}) {
    if (context != null) {
      return '$status: $context';
    }
    return status;
  }
  
  /// Creates a semantic label for icons
  static String getIconLabel(String iconName, {String? context}) {
    if (context != null) {
      return '$iconName icon. $context';
    }
    return '$iconName icon';
  }
  
  /// Creates a semantic label for loading states
  static String getLoadingLabel(String action) {
    return 'Loading: $action in progress';
  }
  
  /// Creates a semantic label for error states
  static String getErrorLabel(String action, String error) {
    return 'Error occurred while $action: $error';
  }
  
  /// Creates a semantic label for success states
  static String getSuccessLabel(String action) {
    return '$action completed successfully';
  }
  
  /// Creates a semantic label for form validation errors
  static String getValidationErrorLabel(String fieldName, String error) {
    return '$fieldName field has an error: $error';
  }
  
  /// Creates a semantic label for form submission
  static String getFormSubmissionLabel(String formName) {
    return 'Submitting $formName form';
  }
  
  /// Creates a semantic label for form reset
  static String getFormResetLabel(String formName) {
    return 'Resetting $formName form to default values';
  }
  
  /// Creates a semantic label for password visibility toggle
  static String getPasswordVisibilityLabel(bool isVisible) {
    return isVisible 
        ? 'Password is visible. Double tap to hide'
        : 'Password is hidden. Double tap to show';
  }
  
  /// Creates a semantic label for app state changes
  static String getAppStateLabel(String state) {
    return 'Application state changed to: $state';
  }
  
  /// Creates a semantic label for user authentication status
  static String getAuthStatusLabel(bool isAuthenticated) {
    return isAuthenticated 
        ? 'User is signed in'
        : 'User is not signed in';
  }
  
  /// Creates a semantic label for navigation actions
  static String getNavigationActionLabel(String from, String to) {
    return 'Navigating from $from to $to';
  }
  
  /// Creates a semantic label for form field focus
  static String getFieldFocusLabel(String fieldName) {
    return '$fieldName field is now focused';
  }
  
  /// Creates a semantic label for form field blur
  static String getFieldBlurLabel(String fieldName) {
    return '$fieldName field is no longer focused';
  }
  
  /// Creates a semantic label for keyboard actions
  static String getKeyboardActionLabel(String action) {
    return 'Keyboard action: $action';
  }
  
  /// Creates a semantic label for screen changes
  static String getScreenChangeLabel(String screenName) {
    return 'Now viewing $screenName screen';
  }
  
  /// Creates a semantic label for dialog actions
  static String getDialogActionLabel(String action, String dialogName) {
    return '$action in $dialogName dialog';
  }
  
  /// Creates a semantic label for list items
  static String getListItemLabel(String itemName, int position, int total) {
    return '$itemName, item $position of $total';
  }
  
  /// Creates a semantic label for progress indicators
  static String getProgressLabel(String action, double percentage) {
    final percent = (percentage * 100).round();
    return '$action: $percent% complete';
  }
  
  /// Creates a semantic label for time-based information
  static String getTimeLabel(String time, String context) {
    return '$context: $time';
  }
  
  /// Creates a semantic label for location information
  static String getLocationLabel(String location, String context) {
    return '$context: $location';
  }
  
  /// Creates a semantic label for contact information
  static String getContactLabel(String contactType, String value) {
    return '$contactType: $value';
  }
  
  /// Creates a semantic label for settings changes
  static String getSettingChangeLabel(String setting, String value) {
    return 'Setting changed: $setting is now $value';
  }
  
  /// Creates a semantic label for search actions
  static String getSearchLabel(String query, int results) {
    return 'Search results for "$query": $results items found';
  }
  
  /// Creates a semantic label for filter actions
  static String getFilterLabel(String filterType, String value) {
    return 'Filter applied: $filterType is $value';
  }
  
  /// Creates a semantic label for sort actions
  static String getSortLabel(String sortBy, String order) {
    return 'Items sorted by $sortBy in $order order';
  }
  
  /// Creates a semantic label for selection actions
  static String getSelectionLabel(String itemName, bool isSelected) {
    return '$itemName is ${isSelected ? 'selected' : 'not selected'}';
  }
  
  /// Creates a semantic label for multi-selection
  static String getMultiSelectionLabel(int selectedCount, int total) {
    return '$selectedCount of $total items selected';
  }
  
  /// Creates a semantic label for deletion actions
  static String getDeletionLabel(String itemName) {
    return 'Delete $itemName';
  }
  
  /// Creates a semantic label for editing actions
  static String getEditingLabel(String itemName) {
    return 'Edit $itemName';
  }
  
  /// Creates a semantic label for creation actions
  static String getCreationLabel(String itemType) {
    return 'Create new $itemType';
  }
  
  /// Creates a semantic label for save actions
  static String getSaveLabel(String itemName) {
    return 'Save changes to $itemName';
  }
  
  /// Creates a semantic label for cancel actions
  static String getCancelLabel(String action) {
    return 'Cancel $action';
  }
  
  /// Creates a semantic label for confirmation actions
  static String getConfirmationLabel(String action) {
    return 'Confirm $action';
  }
  
  /// Creates a semantic label for undo actions
  static String getUndoLabel(String action) {
    return 'Undo $action';
  }
  
  /// Creates a semantic label for redo actions
  static String getRedoLabel(String action) {
    return 'Redo $action';
  }
  
  /// Creates a semantic label for refresh actions
  static String getRefreshLabel(String content) {
    return 'Refresh $content';
  }
  
  /// Creates a semantic label for sync actions
  static String getSyncLabel(String content) {
    return 'Synchronize $content';
  }
  
  /// Creates a semantic label for backup actions
  static String getBackupLabel(String content) {
    return 'Backup $content';
  }
  
  /// Creates a semantic label for restore actions
  static String getRestoreLabel(String content) {
    return 'Restore $content';
  }
  
  /// Creates a semantic label for import actions
  static String getImportLabel(String content) {
    return 'Import $content';
  }
  
  /// Creates a semantic label for export actions
  static String getExportLabel(String content) {
    return 'Export $content';
  }
  
  /// Creates a semantic label for share actions
  static String getShareLabel(String content) {
    return 'Share $content';
  }
  
  /// Creates a semantic label for print actions
  static String getPrintLabel(String content) {
    return 'Print $content';
  }
  
  /// Creates a semantic label for download actions
  static String getDownloadLabel(String content) {
    return 'Download $content';
  }
  
  /// Creates a semantic label for upload actions
  static String getUploadLabel(String content) {
    return 'Upload $content';
  }
  
  /// Creates a semantic label for copy actions
  static String getCopyLabel(String content) {
    return 'Copy $content';
  }
  
  /// Creates a semantic label for paste actions
  static String getPasteLabel(String content) {
    return 'Paste $content';
  }
  
  /// Creates a semantic label for cut actions
  static String getCutLabel(String content) {
    return 'Cut $content';
  }
  
  /// Creates a semantic label for select all actions
  static String getSelectAllLabel(String content) {
    return 'Select all $content';
  }
  
  /// Creates a semantic label for clear actions
  static String getClearLabel(String content) {
    return 'Clear $content';
  }
  
  /// Creates a semantic label for reset actions
  static String getResetLabel(String content) {
    return 'Reset $content to default';
  }
  
  /// Creates a semantic label for help actions
  static String getHelpLabel(String topic) {
    return 'Get help with $topic';
  }
  
  /// Creates a semantic label for feedback actions
  static String getFeedbackLabel(String type) {
    return 'Provide $type feedback';
  }
  
  /// Creates a semantic label for about actions
  static String getAboutLabel() {
    return 'About this application';
  }
  
  /// Creates a semantic label for settings actions
  static String getSettingsLabel() {
    return 'Application settings';
  }
  
  /// Creates a semantic label for profile actions
  static String getProfileLabel() {
    return 'User profile';
  }
  
  /// Creates a semantic label for logout actions
  static String getLogoutLabel() {
    return 'Sign out of your account';
  }
  
  /// Creates a semantic label for account actions
  static String getAccountLabel(String action) {
    return 'Account $action';
  }
  
  /// Creates a semantic label for security actions
  static String getSecurityLabel(String action) {
    return 'Security $action';
  }
  
  /// Creates a semantic label for privacy actions
  static String getPrivacyLabel(String action) {
    return 'Privacy $action';
  }
  
  /// Creates a semantic label for notification actions
  static String getNotificationLabel(String action) {
    return 'Notification $action';
  }
  
  /// Creates a semantic label for theme actions
  static String getThemeLabel(String theme) {
    return 'Change theme to $theme';
  }
  
  /// Creates a semantic label for language actions
  static String getLanguageLabel(String language) {
    return 'Change language to $language';
  }
  
  /// Creates a semantic label for accessibility actions
  static String getAccessibilityLabel(String feature) {
    return 'Accessibility $feature';
  }
  
  /// Creates a semantic label for font size actions
  static String getFontSizeLabel(String size) {
    return 'Change font size to $size';
  }
  
  /// Creates a semantic label for contrast actions
  static String getContrastLabel(String level) {
    return 'Change contrast to $level';
  }
  
  /// Creates a semantic label for animation actions
  static String getAnimationLabel(String state) {
    return 'Animation is $state';
  }
  
  /// Creates a semantic label for sound actions
  static String getSoundLabel(String state) {
    return 'Sound is $state';
  }
  
  /// Creates a semantic label for vibration actions
  static String getVibrationLabel(String state) {
    return 'Vibration is $state';
  }
  
  /// Creates a semantic label for haptic actions
  static String getHapticLabel(String state) {
    return 'Haptic feedback is $state';
  }
  
  /// Creates a semantic label for voice actions
  static String getVoiceLabel(String state) {
    return 'Voice guidance is $state';
  }
  
  /// Creates a semantic label for screen reader actions
  static String getScreenReaderLabel(String state) {
    return 'Screen reader is $state';
  }
  
  /// Creates a semantic label for magnification actions
  static String getMagnificationLabel(String level) {
    return 'Magnification level is $level';
  }
  
  /// Creates a semantic label for color blindness actions
  static String getColorBlindnessLabel(String type) {
    return 'Color blindness support for $type';
  }
  
  /// Creates a semantic label for motor accessibility actions
  static String getMotorAccessibilityLabel(String feature) {
    return 'Motor accessibility: $feature';
  }
  
  /// Creates a semantic label for cognitive accessibility actions
  static String getCognitiveAccessibilityLabel(String feature) {
    return 'Cognitive accessibility: $feature';
  }
  
  /// Creates a semantic label for hearing accessibility actions
  static String getHearingAccessibilityLabel(String feature) {
    return 'Hearing accessibility: $feature';
  }
  
  /// Creates a semantic label for vision accessibility actions
  static String getVisionAccessibilityLabel(String feature) {
    return 'Vision accessibility: $feature';
  }
}
