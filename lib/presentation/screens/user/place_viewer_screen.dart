import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadAdminName();
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
            Container(
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
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              widget.design.description,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
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
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
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
            ),
            const SizedBox(height: 24),

            // Place Information
            _buildInfoSection(context),
            const SizedBox(height: 24),

            // Grid Preview
            _buildGridPreview(context),
            const SizedBox(height: 24),

            // Items List
            _buildItemsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Design Information',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.grid_on,
                title: 'Grid Size',
                value: '${widget.design.rows} × ${widget.design.cols}',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.abc,
                title: 'Total Items',
                value: '${widget.design.items.length}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.calendar_today,
                title: 'Created',
                value: _formatDate(widget.design.createdAt),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.update,
                title: 'Last Updated',
                value: _formatDate(widget.design.updatedAt),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.person,
                title: 'Created By',
                value: _adminName,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(), // Empty container for spacing
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey[600], size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGridPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Design Preview',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              // Grid visualization
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
                    final item = widget.design.items.firstWhere(
                      (item) => item.row == row && item.col == col,
                      orElse: () => DesignItem(
                        name: '',
                        type: GridItemType.wall,
                        icon: Icons.square,
                        color: Colors.transparent,
                        row: row,
                        col: col,
                      ),
                    );

                    return _buildGridCell(item);
                  },
                ),
              ),
              const SizedBox(height: 16),
                             Text(
                 'This is a preview of the design layout. Each cell represents a grid position.',
                 style: Theme.of(
                   context,
                 ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                 textAlign: TextAlign.center,
               ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridCell(DesignItem item) {
    if (item.name.isEmpty) {
      // Empty cell
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey[300]!),
        ),
      );
    }

    // Cell with item
    return Container(
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.8),
        border: Border.all(color: item.color),
      ),
      child: Transform.rotate(
        angle: item.rotation * 3.14159 / 180,
        child: Icon(item.icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildItemsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items in this Design',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (widget.design.items.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No items placed',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                                     Text(
                     'This design doesn\'t have any furniture or items yet.',
                     style: Theme.of(
                       context,
                     ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                     textAlign: TextAlign.center,
                   ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.design.items.length,
            itemBuilder: (context, index) {
              final item = widget.design.items[index];
              return _buildItemCard(item);
            },
          ),
      ],
    );
  }

  Widget _buildItemCard(DesignItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Transform.rotate(
            angle: item.rotation * 3.14159 / 180,
            child: Icon(item.icon, color: item.color, size: 24),
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Position: (${item.row + 1}, ${item.col + 1})'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${item.rotation.toInt()}°',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
