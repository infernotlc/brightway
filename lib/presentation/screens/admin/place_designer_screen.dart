import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/grid_models.dart';
import '../../../core/models/city_model.dart';
import '../../../core/services/design_service.dart';
import '../../../core/services/city_service.dart';
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
  
  // City selection state
  String? _selectedCity;
  List<City> _cities = [];
  bool _isLoadingCities = false;

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
        
        // Auto-load design if there are designs available
        if (designs.isNotEmpty) {
          // Sort by updatedAt to get the newest design first
          designs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          _loadDesign(designs.first); // Load the newest design
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
            const SizedBox(width: 8),
            if (_grid.isNotEmpty)
              ElevatedButton(
                onPressed: _clearAllItems,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Clear'),
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

          // Item Selection - Horizontal Scrollable
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: GridItems.availableItems.map((item) {
                final isSelected = _selectedItem?.type == item.type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildItemSelector(item, isSelected),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

                     // Instructions
           Text(
             'Tap cells to place items, tap placed items to rotate them, long press to remove items',
             style: Theme.of(context).textTheme.bodySmall?.copyWith(
               color: Colors.grey.shade600,
             ),
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
      return Stack(
        children: [
          // Rotated icon
          Transform.rotate(
            angle: cell.item!.rotation * 3.14159 / 180,
            child: Icon(
              cell.item!.icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          // Rotation indicator (small text showing degrees)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${cell.item!.rotation}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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
    if (_grid.isEmpty) return;

    if (_selectedItem != null) {
      // Place new item
      setState(() {
        _grid[position.row][position.col].item = _selectedItem!.clone();
        _selectedItem = null; // Clear selection after placing item
      });
    } else if (_grid[position.row][position.col].item != null) {
      // Rotate existing item by 90 degrees
      setState(() {
        final currentItem = _grid[position.row][position.col].item!;
        final newRotation = (currentItem.rotation + 90) % 360;
        _grid[position.row][position.col].item = currentItem.clone(rotation: newRotation);
      });
    }
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
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteDesign(design),
                  tooltip: 'Delete Design',
                ),
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
      _selectedCity = design.city;

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
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(_currentDesignId != null ? 'Update Design' : 'Save Design'),
            content: SingleChildScrollView(
              child: Column(
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
                  const SizedBox(height: 16),
                  // City Selection
                  _buildCitySelectionForDialog(setDialogState),
              ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              if (_currentDesignId != null)
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveAsNew,
                  child: _isSaving
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('New'),
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
          );
        },
      ),
    );
  }

  /// Save current design as a new one
  Future<void> _saveAsNew() async {
    if (_designNameController.text.trim().isEmpty ||
        _designDescriptionController.text.trim().isEmpty ||
        _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields including city selection'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check for duplicate design name - when saving as new, always require unique name
    final designName = _designNameController.text.trim();
    print('Saving as new design with name: "$designName"');
    print('Current design ID: $_currentDesignId');
    print('Available designs: ${_userDesigns.map((d) => d.name).toList()}');
    
    // For "Save as New", we need to check if the name is different from current design
    if (_currentDesignId != null) {
      final currentDesign = _userDesigns.firstWhere(
        (design) => design.id == _currentDesignId,
        orElse: () => throw Exception('Current design not found'),
      );
      
      // If trying to save as new with the same name, prevent it
      if (currentDesign.name.toLowerCase() == designName.toLowerCase()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('To save as new, please use a different name than the current design.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }
    
    // Check for duplicates with other designs
    if (_isDesignNameDuplicate(designName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A design with this name already exists. Please choose a different name.'),
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
      // Save as new design
      final designId = await DesignService.saveDesign(
        name: _designNameController.text.trim(),
        description: _designDescriptionController.text.trim(),
        rows: _gridConfig!.rows,
        cols: _gridConfig!.cols,
        grid: _grid,
        createdBy: userId,
        city: _selectedCity,
      );

      // Reset to new design mode
      setState(() {
        _currentDesignId = designId;
      });

      Navigator.pop(context); // Close save dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Design saved as new! ID: $designId'),
          backgroundColor: Colors.green,
        ),
      );
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

  Future<void> _saveDesign() async {
    if (_designNameController.text.trim().isEmpty ||
        _designDescriptionController.text.trim().isEmpty ||
        _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields including city selection'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check for duplicate design name
    final designName = _designNameController.text.trim();
    print('Saving design with name: "$designName"');
    print('Current design ID: $_currentDesignId');
    print('Available designs: ${_userDesigns.map((d) => d.name).toList()}');
    
    if (_isDesignNameDuplicate(designName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A design with this name already exists. Please choose a different name.'),
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
            'city': _selectedCity,
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
          city: _selectedCity,
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

  /// Check if design name already exists for current user
  bool _isDesignNameDuplicate(String name) {
    if (name.trim().isEmpty) return false;
    
    final trimmedName = name.trim().toLowerCase();
    print('Checking duplicate for name: "$trimmedName"');
    print('Current design ID: $_currentDesignId');
    print('Available designs: ${_userDesigns.map((d) => '${d.name} (${d.id})').toList()}');
    
    if (_currentDesignId != null) {
      // When updating, exclude current design from duplicate check
      // This allows updating with the same name
      final currentDesign = _userDesigns.firstWhere(
        (design) => design.id == _currentDesignId,
        orElse: () => throw Exception('Current design not found'),
      );
      print('Current design name: "${currentDesign.name}" (${currentDesign.id})');
      
      // If the name is exactly the same as current design, allow it
      if (currentDesign.name.toLowerCase() == trimmedName) {
        print('Update mode - Same name as current design, allowing update');
        return false;
      }
      
      // Check for duplicates with other designs
      final hasDuplicate = _userDesigns.any((design) => 
        design.name.toLowerCase() == trimmedName && 
        design.id != _currentDesignId
      );
      print('Update mode - Has duplicate with other designs: $hasDuplicate');
      return hasDuplicate;
    } else {
      // When creating new, NEVER allow duplicate names
      // Check against ALL existing designs, regardless of count
      final hasDuplicate = _userDesigns.any((design) => 
        design.name.toLowerCase() == trimmedName
      );
      print('New mode - Has duplicate: $hasDuplicate');
      return hasDuplicate;
    }
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

  /// Delete a design
  Future<void> _deleteDesign(Design design) async {
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

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the design "${design.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade100,
              foregroundColor: Colors.red.shade700,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await DesignService.deleteUserDesign(userId, design.id);
        
        // Close the load dialog to show updated list
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Design "${design.name}" deleted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // If the deleted design was the currently loaded one, clear the grid
        if (_currentDesignId == design.id) {
          setState(() {
            _currentDesignId = null;
            _gridConfig = null;
            _grid = [];
            _designNameController.text = 'My Design';
            _designDescriptionController.text = 'A custom place design';
            _selectedCity = null;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete design: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Build city selection widget for dialog
  Widget _buildCitySelectionForDialog(StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'City *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedCity = await _showCitySelectionDialog();
            print('Dialog returned: $selectedCity');
            if (selectedCity != null) {
              setDialogState(() {
                _selectedCity = selectedCity;
                print('Updated _selectedCity to: $_selectedCity');
              });
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedCity == null ? Colors.red.shade300 : Colors.grey.shade300,
                width: _selectedCity == null ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_city,
                  color: _selectedCity == null ? Colors.red.shade600 : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedCity ?? 'Select a city (required)',
                    style: TextStyle(
                      color: _selectedCity != null ? Colors.black87 : Colors.red.shade600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        if (_selectedCity != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Selected: $_selectedCity',
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setDialogState(() {
                    _selectedCity = null;
                    print('Cleared _selectedCity');
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                ),
                child: Text(
                  'Clear',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Build city selection widget
  Widget _buildCitySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'City *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedCity = await _showCitySelectionDialog();
            print('Dialog returned: $selectedCity');
            if (selectedCity != null) {
              setState(() {
                _selectedCity = selectedCity;
                print('Updated _selectedCity to: $_selectedCity');
              });
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedCity == null ? Colors.red.shade300 : Colors.grey.shade300,
                width: _selectedCity == null ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_city,
                  color: _selectedCity == null ? Colors.red.shade600 : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedCity ?? 'Select a city (required)',
                    style: TextStyle(
                      color: _selectedCity != null ? Colors.black87 : Colors.red.shade600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        if (_selectedCity != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Selected: $_selectedCity',
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCity = null;
                    print('Cleared _selectedCity');
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                ),
                child: Text(
                  'Clear',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Show city selection dialog
  Future<String?> _showCitySelectionDialog() async {
    return await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Load cities if not already loaded
          if (_cities.isEmpty && !_isLoadingCities) {
            _loadCitiesForDialog(setDialogState);
          }

          return AlertDialog(
            title: const Text('Select City'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: _isLoadingCities
                  ? const Center(child: CircularProgressIndicator())
                  : _cities.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No cities available',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () async {
                                await _loadCitiesForDialog(setDialogState);
                              },
                              child: const Text('Load Cities'),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: _cities.length,
                          itemBuilder: (context, index) {
                            final city = _cities[index];
                            final isSelected = _selectedCity == city.name;
                            return ListTile(
                              leading: Icon(
                                Icons.location_city,
                                color: isSelected ? Colors.blue : Colors.grey.shade600,
                              ),
                              title: Text(
                                city.name,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.blue : Colors.black87,
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.blue,
                                    )
                                  : null,
                              onTap: () {
                                print('Selected city: ${city.name}');
                                Navigator.pop(context, city.name);
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
          );
        },
      ),
    );
  }

  /// Load cities from API
  Future<void> _loadCities() async {
    if (_cities.isNotEmpty) return; // Already loaded

    setState(() {
      _isLoadingCities = true;
    });

    try {
      final cities = await CityService.fetchCities();
      setState(() {
        _cities = cities;
        _isLoadingCities = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCities = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cities: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Load cities for dialog with proper state management
  Future<void> _loadCitiesForDialog(StateSetter setDialogState) async {
    if (_cities.isNotEmpty) return; // Already loaded

    setDialogState(() {
      _isLoadingCities = true;
    });

    try {
      final cities = await CityService.fetchCities();
      setDialogState(() {
        _cities = cities;
        _isLoadingCities = false;
      });
    } catch (e) {
      setDialogState(() {
        _isLoadingCities = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cities: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}