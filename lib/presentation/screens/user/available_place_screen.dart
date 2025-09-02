import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/blocs/auth_bloc.dart';
import '../../../core/blocs/language_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/grid_models.dart';
import '../../../core/models/city_model.dart';
import '../../../core/services/design_service.dart';
import '../../../core/services/city_service.dart';
import '../../../core/services/user_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
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
  
  // City filtering state
  String? _selectedCity;
  List<City> _cities = [];
  bool _isLoadingCities = false;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadUserCityPreference();
  }

  void _loadAdminDesigns() {
    print('Loading admin designs for city: $_selectedCity');
    
    // Ensure loading state is true when starting to load
    setState(() {
      _isLoading = true;
    });
    
    // Add a timeout to prevent loading from getting stuck
    Future.delayed(const Duration(seconds: 10), () {
      if (_isLoading) {
        print('Loading timeout - setting loading to false');
        setState(() {
          _isLoading = false;
          _isInitialLoad = false;
        });
      }
    });
    
    DesignService.getAdminDesignsByCity(_selectedCity).listen((designs) {
      print('Received ${designs.length} admin designs');
      print('Designs: ${designs.map((p) => '${p.name} (${p.createdBy}) - City: ${p.city}').toList()}');
      
      // Debug: Show city distribution
      final cityCounts = <String, int>{};
      for (final design in designs) {
        final city = design.city ?? 'No City';
        cityCounts[city] = (cityCounts[city] ?? 0) + 1;
      }
      print('City distribution: $cityCounts');
      
      setState(() {
        _places = designs;
        _isLoading = false;
        _isInitialLoad = false;
      });
      
      // Load admin names for each design
      _loadAdminNames(designs);
    }, onError: (error) {
      print('Error loading admin designs: $error');
      setState(() {
        _isLoading = false;
        _isInitialLoad = false;
      });
    });
  }

  void _loadCities() async {
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
      print('Error loading cities: $e');
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  void _loadUserCityPreference() async {
    try {
      final userCity = await UserService.getUserCity(widget.userData.id);
      setState(() {
        _selectedCity = userCity;
      });
      print('Loaded user city preference: $userCity');
      
      // Add a small delay to ensure smooth loading
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Load designs after setting the city preference
      _loadAdminDesigns();
    } catch (e) {
      print('Error loading user city: $e');
      // Load all designs if city preference fails to load
      _loadAdminDesigns();
    }
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
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        // Force rebuild when language changes
        final currentLocale = languageState is LanguageLoaded 
            ? languageState.locale 
            : const Locale('tr', 'TR');
        
        final l10n = AppLocalizations.of(context)!;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.availablePlaces),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _loadUserCityPreference();
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
                  // City Filter Section
                  _buildCityFilter(),
                  const SizedBox(height: 16),

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
                        l10n.availableDesigns,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                                        Text(
                    _selectedCity != null 
                        ? '${_places.length} designs in $_selectedCity'
                        : l10n.designsCount(_places.length),
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
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  _isInitialLoad 
                                      ? 'Loading your places...' 
                                      : 'Loading places...',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
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
      },
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    
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
            l10n.noDesignsAvailable,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noDesignsDescription,
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
    final l10n = AppLocalizations.of(context)!;
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
                              l10n.createdBy(adminName),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        if (place.city != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.location_city,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                place.city!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.blue[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                    label: l10n.itemsCount(place.items.length),
                  ),
                  if (place.city != null) ...[
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      icon: Icons.location_city,
                      label: place.city!,
                    ),
                  ],
                  const Spacer(),
                  Text(
                    l10n.createdOn(_formatDate(place.createdAt)),
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

  /// Get a valid selected city that exists in the cities list
  String? _getValidSelectedCity() {
    if (_selectedCity == null) return null;
    
    // Check if the selected city exists in the cities list
    final cityExists = _cities.any((city) => city.name == _selectedCity);
    
    if (cityExists) {
      return _selectedCity;
    } else {
      // If the selected city doesn't exist in the list, return null
      print('Selected city "$_selectedCity" not found in cities list, resetting to null');
      return null;
    }
  }

  Widget _buildCityFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_city,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Filter by City',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_selectedCity != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Auto-selected',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _isLoadingCities
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Loading cities...',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : DropdownButtonFormField<String>(
                        value: _getValidSelectedCity(),
                        decoration: InputDecoration(
                          hintText: 'All Cities',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Cities'),
                          ),
                          ..._cities.map((city) => DropdownMenuItem<String>(
                            value: city.name,
                            child: Text(city.name),
                          )),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCity = newValue;
                            _isLoading = true;
                          });
                          _loadAdminDesigns();
                        },
                      ),
              ),
              const SizedBox(width: 8),
              if (_selectedCity != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedCity = null;
                      _isLoading = true;
                    });
                    _loadAdminDesigns();
                  },
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear Filter',
                ),
            ],
          ),
          if (_isLoadingCities)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Loading cities...'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
