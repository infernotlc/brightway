import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/grid_models.dart';
import '../../../core/services/design_service.dart';
import '../../../core/widgets/accessible_widgets.dart';
import '../../../core/blocs/auth_bloc.dart';

class PlaceDesignerScreen extends AccessibleScreen {
  const PlaceDesignerScreen({super.key});

  @override
  String get screenName => 'Place Designer';

  @override
  String get screenDescription => 'Design grid-based places with furniture and save to database';

  @override
  State<PlaceDesignerScreen> createState() => _PlaceDesignerScreenState();
}

class _PlaceDesignerScreenState extends State<PlaceDesignerScreen>
    with AccessibleScreenMixin, AccessibleButtonMixin, AccessibleFormFieldMixin {

  // Grid configuration
  GridConfig? _gridConfig;
  List<List<GridCell>> _grid = [];

  // Selected items and states
  GridItem? _selectedItem;

  // UI state
  final _gridSizeController = TextEditingController();
  final _gridSizeFormKey = GlobalKey<FormState>();
  final _designNameController = TextEditingController();
  final _designDescriptionController = TextEditingController();

  // Save dialog state
  bool _isSaving = false;
  bool _isLoading = false;

  // Current design state
  String? _currentDesignId;
  List<Design> _userDesigns = [];

  @override
  void initState() {
    super.initState();
    _gridSizeController.text = '5*5'; // Default grid size
    _designNameController.text = 'My Design';
    _designDescriptionController.text = 'A custom place design';
    _loadUserDesigns();
  }

  @override
  void dispose() {
    _gridSizeController.dispose();
    _designNameController.dispose();
    _designDescriptionController.dispose();
    super.dispose();
  }

  /// Load user's existing designs
  void _loadUserDesigns() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final userId = authState.user.uid;
      DesignService.getUserDesigns(userId).listen((designs) {
        setState(() {
          _userDesigns = designs;
        });
        
        // Auto-load design if there's only one
        if (designs.length == 1) {
          _loadDesign(designs.first);
        }
      });
    }
  }

  /// Get current user ID from authentication
  String? get _currentUserId {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      return authState.user.uid;
    }
    return null;
  }

  @override
  Widget buildAccessibleContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Designer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_grid.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _showSaveDialog,
              tooltip: 'Save Design',
            ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _showLoadDesignDialog,
            tooltip: 'Load Design',
          ),
        ],
      ),
      body: Column(
        children: [
          // Grid Size Input Section
          _buildGridSizeSection(),

          // Toolbar Section
          if (_grid.isNotEmpty) _buildToolbarSection(),

          // Grid Display Section
          Expanded(
            child: _grid.isEmpty
                ? _buildEmptyState()
                : _buildGridSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridSizeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _gridSizeFormKey,
        child: Row(
          children: [
            Expanded(
              child: buildAccessibleTextFormField(
                controller: _gridSizeController,
                label: 'Grid Size',
                hint: 'Enter grid size (e.g., 5*5, 3*5)',
                validationRule: 'Format: rows*columns (e.g., 5*5)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter grid size';
                  }
                  if (GridConfig.parseFromString(value) == null) {
                    return 'Invalid format. Use: rows*columns (e.g., 5*5)';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            buildAccessibleButton(
              onPressed: _createGrid,
              label: 'Create Grid',
              action: 'create new grid with specified dimensions',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Design Mode',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_currentDesignId != null)
                Text(
                  'Editing: ${_designNameController.text}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Item Selection
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: GridItems.availableItems.map((item) {
              final isSelected = _selectedItem?.type == item.type;
              return _buildItemSelector(item, isSelected);
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Instructions
          Text(
            'Tap cells to place items, long press to remove items',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Clear All Button
          if (_grid.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearAllItems,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear All Items'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildItemSelector(GridItem item, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectItem(item),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? item.color : Colors.white,
          border: Border.all(
            color: isSelected ? item.color : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: isSelected ? Colors.white : item.color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item.name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.grid_on,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Grid Created',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter grid dimensions and click "Create Grid" to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (_userDesigns.isNotEmpty)
            ElevatedButton.icon(
              onPressed: _showLoadDesignDialog,
              icon: const Icon(Icons.folder_open),
              label: const Text('Load Existing Design'),
            ),
        ],
      ),
    );
  }

  Widget _buildGridSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(_grid.length, (row) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_grid[row].length, (col) {
                  return _buildGridCell(row, col);
                }),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildGridCell(int row, int col) {
    final cell = _grid[row][col];
    final position = GridPosition(row, col);

    return GestureDetector(
      onTap: () => _handleCellTap(position),
      onLongPress: () => _handleCellLongPress(position),
      child: Container(
        width: _gridConfig!.cellSize,
        height: _gridConfig!.cellSize,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: cell.cellColor,
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
          ),
        ),
        child: _buildCellContent(cell),
      ),
    );
  }

  Widget _buildCellContent(GridCell cell) {
    if (cell.item != null) {
      return Transform.rotate(
        angle: cell.item!.rotation * 3.14159 / 180,
        child: Icon(
          cell.item!.icon,
          color: Colors.white,
          size: 24,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // Event Handlers
  void _createGrid() {
    if (!_gridSizeFormKey.currentState!.validate()) return;

    final config = GridConfig.parseFromString(_gridSizeController.text);
    if (config == null) return;

    setState(() {
      _gridConfig = config;
      _grid = List.generate(
        config.rows,
            (row) => List.generate(
          config.cols,
              (col) => GridCell(row: row, col: col),
        ),
      );
      // Reset current design when creating new grid
      _currentDesignId = null;
      _designNameController.text = 'My Design';
      _designDescriptionController.text = 'A custom place design';
    });
  }

  void _selectItem(GridItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

  void _handleCellTap(GridPosition position) {
    if (_grid.isEmpty || _selectedItem == null) return;

    setState(() {
      _grid[position.row][position.col].item = _selectedItem!.clone();
    });
  }

  void _handleCellLongPress(GridPosition position) {
    if (_grid.isEmpty) return;

    setState(() {
      _grid[position.row][position.col].item = null;
    });
  }

  /// Show dialog to load existing designs
  void _showLoadDesignDialog() {
    if (_userDesigns.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No saved designs found'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Load Design'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _userDesigns.length,
            itemBuilder: (context, index) {
              final design = _userDesigns[index];
              return ListTile(
                leading: Icon(Icons.grid_on, color: Colors.blue.shade600),
                title: Text(design.name),
                subtitle: Text('${design.rows}x${design.cols} - ${design.description}'),
                onTap: () {
                  Navigator.pop(context);
                  _loadDesign(design);
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

  /// Load a design into the grid
  void _loadDesign(Design design) {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create grid with design dimensions
      _gridConfig = GridConfig(rows: design.rows, cols: design.cols);
      _grid = List.generate(
        design.rows,
        (row) => List.generate(
          design.cols,
          (col) => GridCell(row: row, col: col),
        ),
      );

      // Place items from design
      for (final item in design.items) {
        if (item.row < design.rows && item.col < design.cols) {
          final gridItem = GridItem(
            name: item.name,
            type: item.type,
            icon: item.icon,
            color: item.color,
            rotation: item.rotation,
          );
          _grid[item.row][item.col].item = gridItem;
        }
      }

      // Update UI state
      _currentDesignId = design.id;
      _designNameController.text = design.name;
      _designDescriptionController.text = design.description;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Design "${design.name}" loaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load design: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentDesignId != null ? 'Update Design' : 'Save Design'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildAccessibleTextFormField(
              controller: _designNameController,
              label: 'Design Name',
              hint: 'Enter a name for your design',
              validationRule: 'Design name is required',
            ),
            const SizedBox(height: 16),
            buildAccessibleTextFormField(
              controller: _designDescriptionController,
              label: 'Description',
              hint: 'Enter a description for your design',
              validationRule: 'Description is required',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isSaving ? null : _saveDesign,
            child: _isSaving
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Text(_currentDesignId != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveDesign() async {
    if (_designNameController.text.trim().isEmpty ||
        _designDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userId = _currentUserId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not authenticated'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (_currentDesignId != null) {
        // Update existing design
        await DesignService.updateUserDesign(
          userId,
          _currentDesignId!,
          {
            'name': _designNameController.text.trim(),
            'description': _designDescriptionController.text.trim(),
            'rows': _gridConfig!.rows,
            'cols': _gridConfig!.cols,
            'items': _gridToDesignItems(),
            'updatedAt': DateTime.now(),
          },
        );

        Navigator.pop(context); // Close save dialog

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Design updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Save new design
        final designId = await DesignService.saveDesign(
          name: _designNameController.text.trim(),
          description: _designDescriptionController.text.trim(),
          rows: _gridConfig!.rows,
          cols: _gridConfig!.cols,
          grid: _grid,
          createdBy: userId,
        );

        setState(() {
          _currentDesignId = designId;
        });

        Navigator.pop(context); // Close save dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Design saved successfully! ID: $designId'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save design: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  /// Convert current grid to design items for saving
  List<Map<String, dynamic>> _gridToDesignItems() {
    final items = <Map<String, dynamic>>[];
    
    for (int row = 0; row < _grid.length; row++) {
      for (int col = 0; col < _grid[row].length; col++) {
        final cell = _grid[row][col];
        if (cell.item != null) {
          items.add({
            'name': cell.item!.name,
            'type': cell.item!.type.index,
            'icon': cell.item!.icon.codePoint,
            'color': cell.item!.color.value,
            'row': row,
            'col': col,
            'rotation': cell.item!.rotation,
          });
        }
      }
    }
    
    return items;
  }

  /// Clear all items from the grid
  void _clearAllItems() {
    if (_grid.isEmpty) return;

    setState(() {
      _grid = List.generate(
        _gridConfig!.rows,
        (row) => List.generate(
          _gridConfig!.cols,
          (col) => GridCell(row: row, col: col),
        ),
      );
    });
  }
}