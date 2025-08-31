import '../models/grid_models.dart';

/// Service for finding shortest paths in the grid
/// Uses only cardinal directions (Up, Down, Left, Right) for accessibility
class PathfindingService {
  /// Find shortest path using A* algorithm with cardinal directions only
  static GridPath findShortestPath(
    List<List<GridCell>> grid,
    GridPosition start,
    GridPosition end,
  ) {
    if (start == end) {
      return const GridPath(positions: [], totalDistance: 0.0);
    }

    final openSet = <GridPosition>{start};
    final cameFrom = <GridPosition, GridPosition>{};
    final gScore = <GridPosition, double>{start: 0.0};
    final fScore = <GridPosition, double>{start: _heuristic(start, end)};

    while (openSet.isNotEmpty) {
      // Find position with lowest fScore
      final current = openSet.reduce((a, b) => 
        (fScore[a] ?? double.infinity) < (fScore[b] ?? double.infinity) ? a : b);

      if (current == end) {
        return _reconstructPath(cameFrom, current, grid);
      }

      openSet.remove(current);

      for (final neighbor in _getValidNeighbors(current, grid)) {
        final tentativeGScore = (gScore[current] ?? double.infinity) + 1.0;

        if (tentativeGScore < (gScore[neighbor] ?? double.infinity)) {
          cameFrom[neighbor] = current;
          gScore[neighbor] = tentativeGScore;
          fScore[neighbor] = tentativeGScore + _heuristic(neighbor, end);

          if (!openSet.contains(neighbor)) {
            openSet.add(neighbor);
          }
        }
      }
    }

    // No path found
    return const GridPath(positions: [], totalDistance: double.infinity);
  }

