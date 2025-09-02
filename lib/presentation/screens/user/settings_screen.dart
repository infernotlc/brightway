import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/blocs/auth_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/city_model.dart';
import '../../../core/services/city_service.dart';
import '../../../core/services/user_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/blocs/language_bloc.dart';

class SettingsScreen extends StatefulWidget {
  final UserModel userData;

  const SettingsScreen({
    super.key,
    required this.userData,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'tr'; // Default to Turkish
  bool _isLoading = false;
  FlutterTts _flutterTts = FlutterTts();
  
  // City selection state
  String? _selectedCity;
  List<City> _cities = [];
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _loadCities();
    _loadUserCity();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCurrentLanguage();
  }

  void _loadCurrentLanguage() {
    // Load the current language from the context
    final currentLocale = Localizations.localeOf(context);
    setState(() {
      _selectedLanguage = currentLocale.languageCode;
    });
  }

  void _initializeTTS() async {
    await _flutterTts.setLanguage('tr-TR');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
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

  void _loadUserCity() async {
    try {
      final userCity = await UserService.getUserCity(widget.userData.id);
      setState(() {
        _selectedCity = userCity;
      });
    } catch (e) {
      print('Error loading user city: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Settings Header
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
                            Icons.settings,
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
                                l10n.settingsTitle,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                l10n.settingsSubtitle,
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
              const SizedBox(height: 32),

              // Language Section
              Text(
                l10n.languageSection,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Language Options
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildLanguageOption(
                      context,
                      title: 'Türkçe',
                      subtitle: 'Turkish',
                      flag: '🇹🇷',
                      value: 'tr',
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildLanguageOption(
                      context,
                      title: 'English',
                      subtitle: 'İngilizce',
                      flag: '🇺🇸',
                      value: 'en',
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // City Section
              Text(
                'City Preference',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // City Selection
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                            'Select Your City',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_isLoadingCities)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        DropdownButtonFormField<String>(
                          value: _getValidSelectedCity(),
                          decoration: InputDecoration(
                            hintText: 'Choose your city',
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
                              child: Text('No city selected'),
                            ),
                            ..._cities.map((city) => DropdownMenuItem<String>(
                              value: city.name,
                              child: Text(city.name),
                            )),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCity = newValue;
                            });
                          },
                        ),
                      if (_selectedCity != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Selected: $_selectedCity',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _applyChanges,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          l10n.applyChanges,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Info Text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade600,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.languageChangeInfo,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String flag,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = groupValue == value;
    
    return RadioListTile<String>(
      title: Row(
        children: [
          Text(
            flag,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      activeColor: Theme.of(context).primaryColor,
    );
  }

  Future<void> _applyChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Change the app locale
      await _changeAppLocale();
      
      // Change TTS language
      await _changeTTSLanguage();
      
      // Save city preference
      await _saveCityPreference();
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _selectedLanguage == 'tr' 
                ? 'Ayarlar başarıyla kaydedildi' 
                : 'Settings saved successfully'
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Navigate back to main screen
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _selectedLanguage == 'tr' 
                ? 'Ayarlar kaydedilirken hata oluştu: $e' 
                : 'Error saving settings: $e'
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _changeAppLocale() async {
    try {
      final languageBloc = context.read<LanguageBloc>();
      final newLocale = _selectedLanguage == 'tr' 
          ? const Locale('tr', 'TR') 
          : const Locale('en', 'US');
      
      languageBloc.add(LanguageChanged(newLocale));
      
      // Wait a bit for the bloc to process the change
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      print('Error changing app locale: $e');
      rethrow;
    }
  }

  Future<void> _changeTTSLanguage() async {
    try {
      if (_selectedLanguage == 'tr') {
        await _flutterTts.setLanguage('tr-TR');
        await _flutterTts.speak('Dil Türkçe olarak ayarlandı');
      } else {
        await _flutterTts.setLanguage('en-US');
        await _flutterTts.speak('Language set to English');
      }
    } catch (e) {
      print('Error changing TTS language: $e');
      // Don't throw here, as TTS failure shouldn't prevent language change
    }
  }

  Future<void> _saveCityPreference() async {
    try {
      if (_selectedCity != null) {
        await UserService.updateUserCity(widget.userData.id, _selectedCity!);
        print('City preference saved: $_selectedCity');
      }
    } catch (e) {
      print('Error saving city preference: $e');
      rethrow;
    }
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
}
