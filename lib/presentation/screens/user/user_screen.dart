import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/blocs/auth_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/grid_models.dart';
import '../../../core/services/design_service.dart';
import '../../../core/constants/app_constants.dart';
import 'place_viewer_screen.dart';

class UserScreen extends StatefulWidget {
  final UserModel userData;

  const UserScreen({
    super.key,
    required this.userData,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<Design> _places = [];
  bool _isLoading = true;
  Map<String, String> _adminNames = {};
  Map<String, String> _displayNames = {};

  @override
  void initState() {
    super.initState();
    _loadAdminDesigns();
  }

  void _loadAdminDesigns() {
    print('Loading admin designs...');
    
    DesignService.getAdminDesigns().listen((designs) {
      print('Received ${designs.length} admin designs');
      print('Designs: ${designs.map((p) => '${p.name} (${p.createdBy})').toList()}');
      
      setState(() {
        _places = designs;
        _isLoading = false;
      });
      
      // Load admin names for each design
      _loadAdminNames(designs);
    }, onError: (error) {
      print('Error loading admin designs: $error');
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _loadAdminNames(List<Design> places) async {
    final adminNames = <String, String>{};
    
    for (final place in places) {
      if (!adminNames.containsKey(place.createdBy)) {
        final adminName= await DesignService.getAdminDisplayName(place.createdBy);
        adminNames[place.createdBy] = adminName;
      }
    }
    
    setState(() {
      _adminNames = adminNames;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Places'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadAdminDesigns();
            },
            tooltip: 'Refresh Designs',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
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
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.place,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Discover Amazing Places!',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                                                             Text(
                                 'Browse designs created by our community admins',
                                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                   color: Colors.white.withOpacity(0.9),
                                 ),
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

              // Available Places Section
              Row(
                children: [
                  Icon(
                    Icons.place,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                                     Text(
                     'Available Designs',
                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                  const Spacer(),
                                     Text(
                     '${_places.length} designs',
                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                       color: Colors.grey[600],
                     ),
                   ),
                ],
              ),
              const SizedBox(height: 16),

              // Places List
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _places.isEmpty
                        ? _buildEmptyState()
                        : _buildPlacesList(),
              ),
            ],
          ),
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
            Icons.place_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
                     Text(
             'No Designs Available',
             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
               color: Colors.grey[600],
             ),
           ),
           const SizedBox(height: 8),
           Text(
             'Admins haven\'t created any designs yet.\nCheck back later!',
             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
               color: Colors.grey[500],
             ),
             textAlign: TextAlign.center,
           ),
        ],
      ),
    );
  }

  Widget _buildPlacesList() {
    return ListView.builder(
      itemCount: _places.length,
      itemBuilder: (context, index) {
        final place = _places[index];
        return _buildPlaceCard(place);
      },
    );
  }

  Widget _buildPlaceCard(Design place) {
    final adminName = _adminNames[place.createdBy] ?? 'Loading...';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _viewPlaceDetails(place),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.place,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          place.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Created by: $adminName',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
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
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.grid_on,
                    label: '${place.rows}×${place.cols}',
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.abc_sharp,
                    label: '${place.items.length} items',
                  ),
                  const Spacer(),
                  Text(
                    'Created ${_formatDate(place.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _viewPlaceDetails(Design place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceViewerScreen(design: place),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