  /// Get valid neighboring positions using only cardinal directions
  static List<GridPosition> _getValidNeighbors(
    GridPosition position,
    List<List<GridCell>> grid,
  ) {
    final neighbors = <GridPosition>[];
    // Only cardinal directions for accessibility (no diagonal movement)
    final directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1], // Up, Down, Left, Right
    ];

    for (final direction in directions) {
      final newRow = position.row + direction[0];
      final newCol = position.col + direction[1];

      if (newRow >= 0 && 
          newRow < grid.length && 
          newCol >= 0 && 
          newCol < grid[0].length) {
        final cell = grid[newRow][newCol];
        if (cell.isWalkable) {
          neighbors.add(GridPosition(newRow, newCol));
        }
      }
    }

    return neighbors;
  }

  /// Improved heuristic function using Manhattan distance for cardinal-only movement
  static double _heuristic(GridPosition a, GridPosition b) {
    // Manhattan distance is optimal for cardinal-only movement
    return (a.row - b.row).abs() + (a.col - b.col).abs().toDouble();
  }

  /// Reconstruct path from cameFrom map
  static GridPath _reconstructPath(
    Map<GridPosition, GridPosition> cameFrom,
    GridPosition current,
    List<List<GridCell>> grid,
  ) {
    final path = <GridPosition>[current];
    var totalDistance = 0.0;

    while (cameFrom.containsKey(current)) {
      current = cameFrom[current]!;
      path.insert(0, current);
      totalDistance += 1.0;
    }

    return GridPath(
      positions: path,
      totalDistance: totalDistance,
    );
  }

  /// Clear all path markers from grid
  static void clearPaths(List<List<GridCell>> grid) {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        grid[i][j].isPath = false;
      }
    }
  }

  /// Mark path on grid
  static void markPath(List<List<GridCell>> grid, GridPath path) {
    clearPaths(grid);
    for (final position in path.positions) {
      if (position.row >= 0 && 
          position.row < grid.length && 
          position.col >= 0 && 
          position.col < grid[0].length) {
        grid[position.row][position.col].isPath = true;
      }
    }
  }

  /// Find multiple path options and return the shortest one
  /// This can help in cases where the standard A* might not find the optimal path
  static GridPath findOptimalPath(
    List<List<GridCell>> grid,
    GridPosition start,
    GridPosition end,
  ) {
    // Try the standard A* first
    final standardPath = findShortestPath(grid, start, end);
    
    // If no path found or path is very long, try alternative approaches
    if (!standardPath.isValid || standardPath.totalDistance > 10) {
      // Try with different heuristic weights
      final alternativePath = _findPathWithAlternativeHeuristic(grid, start, end);
      
      // Try the direct pathfinding approach
      final directPath = findDirectPath(grid, start, end);
      
      // Try the efficient pathfinding approach
      final efficientPath = findEfficientPath(grid, start, end);
      
      // Try the intelligent pathfinding approach
      final intelligentPath = findIntelligentPath(grid, start, end);
      
      // Find the shortest path among all options
      GridPath shortestPath = standardPath;
      double shortestDistance = standardPath.totalDistance;
      
      if (alternativePath.isValid && alternativePath.totalDistance < shortestDistance) {
        shortestPath = alternativePath;
        shortestDistance = alternativePath.totalDistance;
      }
      
      if (directPath.isValid && directPath.totalDistance < shortestDistance) {
        shortestPath = directPath;
        shortestDistance = directPath.totalDistance;
      }
      
      if (efficientPath.isValid && efficientPath.totalDistance < shortestDistance) {
        shortestPath = efficientPath;
        shortestDistance = efficientPath.totalDistance;
      }
      
      if (intelligentPath.isValid && intelligentPath.totalDistance < shortestDistance) {
        shortestPath = intelligentPath;
        shortestDistance = intelligentPath.totalDistance;
      }
      
      return shortestPath;
    }
    
    return standardPath;
  }

  /// Find path using alternative heuristic approach
  static GridPath _findPathWithAlternativeHeuristic(
    List<List<GridCell>> grid,
    GridPosition start,
    GridPosition end,
  ) {
    if (start == end) {
      return const GridPath(positions: [], totalDistance: 0.0);
    }

    final openSet = <GridPosition>{start};
    final cameFrom = <GridPosition, GridPosition>{};
    final gScore = <GridPosition, double>{start: 0.0};
    final fScore = <GridPosition, double>{start: _alternativeHeuristic(start, end)};

    while (openSet.isNotEmpty) {
      final current = openSet.reduce((a, b) => 
        (fScore[a] ?? double.infinity) < (fScore[b] ?? double.infinity) ? a : b);

      if (current == end) {
        return _reconstructPath(cameFrom, current, grid);
      }

      openSet.remove(current);

      for (final neighbor in _getValidNeighbors(current, grid)) {
        final tentativeGScore = (gScore[current] ?? double.infinity) + 1.0;

        if (tentativeGScore < (gScore[neighbor] ?? double.infinity)) {
          cameFrom[neighbor] = current;
          gScore[neighbor] = tentativeGScore;
          fScore[neighbor] = tentativeGScore + _alternativeHeuristic(neighbor, end);

          if (!openSet.contains(neighbor)) {
            openSet.add(neighbor);
          }
        }
      }
    }

    return const GridPath(positions: [], totalDistance: double.infinity);
  }

  /// Alternative heuristic that prioritizes horizontal movement
  static double _alternativeHeuristic(GridPosition a, GridPosition b) {
    final dx = (a.row - b.row).abs();
    final dy = (a.col - b.col).abs();
    // Prioritize horizontal movement slightly to encourage straighter paths
    return (dx * dx + dy * dy * 0.8).toDouble();
  }

  /// Find the most direct path by prioritizing straight-line movement
  /// This is especially useful for simple grid layouts with cardinal-only movement
  static GridPath findDirectPath(
    List<List<GridCell>> grid,
    GridPosition start,
    GridPosition end,
  ) {
    if (start == end) {
      return const GridPath(positions: [], totalDistance: 0.0);
    }

    // Try to find a path that follows the most direct route
    final openSet = <GridPosition>{start};
    final cameFrom = <GridPosition, GridPosition>{};
    final gScore = <GridPosition, double>{start: 0.0};
    final fScore = <GridPosition, double>{start: _directHeuristic(start, end)};

    while (openSet.isNotEmpty) {
      final current = openSet.reduce((a, b) => 
        (fScore[a] ?? double.infinity) < (fScore[b] ?? double.infinity) ? a : b);

      if (current == end) {
        return _reconstructPath(cameFrom, current, grid);
      }

      openSet.remove(current);

      for (final neighbor in _getValidNeighbors(current, grid)) {
        final tentativeGScore = (gScore[current] ?? double.infinity) + 1.0;

        if (tentativeGScore < (gScore[neighbor] ?? double.infinity)) {
          cameFrom[neighbor] = current;
          gScore[neighbor] = tentativeGScore;
          fScore[neighbor] = tentativeGScore + _directHeuristic(neighbor, end);

          if (!openSet.contains(neighbor)) {
            openSet.add(neighbor);
          }
        }
      }
    }

    return const GridPath(positions: [], totalDistance: double.infinity);
  }

  /// Heuristic that strongly encourages movement towards the target
  static double _directHeuristic(GridPosition a, GridPosition b) {
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

  /// Find the most efficient path by prioritizing movement towards the target
  /// This method is specifically designed to find shorter paths in simple grid layouts
  static GridPath findEfficientPath(
    List<List<GridCell>> grid,
    GridPosition start,
    GridPosition end,
  ) {
    if (start == end) {
      return const GridPath(positions: [], totalDistance: 0.0);
    }

    // Try to find a path that moves more directly towards the target
    final openSet = <GridPosition>{start};
    final cameFrom = <GridPosition, GridPosition>{};
    final gScore = <GridPosition, double>{start: 0.0};
    final fScore = <GridPosition, double>{start: _efficientHeuristic(start, end)};

    while (openSet.isNotEmpty) {
      final current = openSet.reduce((a, b) => 
        (fScore[a] ?? double.infinity) < (fScore[b] ?? double.infinity) ? a : b);

      if (current == end) {
        return _reconstructPath(cameFrom, current, grid);
      }

      openSet.remove(current);

      for (final neighbor in _getValidNeighbors(current, grid)) {
        final tentativeGScore = (gScore[current] ?? double.infinity) + 1.0;

        if (tentativeGScore < (gScore[neighbor] ?? double.infinity)) {
          cameFrom[neighbor] = current;
          gScore[neighbor] = tentativeGScore;
          fScore[neighbor] = tentativeGScore + _efficientHeuristic(neighbor, end);

          if (!openSet.contains(neighbor)) {
            openSet.add(neighbor);
          }
        }
      }
    }

    return const GridPath(positions: [], totalDistance: double.infinity);
  }

  /// Efficient heuristic that strongly encourages movement towards the target
  static double _efficientHeuristic(GridPosition a, GridPosition b) {
    final dx = (a.row - b.row).abs();
    final dy = (a.col - b.col).abs();
    
    // Use a combination of Manhattan distance and directional bias
    // This helps the algorithm prefer paths that move towards the target
    final manhattan = dx + dy;
    final directionalBias = (dx > dy) ? dx * 0.1 : dy * 0.1;
    
    return manhattan + directionalBias;
  }

  /// Intelligent pathfinding that finds the most direct route
  /// This method specifically targets the shortest path problem
  static GridPath findIntelligentPath(
    List<List<GridCell>> grid,
    GridPosition start,
    GridPosition end,
  ) {
    if (start == end) {
      return const GridPath(positions: [], totalDistance: 0.0);
    }

    // Try to find the most direct path by moving towards the target
    final path = <GridPosition>[start];
    var currentPos = start;
    
    // First, try to move horizontally towards the target
    while (currentPos.col != end.col) {
      final nextCol = currentPos.col < end.col ? currentPos.col + 1 : currentPos.col - 1;
      final nextPos = GridPosition(currentPos.row, nextCol);
      
      // Check if this position is walkable
      if (_isPositionWalkable(nextPos, grid)) {
        path.add(nextPos);
        currentPos = nextPos;
      } else {
        // If horizontal movement is blocked, try vertical movement
        break;
      }
    }
    
    // Then, try to move vertically towards the target
    while (currentPos.row != end.row) {
      final nextRow = currentPos.row < end.row ? currentPos.row + 1 : currentPos.row - 1;
      final nextPos = GridPosition(nextRow, currentPos.col);
      
      // Check if this position is walkable
      if (_isPositionWalkable(nextPos, grid)) {
        path.add(nextPos);
        currentPos = nextPos;
      } else {
        // If vertical movement is blocked, we need to find an alternative route
        break;
      }
    }
    
    // If we reached the target, return the path
    if (currentPos.row == end.row && currentPos.col == end.col) {
      return GridPath(
        positions: path,
        totalDistance: (path.length - 1).toDouble(),
      );
    }
    
    // If the direct path didn't work, fall back to A* algorithm
    return findShortestPath(grid, start, end);
  }

  /// Check if a position is walkable
  static bool _isPositionWalkable(GridPosition pos, List<List<GridCell>> grid) {
    if (pos.row < 0 || pos.row >= grid.length || 
        pos.col < 0 || pos.col >= grid[0].length) {
      return false;
    }
    
    final cell = grid[pos.row][pos.col];
    return cell.isWalkable;
  }
}

