import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Service for managing accessibility features and screen reader announcements
class AccessibilityService {
  static final AccessibilityService _instance = AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  /// Announces a message to screen readers
  static void announceForAccessibility(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announces screen changes
  static void announceScreenChange(BuildContext context, String screenName) {
    announceForAccessibility(context, 'Now viewing $screenName screen');
  }

  /// Announces form field focus
  static void announceFieldFocus(BuildContext context, String fieldName) {
    announceForAccessibility(context, '$fieldName field is now focused');
  }

  /// Announces form field blur
  static void announceFieldBlur(BuildContext context, String fieldName) {
    announceForAccessibility(context, '$fieldName field is no longer focused');
  }

  /// Announces validation errors
  static void announceValidationError(BuildContext context, String fieldName, String error) {
    announceForAccessibility(context, '$fieldName field has an error: $error');
  }

  /// Announces successful actions
  static void announceSuccess(BuildContext context, String action) {
    announceForAccessibility(context, '$action completed successfully');
  }

  /// Announces loading states
  static void announceLoading(BuildContext context, String action) {
    announceForAccessibility(context, 'Loading: $action in progress');
  }

  /// Announces error states
  static void announceError(BuildContext context, String action, String error) {
    announceForAccessibility(context, 'Error occurred while $action: $error');
  }

  /// Announces navigation actions
  static void announceNavigation(BuildContext context, String from, String to) {
    announceForAccessibility(context, 'Navigating from $from to $to');
  }

  /// Announces button actions
  static void announceButtonAction(BuildContext context, String action) {
    announceForAccessibility(context, 'Double tap to $action');
  }

  /// Announces form submission
  static void announceFormSubmission(BuildContext context, String formName) {
    announceForAccessibility(context, 'Submitting $formName form');
  }

  /// Announces password visibility changes
  static void announcePasswordVisibility(BuildContext context, bool isVisible) {
    final message = isVisible 
        ? 'Password is now visible. Double tap to hide'
        : 'Password is now hidden. Double tap to show';
    announceForAccessibility(context, message);
  }

  /// Announces authentication status changes
  static void announceAuthStatus(BuildContext context, bool isAuthenticated) {
    final message = isAuthenticated 
        ? 'You are now signed in'
        : 'You are now signed out';
    announceForAccessibility(context, message);
  }

  /// Announces list item selection
  static void announceListItemSelection(BuildContext context, String itemName, int position, int total) {
    announceForAccessibility(context, '$itemName selected, item $position of $total');
  }

  /// Announces progress updates
  static void announceProgress(BuildContext context, String action, double percentage) {
    final percent = (percentage * 100).round();
    announceForAccessibility(context, '$action: $percent% complete');
  }

  /// Announces settings changes
  static void announceSettingChange(BuildContext context, String setting, String value) {
    announceForAccessibility(context, 'Setting changed: $setting is now $value');
  }

  /// Announces search results
  static void announceSearchResults(BuildContext context, String query, int results) {
    announceForAccessibility(context, 'Search results for "$query": $results items found');
  }

  /// Announces filter changes
  static void announceFilterChange(BuildContext context, String filterType, String value) {
    announceForAccessibility(context, 'Filter applied: $filterType is $value');
  }

  /// Announces sort changes
  static void announceSortChange(BuildContext context, String sortBy, String order) {
    announceForAccessibility(context, 'Items sorted by $sortBy in $order order');
  }

  /// Announces multi-selection changes
  static void announceMultiSelection(BuildContext context, int selectedCount, int total) {
    announceForAccessibility(context, '$selectedCount of $total items selected');
  }

  /// Announces deletion actions
  static void announceDeletion(BuildContext context, String itemName) {
    announceForAccessibility(context, '$itemName deleted');
  }

  /// Announces editing actions
  static void announceEditing(BuildContext context, String itemName) {
    announceForAccessibility(context, 'Editing $itemName');
  }

  /// Announces creation actions
  static void announceCreation(BuildContext context, String itemType) {
    announceForAccessibility(context, 'Creating new $itemType');
  }

  /// Announces save actions
  static void announceSave(BuildContext context, String itemName) {
    announceForAccessibility(context, 'Saving changes to $itemName');
  }

  /// Announces cancel actions
  static void announceCancel(BuildContext context, String action) {
    announceForAccessibility(context, '$action cancelled');
  }

  /// Announces confirmation actions
  static void announceConfirmation(BuildContext context, String action) {
    announceForAccessibility(context, '$action confirmed');
  }

  /// Announces undo actions
  static void announceUndo(BuildContext context, String action) {
    announceForAccessibility(context, '$action undone');
  }

  /// Announces redo actions
  static void announceRedo(BuildContext context, String action) {
    announceForAccessibility(context, '$action redone');
  }

  /// Announces refresh actions
  static void announceRefresh(BuildContext context, String content) {
    announceForAccessibility(context, 'Refreshing $content');
  }

  /// Announces sync actions
  static void announceSync(BuildContext context, String content) {
    announceForAccessibility(context, 'Synchronizing $content');
  }

  /// Announces backup actions
  static void announceBackup(BuildContext context, String content) {
    announceForAccessibility(context, 'Backing up $content');
  }

  /// Announces restore actions
  static void announceRestore(BuildContext context, String content) {
    announceForAccessibility(context, 'Restoring $content');
  }

  /// Announces import actions
  static void announceImport(BuildContext context, String content) {
    announceForAccessibility(context, 'Importing $content');
  }

  /// Announces export actions
  static void announceExport(BuildContext context, String content) {
    announceForAccessibility(context, 'Exporting $content');
  }

  /// Announces share actions
  static void announceShare(BuildContext context, String content) {
    announceForAccessibility(context, 'Sharing $content');
  }

  /// Announces print actions
  static void announcePrint(BuildContext context, String content) {
    announceForAccessibility(context, 'Printing $content');
  }

  /// Announces download actions
  static void announceDownload(BuildContext context, String content) {
    announceForAccessibility(context, 'Downloading $content');
  }

  /// Announces upload actions
  static void announceUpload(BuildContext context, String content) {
    announceForAccessibility(context, 'Uploading $content');
  }

  /// Announces copy actions
  static void announceCopy(BuildContext context, String content) {
    announceForAccessibility(context, '$content copied');
  }

  /// Announces paste actions
  static void announcePaste(BuildContext context, String content) {
    announceForAccessibility(context, '$content pasted');
  }

  /// Announces cut actions
  static void announceCut(BuildContext context, String content) {
    announceForAccessibility(context, '$content cut');
  }

  /// Announces select all actions
  static void announceSelectAll(BuildContext context, String content) {
    announceForAccessibility(context, 'All $content selected');
  }

  /// Announces clear actions
  static void announceClear(BuildContext context, String content) {
    announceForAccessibility(context, '$content cleared');
  }

  /// Announces reset actions
  static void announceReset(BuildContext context, String content) {
    announceForAccessibility(context, '$content reset to default');
  }

  /// Announces help actions
  static void announceHelp(BuildContext context, String topic) {
    announceForAccessibility(context, 'Getting help with $topic');
  }

  /// Announces feedback actions
  static void announceFeedback(BuildContext context, String type) {
    announceForAccessibility(context, 'Providing $type feedback');
  }

  /// Announces about actions
  static void announceAbout(BuildContext context) {
    announceForAccessibility(context, 'About this application');
  }

  /// Announces settings actions
  static void announceSettings(BuildContext context) {
    announceForAccessibility(context, 'Application settings');
  }

  /// Announces profile actions
  static void announceProfile(BuildContext context) {
    announceForAccessibility(context, 'User profile');
  }

  /// Announces logout actions
  static void announceLogout(BuildContext context) {
    announceForAccessibility(context, 'Signing out of your account');
  }

  /// Announces account actions
  static void announceAccountAction(BuildContext context, String action) {
    announceForAccessibility(context, 'Account $action');
  }

  /// Announces security actions
  static void announceSecurityAction(BuildContext context, String action) {
    announceForAccessibility(context, 'Security $action');
  }

  /// Announces privacy actions
  static void announcePrivacyAction(BuildContext context, String action) {
    announceForAccessibility(context, 'Privacy $action');
  }

  /// Announces notification actions
  static void announceNotificationAction(BuildContext context, String action) {
    announceForAccessibility(context, 'Notification $action');
  }

  /// Announces theme changes
  static void announceThemeChange(BuildContext context, String theme) {
    announceForAccessibility(context, 'Theme changed to $theme');
  }

  /// Announces language changes
  static void announceLanguageChange(BuildContext context, String language) {
    announceForAccessibility(context, 'Language changed to $language');
  }

  /// Announces accessibility feature changes
  static void announceAccessibilityFeature(BuildContext context, String feature, String state) {
    announceForAccessibility(context, 'Accessibility $feature is now $state');
  }

  /// Announces font size changes
  static void announceFontSizeChange(BuildContext context, String size) {
    announceForAccessibility(context, 'Font size changed to $size');
  }

  /// Announces contrast changes
  static void announceContrastChange(BuildContext context, String level) {
    announceForAccessibility(context, 'Contrast changed to $level');
  }

  /// Announces animation state changes
  static void announceAnimationState(BuildContext context, String state) {
    announceForAccessibility(context, 'Animation is now $state');
  }

  /// Announces sound state changes
  static void announceSoundState(BuildContext context, String state) {
    announceForAccessibility(context, 'Sound is now $state');
  }

  /// Announces vibration state changes
  static void announceVibrationState(BuildContext context, String state) {
    announceForAccessibility(context, 'Vibration is now $state');
  }

  /// Announces haptic feedback state changes
  static void announceHapticState(BuildContext context, String state) {
    announceForAccessibility(context, 'Haptic feedback is now $state');
  }

  /// Announces voice guidance state changes
  static void announceVoiceGuidanceState(BuildContext context, String state) {
    announceForAccessibility(context, 'Voice guidance is now $state');
  }

  /// Announces screen reader state changes
  static void announceScreenReaderState(BuildContext context, String state) {
    announceForAccessibility(context, 'Screen reader is now $state');
  }

  /// Announces magnification level changes
  static void announceMagnificationLevel(BuildContext context, String level) {
    announceForAccessibility(context, 'Magnification level is now $level');
  }

  /// Announces color blindness support changes
  static void announceColorBlindnessSupport(BuildContext context, String type) {
    announceForAccessibility(context, 'Color blindness support for $type enabled');
  }

  /// Announces motor accessibility feature changes
  static void announceMotorAccessibility(BuildContext context, String feature, String state) {
    announceForAccessibility(context, 'Motor accessibility $feature is now $state');
  }

  /// Announces cognitive accessibility feature changes
  static void announceCognitiveAccessibility(BuildContext context, String feature, String state) {
    announceForAccessibility(context, 'Cognitive accessibility $feature is now $state');
  }

  /// Announces hearing accessibility feature changes
  static void announceHearingAccessibility(BuildContext context, String feature, String state) {
    announceForAccessibility(context, 'Hearing accessibility $feature is now $state');
  }

  /// Announces vision accessibility feature changes
  static void announceVisionAccessibility(BuildContext context, String feature, String state) {
    announceForAccessibility(context, 'Vision accessibility $feature is now $state');
  }
}
