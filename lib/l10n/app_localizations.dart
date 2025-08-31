import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BrightWay'**
  String get appTitle;

  /// No description provided for @startPoint.
  ///
  /// In en, this message translates to:
  /// **'Start Point'**
  String get startPoint;

  /// No description provided for @endPoint.
  ///
  /// In en, this message translates to:
  /// **'End Point'**
  String get endPoint;

  /// No description provided for @calculatePath.
  ///
  /// In en, this message translates to:
  /// **'Calculate Path'**
  String get calculatePath;

  /// No description provided for @pathFound.
  ///
  /// In en, this message translates to:
  /// **'Path Found'**
  String get pathFound;

  /// No description provided for @noPathAvailable.
  ///
  /// In en, this message translates to:
  /// **'No path available'**
  String get noPathAvailable;

  /// No description provided for @calculatingPath.
  ///
  /// In en, this message translates to:
  /// **'Calculating path...'**
  String get calculatingPath;

  /// Number of steps in the path
  ///
  /// In en, this message translates to:
  /// **'Path: {steps} steps'**
  String pathSteps(int steps);

  /// No description provided for @navigationInstructions.
  ///
  /// In en, this message translates to:
  /// **'Navigation Instructions'**
  String get navigationInstructions;

  /// Direction to start facing
  ///
  /// In en, this message translates to:
  /// **'Start facing {direction}'**
  String startFacing(String direction);

  /// No description provided for @turnLeft.
  ///
  /// In en, this message translates to:
  /// **'Turn left'**
  String get turnLeft;

  /// No description provided for @turnRight.
  ///
  /// In en, this message translates to:
  /// **'Turn right'**
  String get turnRight;

  /// No description provided for @turnAround.
  ///
  /// In en, this message translates to:
  /// **'Turn around'**
  String get turnAround;

  /// No description provided for @goStraight.
  ///
  /// In en, this message translates to:
  /// **'Go straight'**
  String get goStraight;

  /// No description provided for @takeStep.
  ///
  /// In en, this message translates to:
  /// **'Take 1 step forward'**
  String get takeStep;

  /// Step instruction to reach destination
  ///
  /// In en, this message translates to:
  /// **'Take 1 step forward to reach {destination}'**
  String takeStepToDestination(String destination);

  /// Arrival message
  ///
  /// In en, this message translates to:
  /// **'You have arrived at {destination}'**
  String youHaveArrived(String destination);

  /// Starting instruction
  ///
  /// In en, this message translates to:
  /// **'Starting from {start}, face {direction}'**
  String startingFrom(String start, String direction);

  /// No description provided for @walkForward.
  ///
  /// In en, this message translates to:
  /// **'Walk forward one step'**
  String get walkForward;

  /// Walk instruction to reach destination
  ///
  /// In en, this message translates to:
  /// **'Walk forward one step to reach {destination}'**
  String walkForwardToDestination(String destination);

  /// No description provided for @directionNorth.
  ///
  /// In en, this message translates to:
  /// **'north'**
  String get directionNorth;

  /// No description provided for @directionSouth.
  ///
  /// In en, this message translates to:
  /// **'south'**
  String get directionSouth;

  /// No description provided for @directionLeft.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get directionLeft;

  /// No description provided for @directionRight.
  ///
  /// In en, this message translates to:
  /// **'right'**
  String get directionRight;

  /// Pathfinding algorithm start message
  ///
  /// In en, this message translates to:
  /// **'Starting A* algorithm from {start} to {end}'**
  String pathfindingStartingAlgorithm(String start, String end);

  /// Grid dimensions
  ///
  /// In en, this message translates to:
  /// **'Grid size: {rows}x{cols}'**
  String pathfindingGridSize(int rows, int cols);

  /// Path found message
  ///
  /// In en, this message translates to:
  /// **'Path found after {iterations} iterations'**
  String pathfindingPathFound(int iterations);

  /// Path calculation result
  ///
  /// In en, this message translates to:
  /// **'Path calculated: {steps} steps'**
  String pathfindingPathCalculated(int steps);

  /// No path found message
  ///
  /// In en, this message translates to:
  /// **'No path found after {iterations} iterations'**
  String pathfindingNoPathFound(int iterations);

  /// No description provided for @gridLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend: [D] = Walkable (doors), [X] = Obstacle (blocks movement), [ ] = Empty space'**
  String get gridLegend;

  /// No description provided for @gridNote.
  ///
  /// In en, this message translates to:
  /// **'Note: All items can be destinations, but only doors allow movement through them'**
  String get gridNote;

  /// Grid row label
  ///
  /// In en, this message translates to:
  /// **'Row {row}'**
  String gridRow(int row);

  /// No description provided for @itemToilet.
  ///
  /// In en, this message translates to:
  /// **'Toilet'**
  String get itemToilet;

  /// No description provided for @itemTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get itemTable;

  /// No description provided for @itemChair.
  ///
  /// In en, this message translates to:
  /// **'Chair'**
  String get itemChair;

  /// No description provided for @itemDoor.
  ///
  /// In en, this message translates to:
  /// **'Door'**
  String get itemDoor;

  /// No description provided for @itemExitDoor.
  ///
  /// In en, this message translates to:
  /// **'Exit Door'**
  String get itemExitDoor;

  /// No description provided for @itemWall.
  ///
  /// In en, this message translates to:
  /// **'Wall'**
  String get itemWall;

  /// No description provided for @itemObstacle.
  ///
  /// In en, this message translates to:
  /// **'Obstacle'**
  String get itemObstacle;

  /// Path calculation error message
  ///
  /// In en, this message translates to:
  /// **'Error calculating path: {error}'**
  String errorPathCalculation(String error);

  /// TTS error message
  ///
  /// In en, this message translates to:
  /// **'Text-to-speech failed: {error}'**
  String errorTTSFailed(String error);

  /// Welcome message for users
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get userWelcome;

  /// User panel title
  ///
  /// In en, this message translates to:
  /// **'User Panel'**
  String get userPanel;

  /// Places section title
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get places;

  /// Places section subtitle
  ///
  /// In en, this message translates to:
  /// **'Discover available places'**
  String get placesSubtitle;

  /// Help section title
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Help section subtitle
  ///
  /// In en, this message translates to:
  /// **'Usage guide'**
  String get helpSubtitle;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Settings section subtitle
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get settingsSubtitle;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// About section subtitle
  ///
  /// In en, this message translates to:
  /// **'App information'**
  String get aboutSubtitle;

  /// Help dialog title
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// Help dialog content
  ///
  /// In en, this message translates to:
  /// **'Discovering Places:\n• Click on Places section to view available designs\n• Select a place to see its details\n• Listen to navigation instructions\n\nNavigation:\n• Use left, right, up, down directions\n• Get voice guidance with text-to-speech feature'**
  String get helpContent;

  /// Settings dialog title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings dialog content
  ///
  /// In en, this message translates to:
  /// **'Settings will be added soon...'**
  String get settingsContent;

  /// About dialog title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// About dialog content
  ///
  /// In en, this message translates to:
  /// **'Grid-based place navigation app for visually impaired users\n\nFeatures:\n• Grid-based place design\n• Shortest path finding with A* algorithm\n• Voice navigation with text-to-speech\n• Turkish language support'**
  String get aboutContent;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
