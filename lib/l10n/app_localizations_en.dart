// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BrightWay';

  @override
  String get startPoint => 'Start Point';

  @override
  String get endPoint => 'End Point';

  @override
  String get calculatePath => 'Calculate Path';

  @override
  String get pathFound => 'Path Found';

  @override
  String get noPathAvailable => 'No path available';

  @override
  String get calculatingPath => 'Calculating path...';

  @override
  String pathSteps(int steps) {
    return 'Path: $steps steps';
  }

  @override
  String get navigationInstructions => 'Navigation Instructions';

  @override
  String startFacing(String direction) {
    return 'Start facing $direction';
  }

  @override
  String get turnLeft => 'Turn left';

  @override
  String get turnRight => 'Turn right';

  @override
  String get turnAround => 'Turn around';

  @override
  String get goStraight => 'Go straight';

  @override
  String get takeStep => 'Take 1 step forward';

  @override
  String takeStepToDestination(String destination) {
    return 'Take 1 step forward to reach $destination';
  }

  @override
  String youHaveArrived(String destination) {
    return 'You have arrived at $destination';
  }

  @override
  String startingFrom(String start, String direction) {
    return 'Starting from $start, face $direction';
  }

  @override
  String get walkForward => 'Walk forward one step';

  @override
  String walkForwardToDestination(String destination) {
    return 'Walk forward one step to reach $destination';
  }

  @override
  String get directionNorth => 'north';

  @override
  String get directionSouth => 'south';

  @override
  String get directionLeft => 'left';

  @override
  String get directionRight => 'right';

  @override
  String pathfindingStartingAlgorithm(String start, String end) {
    return 'Starting A* algorithm from $start to $end';
  }

  @override
  String pathfindingGridSize(int rows, int cols) {
    return 'Grid size: ${rows}x$cols';
  }

  @override
  String pathfindingPathFound(int iterations) {
    return 'Path found after $iterations iterations';
  }

  @override
  String pathfindingPathCalculated(int steps) {
    return 'Path calculated: $steps steps';
  }

  @override
  String pathfindingNoPathFound(int iterations) {
    return 'No path found after $iterations iterations';
  }

  @override
  String get gridLegend =>
      'Legend: [D] = Walkable (doors), [X] = Obstacle (blocks movement), [ ] = Empty space';

  @override
  String get gridNote =>
      'Note: All items can be destinations, but only doors allow movement through them';

  @override
  String gridRow(int row) {
    return 'Row $row';
  }

  @override
  String get itemToilet => 'Toilet';

  @override
  String get itemTable => 'Table';

  @override
  String get itemChair => 'Chair';

  @override
  String get itemDoor => 'Door';

  @override
  String get itemExitDoor => 'Exit Door';

  @override
  String get itemWall => 'Wall';

  @override
  String get itemObstacle => 'Obstacle';

  @override
  String errorPathCalculation(String error) {
    return 'Error calculating path: $error';
  }

  @override
  String errorTTSFailed(String error) {
    return 'Text-to-speech failed: $error';
  }

  @override
  String get userWelcome => 'Welcome!';

  @override
  String get userPanel => 'User Panel';

  @override
  String get places => 'Places';

  @override
  String get placesSubtitle => 'Discover available places';

  @override
  String get settings => 'Settings';

  @override
  String get settingsSubtitle => 'App settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageSelection => 'Language Selection';

  @override
  String get languageSection => 'Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get apply => 'Apply';

  @override
  String get applyChanges => 'Apply Changes';

  @override
  String get languageChangeInfo =>
      'Language changes will affect both the app interface and text-to-speech. The app will restart to apply the new language.';

  @override
  String get availablePlaces => 'Available Places';

  @override
  String get discoverAmazingPlaces => 'Discover Amazing Places!';

  @override
  String get browseDesignsDescription =>
      'Browse designs created by our community admins';

  @override
  String get availableDesigns => 'Available Designs';

  @override
  String designsCount(int count) {
    return '$count designs';
  }

  @override
  String get noDesignsAvailable => 'No Designs Available';

  @override
  String get noDesignsDescription =>
      'Admins haven\'t created any designs yet.\nCheck back later!';

  @override
  String createdBy(String adminName) {
    return 'Created by: $adminName';
  }

  @override
  String itemsCount(int count) {
    return '$count items';
  }

  @override
  String createdOn(String date) {
    return 'Created $date';
  }

  @override
  String get selectStartPoint => 'Select Start Point';

  @override
  String get selectEndPoint => 'Select End Point';

  @override
  String pathLength(int steps) {
    return 'Path Length: $steps steps';
  }

  @override
  String get noPathFound => 'No path found between the selected points';

  @override
  String get pathCalculationError => 'Error calculating path';

  @override
  String gridSize(int rows, int cols) {
    return 'Grid Size: $rows×$cols';
  }

  @override
  String totalItems(int count) {
    return 'Total Items: $count';
  }

  @override
  String get calculating => 'Calculating...';

  @override
  String get go => 'Go!';

  @override
  String selectPoint(String title) {
    return 'Select $title';
  }

  @override
  String positionAt(int row, int col) {
    return 'Position: ($row, $col)';
  }

  @override
  String get navigationPath => 'Navigation Path';

  @override
  String totalSteps(int count) {
    return 'Total steps: $count';
  }

  @override
  String get stepByStepDirections => 'Step-by-step directions:';

  @override
  String get tapSpeakerToHearInstructions =>
      'Tap the speaker button to hear navigation instructions';

  @override
  String get ttsNotAvailableTapButtonToShowInstructions =>
      'TTS not available. Tap the button below to show instructions.';

  @override
  String get retryTts => 'Retry TTS';

  @override
  String get speakNavigationInstructions => 'Speak Navigation Instructions';

  @override
  String get showNavigationInstructions => 'Show Navigation Instructions';

  @override
  String get navigation => 'Navigation';
}
