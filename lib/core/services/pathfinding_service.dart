import '../models/grid_models.dart';

/// Service for finding shortest paths in the grid
class PathfindingService {
  /// Find shortest path using A* algorithm
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

  /// Get valid neighboring positions
  static List<GridPosition> _getValidNeighbors(
      GridPosition position,
      List<List<GridCell>> grid,
      ) {
    final neighbors = <GridPosition>[];
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

  /// Heuristic function (Manhattan distance)
  static double _heuristic(GridPosition a, GridPosition b) {
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
}