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
  String get help => 'Help';

  @override
  String get helpSubtitle => 'Usage guide';

  @override
  String get settings => 'Settings';

  @override
  String get settingsSubtitle => 'App settings';

  @override
  String get about => 'About';

  @override
  String get aboutSubtitle => 'App information';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpContent =>
      'Discovering Places:\n• Click on Places section to view available designs\n• Select a place to see its details\n• Listen to navigation instructions\n\nNavigation:\n• Use left, right, up, down directions\n• Get voice guidance with text-to-speech feature';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsContent => 'Settings will be added soon...';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutContent =>
      'Grid-based place navigation app for visually impaired users\n\nFeatures:\n• Grid-based place design\n• Shortest path finding with A* algorithm\n• Voice navigation with text-to-speech\n• Turkish language support';

  @override
  String get ok => 'OK';
}
