import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a grid cell in the place designer
class GridCell {
  final int row;
  final int col;
  GridItem? item;
  bool isStartPoint;
  bool isEndPoint;
  bool isPath;

  GridCell({
    required this.row,
    required this.col,
    this.item,
    this.isStartPoint = false,
    this.isEndPoint = false,
    this.isPath = false,
  });

  /// Check if cell is walkable (no obstacle)
  bool get isWalkable => item == null || item!.type == GridItemType.door;

  /// Check if cell is empty
  bool get isEmpty => item == null;

  /// Get cell color based on state
  Color get cellColor {
    if (isStartPoint) return Colors.green;
    if (isEndPoint) return Colors.red;
    if (isPath) return Colors.blue.withOpacity(0.3);
    if (item != null) return item!.color;
    return Colors.grey.shade200;
  }

  /// Clone the cell
  GridCell clone() {
    return GridCell(
      row: row,
      col: col,
      item: item?.clone(),
      isStartPoint: isStartPoint,
      isEndPoint: isEndPoint,
      isPath: isPath,
    );
  }

  @override
  String toString() => 'GridCell($row, $col, item: ${item?.name})';
}

/// Types of grid items that can be placed
enum GridItemType {
  chair,
  table,
  exitDoor,
  toilet,
  door,
  wall,
  obstacle,
}

/// Represents an item that can be placed on the grid
class GridItem {
  final String name;
  final GridItemType type;
  final IconData icon;
  final Color color;
  final bool isWalkable;
  final bool isRotatable;
  final double rotation;

  const GridItem({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.isWalkable = false,
    this.isRotatable = true,
    this.rotation = 0.0,
  });

  /// Clone the item with optional rotation
  GridItem clone({double? rotation}) {
    return GridItem(
      name: name,
      type: type,
      icon: icon,
      color: color,
      isWalkable: isWalkable,
      isRotatable: isRotatable,
      rotation: rotation ?? this.rotation,
    );
  }

  /// Get rotated item
  GridItem rotate() {
    if (!isRotatable) return this;
    return clone(rotation: (rotation + 90) % 360);
  }

  @override
  String toString() => 'GridItem($name, $type)';
}

/// Predefined grid items
class GridItems {
  static const List<GridItem> availableItems = [
    GridItem(
      name: 'Chair',
      type: GridItemType.chair,
      icon: Icons.chair,
      color: Colors.brown,
      isWalkable: false,
    ),
    GridItem(
      name: 'Table',
      type: GridItemType.table,
      icon: Icons.table_restaurant,
      color: Colors.brown,
      isWalkable: false,
    ),
    GridItem(
      name: 'Exit Door',
      type: GridItemType.exitDoor,
      icon: Icons.exit_to_app,
      color: Colors.red,
      isWalkable: true,
    ),
    GridItem(
      name: 'Toilet',
      type: GridItemType.toilet,
      icon: Icons.wc,
      color: Colors.blue,
      isWalkable: false,
    ),
    GridItem(
      name: 'Door',
      type: GridItemType.door,
      icon: Icons.door_front_door,
      color: Colors.orange,
      isWalkable: true,
    ),
    GridItem(
      name: 'Wall',
      type: GridItemType.wall,
      icon: Icons.wallpaper,
      color: Colors.grey,
      isWalkable: false,
    ),
    GridItem(
      name: 'Obstacle',
      type: GridItemType.obstacle,
      icon: Icons.block,
      color: Colors.black,
      isWalkable: false,
    ),
  ];

  /// Get item by type
  static GridItem? getByType(GridItemType type) {
    try {
      return availableItems.firstWhere((item) => item.type == type);
    } catch (e) {
      return null;
    }
  }
}

/// Represents a position in the grid
class GridPosition {
  final int row;
  final int col;

  const GridPosition(this.row, this.col);

  /// Get distance to another position
  double distanceTo(GridPosition other) {
    return ((row - other.row) * (row - other.row) + 
            (col - other.col) * (col - other.col)).toDouble();
  }

  /// Get manhattan distance to another position
  int manhattanDistanceTo(GridPosition other) {
    return (row - other.row).abs() + (col - other.col).abs();
  }

  /// Check if position is adjacent
  bool isAdjacent(GridPosition other) {
    return manhattanDistanceTo(other) == 1;
  }

  /// Get adjacent positions
  List<GridPosition> getAdjacentPositions() {
    return [
      GridPosition(row - 1, col), // up
      GridPosition(row + 1, col), // down
      GridPosition(row, col - 1), // left
      GridPosition(row, col + 1), // right
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridPosition &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'GridPosition($row, $col)';
}

/// Represents a path between two points
class GridPath {
  final List<GridPosition> positions;
  final double totalDistance;

  const GridPath({
    required this.positions,
    required this.totalDistance,
  });

  /// Check if path is valid
  bool get isValid => positions.isNotEmpty;

  /// Get path length
  int get length => positions.length;

  @override
  String toString() => 'GridPath(length: $length, distance: $totalDistance)';
}

/// Grid configuration
class GridConfig {
  final int rows;
  final int cols;
  final double cellSize;

  const GridConfig({
    required this.rows,
    required this.cols,
    this.cellSize = 60.0,
  });

  /// Get grid dimensions
  Size get gridSize => Size(cols * cellSize, rows * cellSize);

  /// Check if position is valid
  bool isValidPosition(GridPosition position) {
    return position.row >= 0 && 
           position.row < rows && 
           position.col >= 0 && 
           position.col < cols;
  }

  /// Parse grid dimensions from string (e.g., "5*5", "3*5")
  static GridConfig? parseFromString(String input) {
    try {
      final parts = input.split('*');
      if (parts.length != 2) return null;
      
      final rows = int.parse(parts[0].trim());
      final cols = int.parse(parts[1].trim());
      
      if (rows <= 0 || cols <= 0) return null;
      if (rows > 50 || cols > 50) return null; // Reasonable limits
      
      return GridConfig(rows: rows, cols: cols);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() => 'GridConfig($rows x $cols)';
}

/// Represents a design item in a saved design
class DesignItem {
  final String name;
  final GridItemType type;
  final IconData icon;
  final Color color;
  final int row;
  final int col;
  final double rotation;

  const DesignItem({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    required this.row,
    required this.col,
    this.rotation = 0.0,
  });

  factory DesignItem.fromMap(Map<String, dynamic> map) {
    return DesignItem(
      name: map['name'] ?? '',
      type: GridItemType.values[map['type'] ?? 0],
      icon: IconData(map['icon'] ?? 0, fontFamily: 'MaterialIcons'),
      color: Color(map['color'] ?? 0xFF000000),
      row: map['row'] ?? 0,
      col: map['col'] ?? 0,
      rotation: (map['rotation'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.index,
      'icon': icon.codePoint,
      'color': color.value,
      'row': row,
      'col': col,
      'rotation': rotation,
    };
  }

  @override
  String toString() => 'DesignItem($name at $row,$col)';
}

/// Represents a complete design that can be saved and loaded
class Design {
  final String id;
  final String name;
  final String description;
  final int rows;
  final int cols;
  final List<DesignItem> items;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Design({
    required this.id,
    required this.name,
    required this.description,
    required this.rows,
    required this.cols,
    required this.items,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Design.fromMap(Map<String, dynamic> map, String id) {
    return Design(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      rows: map['rows'] ?? 0,
      cols: map['cols'] ?? 0,
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => DesignItem.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'rows': rows,
      'cols': cols,
      'items': items.map((item) => item.toMap()).toList(),
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  @override
  String toString() => 'Design($name: ${rows}x$cols, ${items.length} items)';
}