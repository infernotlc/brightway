import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/models/grid_models.dart';
import '../../../core/services/design_service.dart';

class PlaceViewerScreen extends StatefulWidget {
  final Design design;

  const PlaceViewerScreen({super.key, required this.design});

  @override
  State<PlaceViewerScreen> createState() => _PlaceViewerScreenState();
}

class _PlaceViewerScreenState extends State<PlaceViewerScreen> {
  String _adminName = 'Loading...';
  DesignItem? _startPoint;
  DesignItem? _endPoint;
  List<GridPosition> _shortestPath = [];
  bool _isCalculatingPath = false;
  bool _isTTSAvailable = false;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadAdminName();
    // Delay TTS initialization to ensure plugin is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTTS();
    });
  }

  void _initializeTTS() async {
    try {
      // Wait a bit for the plugin to be ready
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Check if TTS is supported on this device
      try {
        final engines = await flutterTts.getEngines;
        print('Available TTS engines: $engines');
        
        if (engines.isEmpty) {
          print('No TTS engines available on this device');
          setState(() {
            _isTTSAvailable = false;
          });
          return;
        }
      } catch (e) {
        print('Could not get TTS engines: $e');
      }
      
      // Try to get available languages first
      try {
        final languages = await flutterTts.getLanguages;
        print('Available languages: $languages');
      } catch (e) {
        print('Could not get languages: $e');
      }
      
      // Check if TTS is available
      final available = await flutterTts.isLanguageAvailable("tr-TR");
      print('Turkish TR available: $available');
      
      if (available == true) {
        await flutterTts.setLanguage("tr-TR");
        await flutterTts.setSpeechRate(0.5);
        await flutterTts.setVolume(1.0);
        await flutterTts.setPitch(1.0);
        
        // Test TTS with a simple sound
        try {
          await flutterTts.speak("Test");
          await Future.delayed(const Duration(milliseconds: 100));
          await flutterTts.stop();
          
          setState(() {
            _isTTSAvailable = true;
          });
          print('TTS initialized successfully with Turkish language');
        } catch (e) {
          print('TTS test failed: $e');
          setState(() {
            _isTTSAvailable = false;
          });
        }
      } else {
        print('Turkish TTS language not available');
        setState(() {
          _isTTSAvailable = false;
        });
      }
    } catch (e) {
      print('TTS initialization error: $e');
      setState(() {
        _isTTSAvailable = false;
      });
    }
  }

  void _loadAdminName() async {
    final adminName = await DesignService.getAdminDisplayName(
      widget.design.createdBy,
    );
    setState(() {
      _adminName = adminName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.design.name),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place Header
            _buildPlaceHeader(),
            const SizedBox(height: 24),

            // Navigation Section
            _buildNavigationSection(),
            const SizedBox(height: 24),

            // Path Display
            if (_shortestPath.isNotEmpty) _buildPathDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.place,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.design.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.design.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Created by: $_adminName',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Navigation',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Start Point Selection
        _buildPointSelector(
          title: 'Start Point',
          selectedItem: _startPoint,
          onTap: () => _showItemSelectionDialog(true),
          icon: Icons.play_arrow,
          color: Colors.green,
        ),
        const SizedBox(height: 16),

        // End Point Selection
        _buildPointSelector(
          title: 'End Point',
          selectedItem: _endPoint,
          onTap: () => _showItemSelectionDialog(false),
          icon: Icons.flag,
          color: Colors.red,
        ),
        const SizedBox(height: 24),

        // Go Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: (_startPoint != null && _endPoint != null && !_isCalculatingPath)
                ? _calculateAndNavigate
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: _isCalculatingPath
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.directions),
            label: Text(
              _isCalculatingPath ? 'Calculating...' : 'Go!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPointSelector({
    required String title,
    required DesignItem? selectedItem,
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selectedItem != null ? color.withOpacity(0.1) : Colors.grey[100],
              border: Border.all(
                color: selectedItem != null ? color : Colors.grey[300]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selectedItem != null ? color : Colors.grey[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedItem?.name ?? 'Select $title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedItem != null ? color : Colors.grey[600],
                        ),
                      ),
                      if (selectedItem != null)
                        Text(
                          'Position: (${selectedItem.row + 1}, ${selectedItem.col + 1})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPathDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Navigation Path',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Grid with path visualization
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  maxHeight: MediaQuery.of(context).size.width * 0.8,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.design.cols,
                    childAspectRatio: 1,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: widget.design.rows * widget.design.cols,
                  itemBuilder: (context, index) {
                    final row = index ~/ widget.design.cols;
                    final col = index % widget.design.cols;
                    final position = GridPosition(row, col);
                    
                    return _buildPathGridCell(position);
                  },
                ),
              ),
              const SizedBox(height: 16),
              
                             // Path instructions
               Container(
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   color: Colors.blue[50],
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: Colors.blue[200]!),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         Icon(Icons.info, color: Colors.blue[700], size: 20),
                         const SizedBox(width: 8),
                         Text(
                           'Navigation Instructions',
                           style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.blue[700],
                           ),
                         ),
                       ],
                     ),
                     const SizedBox(height: 8),
                     Text(
                       'Total steps: ${_shortestPath.length}',
                       style: TextStyle(color: Colors.blue[600]),
                     ),
                     const SizedBox(height: 8),
                     // Step-by-step instructions
                     if (_shortestPath.isNotEmpty) ...[
                       Container(
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(6),
                           border: Border.all(color: Colors.blue[300]!),
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               'Step-by-step directions:',
                               style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 color: Colors.blue[700],
                                 fontSize: 12,
                               ),
                             ),
                             const SizedBox(height: 4),
                             ..._generateDetailedStepInstructions().map((instruction) => 
                               Padding(
                                 padding: const EdgeInsets.only(bottom: 2),
                                 child: Text(
                                   instruction,
                                   style: TextStyle(
                                     color: Colors.blue[600],
                                     fontSize: 11,
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                       const SizedBox(height: 8),
                     ],
                     Text(
                       _isTTSAvailable 
                         ? 'Tap the speaker button to hear navigation instructions'
                         : 'TTS not available. Tap the button below to show instructions.',
                       style: TextStyle(
                         color: Colors.blue[600],
                         fontSize: 12,
                         fontStyle: FontStyle.italic,
                       ),
                     ),
                     if (!_isTTSAvailable) ...[
                       const SizedBox(height: 8),
                       TextButton.icon(
                         onPressed: _retryTTSInitialization,
                         icon: const Icon(Icons.refresh, size: 16),
                         label: const Text('Retry TTS'),
                         style: TextButton.styleFrom(
                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                         ),
                       ),
                     ],
                   ],
                 ),
               ),
              
              const SizedBox(height: 16),
              
              // Speak button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _speakNavigationInstructions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTTSAvailable ? Colors.orange : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(_isTTSAvailable ? Icons.volume_up : Icons.info),
                  label: Text(_isTTSAvailable 
                    ? 'Speak Navigation Instructions' 
                    : 'Show Navigation Instructions'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPathGridCell(GridPosition position) {
    final isStart = _startPoint != null && 
                   position.row == _startPoint!.row && 
                   position.col == _startPoint!.col;
    final isEnd = _endPoint != null && 
                 position.row == _endPoint!.row && 
                 position.col == _endPoint!.col;
    final isPath = _shortestPath.any((pathPos) => 
                   pathPos.row == position.row && pathPos.col == position.col);
    
    // Find item at this position
    final item = widget.design.items.firstWhere(
      (item) => item.row == position.row && item.col == position.col,
      orElse: () => DesignItem(
        name: '',
        type: GridItemType.wall,
        icon: Icons.square,
        color: Colors.transparent,
        row: position.row,
        col: position.col,
      ),
    );

    Color cellColor;
    IconData cellIcon;
    Color iconColor;

    if (isStart) {
      cellColor = Colors.green;
      cellIcon = Icons.play_arrow;
      iconColor = Colors.white;
    } else if (isEnd) {
      cellColor = Colors.red;
      cellIcon = Icons.flag;
      iconColor = Colors.white;
    } else if (isPath) {
      cellColor = Colors.blue;
      cellIcon = Icons.arrow_forward;
      iconColor = Colors.white;
    } else if (item.name.isNotEmpty) {
      cellColor = item.color.withOpacity(0.8);
      cellIcon = item.icon;
      iconColor = Colors.white;
    } else {
      cellColor = Colors.grey[200]!;
      cellIcon = Icons.square;
      iconColor = Colors.grey[400]!;
    }

    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        border: Border.all(
          color: isPath ? Colors.blue : Colors.grey[300]!,
          width: isPath ? 2 : 1,
        ),
      ),
      child: Icon(
        cellIcon,
        color: iconColor,
        size: 16,
      ),
    );
  }

  void _showItemSelectionDialog(bool isStart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select ${isStart ? 'Start' : 'End'} Point'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.design.items.length,
            itemBuilder: (context, index) {
              final item = widget.design.items[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 24,
                  ),
                ),
                title: Text(item.name),
                subtitle: Text('Position: (${item.row + 1}, ${item.col + 1})'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    if (isStart) {
                      _startPoint = item;
                    } else {
                      _endPoint = item;
                    }
                    _shortestPath = []; // Clear previous path
                  });
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _calculateAndNavigate() async {
    if (_startPoint == null || _endPoint == null) return;

    setState(() {
      _isCalculatingPath = true;
    });

    try {
      print('Calculating path from ${_startPoint!.name} (${_startPoint!.row}, ${_startPoint!.col}) to ${_endPoint!.name} (${_endPoint!.row}, ${_endPoint!.col})');
      
      // Calculate shortest path using A* algorithm
      final path = _calculateOptimalPath(_startPoint!, _endPoint!);
      
      print('Path calculated: ${path.length} steps');
      if (path.isNotEmpty) {
        print('Path: ${path.map((p) => '(${p.row}, ${p.col})').join(' -> ')}');
      }
      
      setState(() {
        _shortestPath = path;
        _isCalculatingPath = false;
      });

      // Try to speak initial navigation instruction, but don't fail if TTS is not available
      try {
        await _speakNavigationInstructions();
      } catch (e) {
        print('Initial TTS failed: $e');
        // Show instructions in UI instead
        if (mounted) {
          final instructions = _generateNavigationInstructions();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(instructions),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
      
    } catch (e) {
      setState(() {
        _isCalculatingPath = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error calculating path: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<GridPosition> _calculateShortestPath(DesignItem start, DesignItem end) {
    // Enhanced A* pathfinding algorithm with better debugging
    final openSet = <GridPosition>{};
    final closedSet = <GridPosition>{};
    final cameFrom = <GridPosition, GridPosition>{};
    final gScore = <GridPosition, double>{};
    final fScore = <GridPosition, double>{};
    
    final startPos = GridPosition(start.row, start.col);
    final endPos = GridPosition(end.row, end.col);
    
    // Get localized text
    final l10n = AppLocalizations.of(context)!;
    
    print(l10n.pathfindingStartingAlgorithm(startPos.toString(), endPos.toString()));
    print(l10n.pathfindingGridSize(widget.design.rows, widget.design.cols));
    _debugPrintGrid();
    
    // Check if start and end are the same
    if (startPos.row == endPos.row && startPos.col == endPos.col) {
      print('Start and end are the same position');
      return [startPos];
    }
    
         // Check if end position is walkable
     final endItem = widget.design.items.firstWhere(
       (item) => item.row == endPos.row && item.col == endPos.col,
       orElse: () => DesignItem(
         name: '',
         type: GridItemType.door,
         icon: Icons.square,
         color: Colors.transparent,
         row: endPos.row,
         col: endPos.col,
       ),
     );
     
     // If the end position has an item that blocks movement, find a nearby walkable position
     if (endItem.name.isNotEmpty && !_isWalkable(endItem.type)) {
       print('End position is blocked by ${endItem.name} (${endItem.type}) - finding nearby walkable position');
       final nearbyWalkable = _findNearbyWalkablePosition(endPos);
       if (nearbyWalkable != null) {
         print('Found nearby walkable position: $nearbyWalkable');
         final pathToNearby = _calculateShortestPath(start, DesignItem(
           name: 'Nearby',
           type: GridItemType.door,
           icon: Icons.square,
           color: Colors.transparent,
           row: nearbyWalkable.row,
           col: nearbyWalkable.col,
         ));
         if (pathToNearby.isNotEmpty) {
           pathToNearby.add(endPos);
           return pathToNearby;
         }
       }
     }
    
    openSet.add(startPos);
    gScore[startPos] = 0;
    fScore[startPos] = _heuristic(startPos, endPos);
    
    int iterations = 0;
    while (openSet.isNotEmpty) {
      iterations++;
      if (iterations > 2000) { // Increased limit for complex grids
        print('Pathfinding exceeded 2000 iterations, stopping');
        break;
      }
      
      // Find position with lowest fScore
      GridPosition current = openSet.reduce((a, b) => 
        fScore[a]! < fScore[b]! ? a : b);
      
      if (current.row == endPos.row && current.col == endPos.col) {
        // Path found, reconstruct it
        print(l10n.pathfindingPathFound(iterations));
        return _reconstructPath(cameFrom, current);
      }
      
      openSet.remove(current);
      closedSet.add(current);
      
      // Check all neighbors
      final neighbors = _getNeighbors(current);
      print('Position ($current) has ${neighbors.length} neighbors: ${neighbors.map((n) => '(${n.row}, ${n.col})').join(', ')}');
      
      for (final neighbor in neighbors) {
        if (closedSet.contains(neighbor)) continue;
        
        final tentativeGScore = gScore[current]! + 1; // Cost to move to neighbor
        
        if (!openSet.contains(neighbor)) {
          openSet.add(neighbor);
        } else if (tentativeGScore >= (gScore[neighbor] ?? double.infinity)) {
          continue;
        }
        
        cameFrom[neighbor] = current;
        gScore[neighbor] = tentativeGScore;
        fScore[neighbor] = gScore[neighbor]! + _heuristic(neighbor, endPos);
      }
      
      // Debug: Show current state every 100 iterations
      if (iterations % 100 == 0) {
        print('Iteration $iterations: openSet=${openSet.length}, closedSet=${closedSet.length}');
      }
    }
    
    print(l10n.pathfindingNoPathFound(iterations));
    print('Open set size: ${openSet.length}');
    print('Closed set size: ${closedSet.length}');
    
    // Try to find any path to get closer to the target
    if (closedSet.isNotEmpty) {
      print('Attempting to find partial path...');
      final closestPosition = closedSet.reduce((a, b) => 
        _heuristic(a, endPos) < _heuristic(b, endPos) ? a : b);
      print('Closest position reached: $closestPosition (distance: ${_heuristic(closestPosition, endPos)})');
      
      final partialPath = _reconstructPath(cameFrom, closestPosition);
      print('Partial path found: ${partialPath.length} steps');
      return partialPath;
    }
    
    return [];
  }

  /// Try multiple pathfinding approaches to find the optimal path
  List<GridPosition> _calculateOptimalPath(DesignItem start, DesignItem end) {
    // Try the standard approach first
    final standardPath = _calculateShortestPath(start, end);
    
    // If the path is longer than expected, try alternative approaches
    if (standardPath.length > 6) { // Lowered threshold to catch suboptimal paths
      print('Standard path is long (${standardPath.length} steps), trying alternative approaches...');
      
      // Try with different heuristic weights
      final alternativePath = _calculatePathWithAlternativeHeuristic(start, end);
      
      // Try the direct pathfinding approach
      final directPath = _calculateDirectPath(start, end);
      
      // Try the efficient pathfinding approach
      final efficientPath = _calculateEfficientPath(start, end);
      
      // Try the intelligent pathfinding approach
      final intelligentPath = _calculateIntelligentPath(start, end);
      
      // Find the shortest path among all options
      List<GridPosition> shortestPath = standardPath;
      int shortestLength = standardPath.length;
      
      if (alternativePath.isNotEmpty && alternativePath.length < shortestLength) {
        shortestPath = alternativePath;
        shortestLength = alternativePath.length;
        print('Alternative path is shorter: ${alternativePath.length} steps');
      }
      
      if (directPath.isNotEmpty && directPath.length < shortestLength) {
        shortestPath = directPath;
        shortestLength = directPath.length;
        print('Direct path is shortest: ${directPath.length} steps');
      }
      
      if (efficientPath.isNotEmpty && efficientPath.length < shortestLength) {
        shortestPath = efficientPath;
        shortestLength = efficientPath.length;
        print('Efficient path is shortest: ${efficientPath.length} steps');
      }

      if (intelligentPath.isNotEmpty && intelligentPath.length < shortestLength) {
        shortestPath = intelligentPath;
        shortestLength = intelligentPath.length;
        print('Intelligent path is shortest: ${intelligentPath.length} steps');
      }
      
      if (shortestPath != standardPath) {
        print('Found shorter path: ${shortestPath.length} steps vs ${standardPath.length} steps');
        return shortestPath;
      }
    }
    
    return standardPath;
  }

  /// Calculate path using alternative heuristic approach
  List<GridPosition> _calculatePathWithAlternativeHeuristic(DesignItem start, DesignItem end) {
    final openSet = <GridPosition>{};
    final closedSet = <GridPosition>{};
    final cameFrom = <GridPosition, GridPosition>{};
    final gScore = <GridPosition, double>{};
    final fScore = <GridPosition, double>{};
    
    final startPos = GridPosition(start.row, start.col);
    final endPos = GridPosition(end.row, end.col);
    
    if (startPos.row == endPos.row && startPos.col == endPos.col) {
      return [startPos];
    }
    
    openSet.add(startPos);
    gScore[startPos] = 0;
    fScore[startPos] = _alternativeHeuristic(startPos, endPos);
    
    int iterations = 0;
    while (openSet.isNotEmpty && iterations < 1000) {
      iterations++;
      
      final current = openSet.reduce((a, b) => 
        fScore[a]! < fScore[b]! ? a : b);
      
      if (current.row == endPos.row && current.col == endPos.col) {
        return _reconstructPath(cameFrom, current);
      }
      
      openSet.remove(current);
      closedSet.add(current);
      
      final neighbors = _getNeighbors(current);
      
      for (final neighbor in neighbors) {
        if (closedSet.contains(neighbor)) continue;
        
        final tentativeGScore = gScore[current]! + 1;
        
        if (!openSet.contains(neighbor)) {
          openSet.add(neighbor);
        } else if (tentativeGScore >= (gScore[neighbor] ?? double.infinity)) {
          continue;
        }
        
        cameFrom[neighbor] = current;
        gScore[neighbor] = tentativeGScore;
        fScore[neighbor] = gScore[neighbor]! + _alternativeHeuristic(neighbor, endPos);
      }
    }
    
    return [];
  }

  /// Alternative heuristic that prioritizes horizontal movement
  double _alternativeHeuristic(GridPosition a, GridPosition b) {
    final dx = (a.row - b.row).abs();
    final dy = (a.col - b.col).abs();
    // Prioritize horizontal movement slightly to encourage straighter paths
    return (dx * dx + dy * dy * 0.8).toDouble();
  }

  /// Calculate the most direct path by prioritizing straight-line movement
  List<GridPosition> _calculateDirectPath(DesignItem start, DesignItem end) {
    final openSet = <GridPosition>{};
    final closedSet = <GridPosition>{};
    final cameFrom = <GridPosition, GridPosition>{};
    final gScore = <GridPosition, double>{};
    final fScore = <GridPosition, double>{};
    
    final startPos = GridPosition(start.row, start.col);
    final endPos = GridPosition(end.row, end.col);
    
    if (startPos.row == endPos.row && startPos.col == endPos.col) {
      return [startPos];
    }
    
    openSet.add(startPos);
    gScore[startPos] = 0;
    fScore[startPos] = _directHeuristic(startPos, endPos);
    
    int iterations = 0;
    while (openSet.isNotEmpty && iterations < 1000) {
      iterations++;
      
      final current = openSet.reduce((a, b) => 
        fScore[a]! < fScore[b]! ? a : b);
      
      if (current.row == endPos.row && current.col == endPos.col) {
        return _reconstructPath(cameFrom, current);
      }
      
      openSet.remove(current);
      closedSet.add(current);
      
      final neighbors = _getNeighbors(current);
      
      for (final neighbor in neighbors) {
        if (closedSet.contains(neighbor)) continue;
        
        final tentativeGScore = gScore[current]! + 1;
        
        if (!openSet.contains(neighbor)) {
          openSet.add(neighbor);
        } else if (tentativeGScore >= (gScore[neighbor] ?? double.infinity)) {
          continue;
        }
        
        cameFrom[neighbor] = current;
        gScore[neighbor] = tentativeGScore;
        fScore[neighbor] = gScore[neighbor]! + _directHeuristic(neighbor, endPos);
      }
    }
    
    return [];
  }

  /// Calculate the most efficient path by prioritizing movement towards the target
  List<GridPosition> _calculateEfficientPath(DesignItem start, DesignItem end) {
    final openSet = <GridPosition>{};
    final closedSet = <GridPosition>{};
    final cameFrom = <GridPosition, GridPosition>{};
    final gScore = <GridPosition, double>{};
    final fScore = <GridPosition, double>{};
    
    final startPos = GridPosition(start.row, start.col);
    final endPos = GridPosition(end.row, end.col);
    
    if (startPos.row == endPos.row && startPos.col == endPos.col) {
      return [startPos];
    }
    
    openSet.add(startPos);
    gScore[startPos] = 0;
    fScore[startPos] = _efficientHeuristic(startPos, endPos);
    
    int iterations = 0;
    while (openSet.isNotEmpty && iterations < 1000) {
      iterations++;
      
      final current = openSet.reduce((a, b) => 
        fScore[a]! < fScore[b]! ? a : b);
      
      if (current.row == endPos.row && current.col == endPos.col) {
        return _reconstructPath(cameFrom, current);
      }
      
      openSet.remove(current);
      closedSet.add(current);
      
      final neighbors = _getNeighbors(current);
      
      for (final neighbor in neighbors) {
        if (closedSet.contains(neighbor)) continue;
        
        final tentativeGScore = gScore[current]! + 1;
        
        if (!openSet.contains(neighbor)) {
          openSet.add(neighbor);
        } else if (tentativeGScore >= (gScore[neighbor] ?? double.infinity)) {
          continue;
        }
        
        cameFrom[neighbor] = current;
        gScore[neighbor] = tentativeGScore;
        fScore[neighbor] = gScore[neighbor]! + _efficientHeuristic(neighbor, endPos);
      }
    }
    
    return [];
  }

  /// Intelligent pathfinding that finds the most direct route
  /// This method specifically targets the shortest path problem
  List<GridPosition> _calculateIntelligentPath(DesignItem start, DesignItem end) {
    final startPos = GridPosition(start.row, start.col);
    final endPos = GridPosition(end.row, end.col);
    
    if (startPos.row == endPos.row && startPos.col == endPos.col) {
      return [startPos];
    }
    
    // Try to find the most direct path by moving towards the target
    final path = <GridPosition>[startPos];
    var currentPos = startPos;
    
    // First, try to move horizontally towards the target
    while (currentPos.col != endPos.col) {
      final nextCol = currentPos.col < endPos.col ? currentPos.col + 1 : currentPos.col - 1;
      final nextPos = GridPosition(currentPos.row, nextCol);
      
      // Check if this position is walkable
      if (_isPositionWalkable(nextPos)) {
        path.add(nextPos);
        currentPos = nextPos;
      } else {
        // If horizontal movement is blocked, try vertical movement
        break;
      }
    }
    
    // Then, try to move vertically towards the target
    while (currentPos.row != endPos.row) {
      final nextRow = currentPos.row < endPos.row ? currentPos.row + 1 : currentPos.row - 1;
      final nextPos = GridPosition(nextRow, currentPos.col);
      
      // Check if this position is walkable
      if (_isPositionWalkable(nextPos)) {
        path.add(nextPos);
        currentPos = nextPos;
      } else {
        // If vertical movement is blocked, we need to find an alternative route
        break;
      }
    }
    
    // If we reached the target, return the path
    if (currentPos.row == endPos.row && currentPos.col == endPos.col) {
      return path;
    }
    
    // If the direct path didn't work, fall back to A* algorithm
    return _calculateShortestPath(start, end);
  }

  /// Check if a position is walkable
  bool _isPositionWalkable(GridPosition pos) {
    if (pos.row < 0 || pos.row >= widget.design.rows || 
        pos.col < 0 || pos.col >= widget.design.cols) {
      return false;
    }
    
    // Check if there's an item at this position
    final item = widget.design.items.firstWhere(
      (item) => item.row == pos.row && item.col == pos.col,
      orElse: () => DesignItem(
        name: '',
        type: GridItemType.door,
        icon: Icons.square,
        color: Colors.transparent,
        row: pos.row,
        col: pos.col,
      ),
    );
    
    // Position is walkable if it's empty or has a walkable item
    return item.name.isEmpty || _isWalkable(item.type);
  }

  /// Efficient heuristic that strongly encourages movement towards the target
  double _efficientHeuristic(GridPosition a, GridPosition b) {
    final dx = (a.row - b.row).abs();
    final dy = (a.col - b.col).abs();
    
    // Use a combination of Manhattan distance and directional bias
    // This helps the algorithm prefer paths that move towards the target
    final manhattan = dx + dy;
    final directionalBias = (dx > dy) ? dx * 0.1 : dy * 0.1;
    
    return manhattan + directionalBias;
  }

  /// Heuristic that strongly encourages movement towards the target
  double _directHeuristic(GridPosition a, GridPosition b) {
    final dx = (a.row - b.row).abs();
    final dy = (a.col - b.col).abs();
    
    // Strongly prioritize the direction that gets us closer to the target
    // This encourages the algorithm to move directly towards the goal
    if (dx > dy) {
      // More horizontal distance, prioritize horizontal movement
      return (dx * dx + dy * dy * 0.5).toDouble();
    } else {
      // More vertical distance, prioritize vertical movement
      return (dx * dx * 0.5 + dy * dy).toDouble();
    }
  }

  List<GridPosition> _getNeighbors(GridPosition pos) {
    final neighbors = <GridPosition>[];
    // Only cardinal directions for accessibility (no diagonal movement)
    final directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1], // Up, Down, Left, Right
    ];
    
    for (final dir in directions) {
      final newRow = pos.row + dir[0];
      final newCol = pos.col + dir[1];
      
      if (newRow >= 0 && newRow < widget.design.rows &&
          newCol >= 0 && newCol < widget.design.cols) {
        
        // Check if the neighbor position is occupied by any obstacle
        final blockingItem = widget.design.items.firstWhere(
          (item) => item.row == newRow && item.col == newCol,
          orElse: () => DesignItem(
            name: '',
            type: GridItemType.door,
            icon: Icons.square,
            color: Colors.transparent,
            row: newRow,
            col: newCol,
          ),
        );
        
        if (blockingItem.name.isNotEmpty) {
          // There's an item at this position
          if (_isWalkable(blockingItem.type)) {
            neighbors.add(GridPosition(newRow, newCol));
            print('Position ($newRow, $newCol) is walkable (${blockingItem.type})');
          } else {
            print('Position ($newRow, $newCol) is blocked by ${blockingItem.name} (${blockingItem.type})');
          }
        } else {
          // Empty space - always walkable
          neighbors.add(GridPosition(newRow, newCol));
          print('Position ($newRow, $newCol) is empty space');
        }
      }
    }
    
    print('Neighbors for position ($pos): ${neighbors.map((n) => '(${n.row}, ${n.col})').join(', ')}');
    return neighbors;
  }

  bool _isWalkable(GridItemType type) {
    // Define which item types allow movement THROUGH them (not destinations)
    // This is about pathfinding - can you walk through this position?
    switch (type) {
      case GridItemType.door:
        // Doors are walkable (can pass through)
        return true;
      case GridItemType.exitDoor:
        // Exit doors are walkable
        return true;
      case GridItemType.toilet:
        // Toilets block movement (but can be destinations)
        return false;
      case GridItemType.chair:
        // Chairs block movement (but can be destinations)
        return false;
      case GridItemType.table:
        // Tables block movement (but can be destinations)
        return false;
      case GridItemType.wall:
        // Walls block movement (but can be destinations)
        return false;
      case GridItemType.obstacle:
        // Obstacles block movement (but can be destinations)
        return false;
    }
  }

  GridPosition? _findNearbyWalkablePosition(GridPosition target) {
    // Search in expanding circles around the target for walkable positions
    final maxRadius = 3; // Search up to 3 cells away
    
    for (int radius = 1; radius <= maxRadius; radius++) {
      for (int row = target.row - radius; row <= target.row + radius; row++) {
        for (int col = target.col - radius; col <= target.col + radius; col++) {
          // Only check positions at exactly this radius
          if ((row - target.row).abs() + (col - target.col).abs() == radius) {
            if (row >= 0 && row < widget.design.rows &&
                col >= 0 && col < widget.design.cols) {
              
              // Check if this position is walkable
              final item = widget.design.items.firstWhere(
                (item) => item.row == row && item.col == col,
                orElse: () => DesignItem(
                  name: '',
                  type: GridItemType.door,
                  icon: Icons.square,
                  color: Colors.transparent,
                  row: row,
                  col: col,
                ),
              );
              
              if (item.name.isEmpty || _isWalkable(item.type)) {
                print('Found nearby walkable position at ($row, $col)');
                return GridPosition(row, col);
              }
            }
          }
        }
      }
    }
    
    print('No nearby walkable position found within radius $maxRadius');
    return null;
  }

  void _debugPrintGrid() {
    // Get localized text
    final l10n = AppLocalizations.of(context)!;
    
    print('\n=== GRID LAYOUT DEBUG ===');
    print(l10n.gridLegend);
    print(l10n.gridNote);
    for (int row = 0; row < widget.design.rows; row++) {
      String rowStr = '';
      for (int col = 0; col < widget.design.cols; col++) {
        final item = widget.design.items.firstWhere(
          (item) => item.row == row && item.col == col,
          orElse: () => DesignItem(
            name: '',
            type: GridItemType.door,
            icon: Icons.square,
            color: Colors.transparent,
            row: row,
            col: col,
          ),
        );
        
        if (item.name.isNotEmpty) {
          if (_isWalkable(item.type)) {
            rowStr += '[D]'; // Door/Walkable
          } else {
            rowStr += '[X]'; // Obstacle
          }
        } else {
          rowStr += '[ ]'; // Empty space
        }
      }
      print(l10n.gridRow(row));
      print('$rowStr');
    }
    print('=== END GRID DEBUG ===\n');
  }

  double _heuristic(GridPosition a, GridPosition b) {
    // Manhattan distance is optimal for cardinal-only movement
    return (a.row - b.row).abs() + (a.col - b.col).abs().toDouble();
  }

  List<GridPosition> _reconstructPath(
    Map<GridPosition, GridPosition> cameFrom, 
    GridPosition current
  ) {
    final path = <GridPosition>[current];
    
    while (cameFrom.containsKey(current)) {
      current = cameFrom[current]!;
      path.insert(0, current);
    }
    
    return path;
  }

  Future<void> _speakNavigationInstructions() async {
    if (_shortestPath.isEmpty) return;

    final instructions = _generateTTSInstructions();
    
    // If TTS is not available, just show the instructions
    if (!_isTTSAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(instructions),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      return;
    }
    
    try {
      await flutterTts.speak(instructions);
    } catch (e) {
      print('TTS Error: $e');
      // Fallback to showing instructions in a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(instructions),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  String _generateNavigationInstructions() {
    if (_startPoint == null || _endPoint == null || _shortestPath.isEmpty) {
      return AppLocalizations.of(context)!.noPathAvailable;
    }

    final startName = _startPoint!.name;
    final endName = _endPoint!.name;
    final steps = _shortestPath.length - 1; // Exclude start position
    
    if (steps == 0) {
      return 'You are already at $endName';
    }

    // Generate step-by-step directional instructions
    final directions = _generateStepByStepDirections();
    
    String instruction = 'Navigate from $startName to $endName. ';
    instruction += 'Total distance: $steps steps. ';
    instruction += directions;
    
    return instruction;
  }

  String _generateStepByStepDirections() {
    if (_shortestPath.length < 2) return '';
    
    final directions = <String>[];
    String currentDirection = _getInitialDirection();
    
    // Get localized text
    final l10n = AppLocalizations.of(context)!;
    
    // First instruction
    directions.add(l10n.startFacing(currentDirection));
    
    // Process each step
    for (int i = 1; i < _shortestPath.length; i++) {
      final prevPos = _shortestPath[i - 1];
      final currentPos = _shortestPath[i];
      final nextPos = i < _shortestPath.length - 1 ? _shortestPath[i + 1] : null;
      
      final stepDirection = _getStepDirection(prevPos, currentPos);
      final turnInstruction = _getTurnInstruction(currentDirection, stepDirection);
      
      if (turnInstruction.isNotEmpty) {
        directions.add(turnInstruction);
        currentDirection = stepDirection;
      }
      
      // Add step instruction
      if (nextPos != null) {
        directions.add(l10n.takeStep);
      } else {
        directions.add(l10n.takeStepToDestination(_endPoint!.name));
      }
    }
    
    return directions.join('');
  }

  String _generateTTSInstructions() {
    if (_startPoint == null || _endPoint == null || _shortestPath.isEmpty) {
      return AppLocalizations.of(context)!.noPathAvailable;
    }

    final startName = _startPoint!.name;
    final endName = _endPoint!.name;
    final steps = _shortestPath.length - 1;
    
    if (steps == 0) {
      return 'You are already at $endName';
    }

    // Get localized text
    final l10n = AppLocalizations.of(context)!;

    // Generate TTS-friendly instructions
    final directions = <String>[];
    String currentDirection = _getInitialDirection();
    
    directions.add(l10n.startingFrom(startName, currentDirection));
    
    for (int i = 1; i < _shortestPath.length; i++) {
      final prevPos = _shortestPath[i - 1];
      final currentPos = _shortestPath[i];
      final nextPos = i < _shortestPath.length - 1 ? _shortestPath[i + 1] : null;
      
      final stepDirection = _getStepDirection(prevPos, currentPos);
      final turnInstruction = _getTurnInstruction(currentDirection, stepDirection);
      
      if (turnInstruction.isNotEmpty) {
        directions.add(turnInstruction);
        currentDirection = stepDirection;
      }
      
      if (nextPos != null) {
        directions.add(l10n.walkForward);
      } else {
        directions.add(l10n.walkForwardToDestination(endName));
      }
    }
    
    directions.add(l10n.youHaveArrived(endName));
    
    return directions.join('');
  }

  String _getInitialDirection() {
    // Determine initial direction based on first step
    if (_shortestPath.length < 2) return AppLocalizations.of(context)!.directionNorth;
    
    final startPos = _shortestPath[0];
    final firstStep = _shortestPath[1];
    
    if (firstStep.row < startPos.row) return AppLocalizations.of(context)!.directionNorth;
    if (firstStep.row > startPos.row) return AppLocalizations.of(context)!.directionSouth;
    if (firstStep.col < startPos.col) return AppLocalizations.of(context)!.directionLeft;
    if (firstStep.col > startPos.col) return AppLocalizations.of(context)!.directionRight;
    
    return AppLocalizations.of(context)!.directionNorth;
  }

  String _getStepDirection(GridPosition from, GridPosition to) {
    if (to.row < from.row) return AppLocalizations.of(context)!.directionNorth;
    if (to.row > from.row) return AppLocalizations.of(context)!.directionSouth;
    if (to.col < from.col) return AppLocalizations.of(context)!.directionLeft;
    if (to.col > from.col) return AppLocalizations.of(context)!.directionRight;
    return AppLocalizations.of(context)!.directionNorth;
  }

  String _getTurnInstruction(String currentDirection, String targetDirection) {
    if (currentDirection == targetDirection) return '';
    
    // Get localized text
    final l10n = AppLocalizations.of(context)!;
    
    final directions = [l10n.directionNorth, l10n.directionRight, l10n.directionSouth, l10n.directionLeft];
    final currentIndex = directions.indexOf(currentDirection);
    final targetIndex = directions.indexOf(targetDirection);
    
    if (currentIndex == -1 || targetIndex == -1) return '';
    
    // Calculate turn direction
    int turnAmount = (targetIndex - currentIndex) % 4;
    if (turnAmount < 0) turnAmount += 4;
    
    if (turnAmount == 1) {
      return l10n.turnRight;
    } else if (turnAmount == 2) {
      return l10n.turnAround;
    } else if (turnAmount == 3) {
      return l10n.turnLeft;
    }
    
    return '';
  }

  List<String> _generateDetailedStepInstructions() {
    if (_shortestPath.length < 2) return [];
    
    final instructions = <String>[];
    String currentDirection = _getInitialDirection();
    
    // First instruction
    instructions.add('1. Start facing $currentDirection');
    
    // Process each step
    for (int i = 1; i < _shortestPath.length; i++) {
      final prevPos = _shortestPath[i - 1];
      final currentPos = _shortestPath[i];
      final nextPos = i < _shortestPath.length - 1 ? _shortestPath[i + 1] : null;
      
      final stepDirection = _getStepDirection(prevPos, currentPos);
      final turnInstruction = _getTurnInstruction(currentDirection, stepDirection);
      
      if (turnInstruction.isNotEmpty) {
        instructions.add('${i + 1}. ${turnInstruction.trim()}');
        currentDirection = stepDirection;
      }
      
      // Add step instruction
      if (nextPos != null) {
        instructions.add('${i + 1}. Take 1 step forward');
      } else {
        instructions.add('${i + 1}. Take 1 step forward to reach ${_endPoint!.name}');
      }
    }
    
    return instructions;
  }

  /// Retry TTS initialization if it failed initially
  Future<void> _retryTTSInitialization() async {
    setState(() {
      _isTTSAvailable = false;
    });
    _initializeTTS(); // Remove await since _initializeTTS is void
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
