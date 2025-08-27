import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../../../core/utils/accessibility_utils.dart';
import '../../../core/services/accessibility_service.dart';
import '../../../core/widgets/accessible_widgets.dart';

class AccessibilitySettingsScreen extends AccessibleScreen {
  const AccessibilitySettingsScreen({super.key});

  @override
  String get screenName => 'Accessibility Settings';

  @override
  String get screenDescription => 'Customize accessibility features for your needs';

  @override
  State<AccessibilitySettingsScreen> createState() => _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState extends State<AccessibilitySettingsScreen>
    with AccessibleScreenMixin, AccessibleButtonMixin, AccessibleFormFieldMixin {
  
  // Accessibility feature toggles
  bool _screenReaderEnabled = true;
  bool _voiceGuidanceEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _highContrastEnabled = false;
  bool _largeTextEnabled = false;
  bool _reducedMotionEnabled = false;
  bool _colorBlindnessSupport = false;
  
  // Slider values
  double _fontSize = 1.0;
  double _contrastLevel = 1.0;
  double _magnificationLevel = 1.0;
  double _speechRate = 1.0;
  double _volumeLevel = 0.8;
  
  // Selected options
  String _selectedTheme = 'System';
  String _selectedLanguage = 'English';
  String _selectedColorBlindnessType = 'Protanopia';
  String _selectedVoiceType = 'Default';

  @override
  Widget buildAccessibleContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AccessibilityService.announceNavigation(context, 'Accessibility Settings', 'Previous Screen');
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Reader Section
            _buildSectionHeader('Screen Reader & Voice', Icons.record_voice_over),
            _buildToggleSetting(
              'Screen Reader',
              'Enable screen reader for navigation',
              _screenReaderEnabled,
              (value) {
                setState(() => _screenReaderEnabled = value);
                AccessibilityService.announceScreenReaderState(context, value ? 'enabled' : 'disabled');
              },
            ),
            _buildToggleSetting(
              'Voice Guidance',
              'Enable voice guidance for actions',
              _voiceGuidanceEnabled,
              (value) {
                setState(() => _voiceGuidanceEnabled = value);
                AccessibilityService.announceVoiceGuidanceState(context, value ? 'enabled' : 'disabled');
              },
            ),
            _buildSliderSetting(
              'Speech Rate',
              'Adjust how fast the voice speaks',
              _speechRate,
              0.5,
              2.0,
              (value) {
                setState(() => _speechRate = value);
                AccessibilityService.announceSettingChange(context, 'speech rate', '${(value * 100).round()}%');
              },
            ),
            _buildDropdownSetting(
              'Voice Type',
              'Choose voice type for guidance',
              _selectedVoiceType,
              ['Default', 'Male', 'Female', 'Child'],
              (value) {
                setState(() => _selectedVoiceType = value);
                AccessibilityService.announceSettingChange(context, 'voice type', value);
              },
            ),

            const SizedBox(height: 24),

            // Visual Accessibility Section
            _buildSectionHeader('Visual Accessibility', Icons.visibility),
            _buildToggleSetting(
              'High Contrast',
              'Enable high contrast mode',
              _highContrastEnabled,
              (value) {
                setState(() => _highContrastEnabled = value);
                AccessibilityService.announceContrastChange(context, value ? 'high' : 'normal');
              },
            ),
            _buildToggleSetting(
              'Large Text',
              'Enable large text mode',
              _largeTextEnabled,
              (value) {
                setState(() => _largeTextEnabled = value);
                AccessibilityService.announceFontSizeChange(context, value ? 'large' : 'normal');
              },
            ),
            _buildSliderSetting(
              'Font Size',
              'Adjust text size for better readability',
              _fontSize,
              0.8,
              2.0,
              (value) {
                setState(() => _fontSize = value);
                AccessibilityService.announceFontSizeChange(context, '${(value * 100).round()}%');
              },
            ),
            _buildSliderSetting(
              'Contrast Level',
              'Adjust contrast for better visibility',
              _contrastLevel,
              0.5,
              2.0,
              (value) {
                setState(() => _contrastLevel = value);
                AccessibilityService.announceContrastChange(context, '${(value * 100).round()}%');
              },
            ),
            _buildToggleSetting(
              'Color Blindness Support',
              'Enable color blindness support',
              _colorBlindnessSupport,
              (value) {
                setState(() => _colorBlindnessSupport = value);
                if (value) {
                  AccessibilityService.announceColorBlindnessSupport(context, _selectedColorBlindnessType);
                } else {
                  AccessibilityService.announceForAccessibility(context, 'Color blindness support disabled');
                }
              },
            ),
            if (_colorBlindnessSupport)
              _buildDropdownSetting(
                'Color Blindness Type',
                'Select your color blindness type',
                _selectedColorBlindnessType,
                ['Protanopia', 'Deuteranopia', 'Tritanopia', 'Achromatopsia'],
                (value) {
                  setState(() => _selectedColorBlindnessType = value);
                  AccessibilityService.announceColorBlindnessSupport(context, value);
                },
              ),

            const SizedBox(height: 24),

            // Magnification Section
            _buildSectionHeader('Magnification', Icons.zoom_in),
            _buildSliderSetting(
              'Magnification Level',
              'Adjust magnification for better viewing',
              _magnificationLevel,
              1.0,
              5.0,
              (value) {
                setState(() => _magnificationLevel = value);
                AccessibilityService.announceMagnificationLevel(context, '${(value * 100).round()}%');
              },
            ),

            const SizedBox(height: 24),

            // Haptic & Sound Section
            _buildSectionHeader('Haptic & Sound', Icons.vibration),
            _buildToggleSetting(
              'Haptic Feedback',
              'Enable haptic feedback for actions',
              _hapticFeedbackEnabled,
              (value) {
                setState(() => _hapticFeedbackEnabled = value);
                AccessibilityService.announceHapticState(context, value ? 'enabled' : 'disabled');
              },
            ),
            _buildToggleSetting(
              'Sound Effects',
              'Enable sound effects for actions',
              _soundEnabled,
              (value) {
                setState(() => _soundEnabled = value);
                AccessibilityService.announceSoundState(context, value ? 'enabled' : 'disabled');
              },
            ),
            if (_soundEnabled)
              _buildSliderSetting(
                'Volume Level',
                'Adjust sound volume',
                _volumeLevel,
                0.0,
                1.0,
                (value) {
                  setState(() => _volumeLevel = value);
                  AccessibilityService.announceSettingChange(context, 'volume', '${(value * 100).round()}%');
                },
              ),
            _buildToggleSetting(
              'Vibration',
              'Enable vibration for notifications',
              _vibrationEnabled,
              (value) {
                setState(() => _vibrationEnabled = value);
                AccessibilityService.announceVibrationState(context, value ? 'enabled' : 'disabled');
              },
            ),

            const SizedBox(height: 24),

            // Motion & Animation Section
            _buildSectionHeader('Motion & Animation', Icons.animation),
            _buildToggleSetting(
              'Reduced Motion',
              'Reduce motion and animations',
              _reducedMotionEnabled,
              (value) {
                setState(() => _reducedMotionEnabled = value);
                AccessibilityService.announceAnimationState(context, value ? 'reduced' : 'normal');
              },
            ),

            const SizedBox(height: 24),

            // Theme & Language Section
            _buildSectionHeader('Theme & Language', Icons.palette),
            _buildDropdownSetting(
              'Theme',
              'Choose your preferred theme',
              _selectedTheme,
              ['System', 'Light', 'Dark', 'High Contrast'],
              (value) {
                setState(() => _selectedTheme = value);
                AccessibilityService.announceThemeChange(context, value);
              },
            ),
            _buildDropdownSetting(
              'Language',
              'Choose your preferred language',
              _selectedLanguage,
              ['English', 'Spanish', 'French', 'German', 'Turkish'],
              (value) {
                setState(() => _selectedLanguage = value);
                AccessibilityService.announceLanguageChange(context, value);
              },
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: buildAccessibleButton(
                    onPressed: _resetToDefaults,
                    label: 'Reset to Defaults',
                    action: 'reset all accessibility settings to default values',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildAccessibleButton(
                    onPressed: _saveSettings,
                    label: 'Save Settings',
                    action: 'save all accessibility settings',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Help & Support Section
            _buildSectionHeader('Help & Support', Icons.help),
            buildAccessibleTextButton(
              onPressed: _showAccessibilityHelp,
              label: 'Accessibility Help',
              action: 'get help with accessibility features',
            ),
            const SizedBox(height: 8),
            buildAccessibleTextButton(
              onPressed: _contactSupport,
              label: 'Contact Support',
              action: 'contact accessibility support team',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Semantics(
      header: true,
      label: '$title section',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Semantics(
              label: '$title icon',
              child: Icon(icon, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSetting(String title, String description, bool value, ValueChanged<bool> onChanged) {
    return Semantics(
      label: '$title setting',
      hint: value ? '$title is enabled' : '$title is disabled',
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(description),
        value: value,
        onChanged: onChanged,
        secondary: Icon(
          value ? Icons.check_circle : Icons.radio_button_unchecked,
          color: value ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSliderSetting(String title, String description, double value, double min, double max, ValueChanged<double> onChanged) {
    return Semantics(
      label: '$title setting',
      hint: 'Adjust $title to ${(value * 100).round()}%',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleMedium),
                      Text(description, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Text(
                  '${(value * 100).round()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) * 10).round(),
            onChanged: onChanged,
            onChangeEnd: (value) {
              // Announce final value for accessibility
              AccessibilityService.announceSettingChange(context, title.toLowerCase(), '${(value * 100).round()}%');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(String title, String description, String value, List<String> options, ValueChanged<String> onChanged) {
    return Semantics(
      label: '$title setting',
      hint: 'Current selection: $value',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(description, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetToDefaults() {
    AccessibilityService.announceForAccessibility(context, 'Resetting accessibility settings to defaults');
    setState(() {
      _screenReaderEnabled = true;
      _voiceGuidanceEnabled = true;
      _hapticFeedbackEnabled = true;
      _soundEnabled = true;
      _vibrationEnabled = true;
      _highContrastEnabled = false;
      _largeTextEnabled = false;
      _reducedMotionEnabled = false;
      _colorBlindnessSupport = false;
      _fontSize = 1.0;
      _contrastLevel = 1.0;
      _magnificationLevel = 1.0;
      _speechRate = 1.0;
      _volumeLevel = 0.8;
      _selectedTheme = 'System';
      _selectedLanguage = 'English';
      _selectedColorBlindnessType = 'Protanopia';
      _selectedVoiceType = 'Default';
    });
    AccessibilityService.announceSuccess(context, 'Settings reset');
  }

  void _saveSettings() {
    AccessibilityService.announceForAccessibility(context, 'Saving accessibility settings');
    // Here you would typically save the settings to persistent storage
    // For now, we'll just announce success
    AccessibilityService.announceSuccess(context, 'Settings saved');
    
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings Saved'),
        content: const Text('Your accessibility settings have been saved successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAccessibilityHelp() {
    AccessibilityService.announceForAccessibility(context, 'Opening accessibility help');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accessibility Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Here are some tips for using accessibility features:'),
              SizedBox(height: 16),
              Text('• Use the screen reader to navigate through the app'),
              Text('• Adjust font size and contrast for better visibility'),
              Text('• Enable haptic feedback for tactile confirmation'),
              Text('• Use voice guidance for hands-free operation'),
              Text('• Customize theme and language preferences'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    AccessibilityService.announceForAccessibility(context, 'Opening support contact information');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help with accessibility features?'),
            SizedBox(height: 16),
            Text('Email: accessibility@brightway.com'),
            Text('Phone: +1-800-ACCESS'),
            Text('Hours: Monday-Friday, 9 AM - 6 PM EST'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
