import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import '../utils/accessibility_utils.dart';
import '../services/accessibility_service.dart';

/// Mixin for creating accessible buttons
mixin AccessibleButtonMixin<T extends StatefulWidget> on State<T> {
  /// Creates an accessible button with proper semantics
  Widget buildAccessibleButton({
    required VoidCallback? onPressed,
    required String label,
    String? hint,
    String? action,
    Widget? child,
    ButtonStyle? style,
    bool isSemanticButton = true,
  }) {
    final semanticLabel = AccessibilityUtils.getButtonLabel(label, action: action);
    final semanticHint = hint ?? AccessibilityUtils.getButtonHint(action ?? 'activate');
    
    Widget button = ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child ?? Text(label),
    );
    
    if (isSemanticButton) {
      button = Semantics(
        label: semanticLabel,
        hint: semanticHint,
        button: true,
        enabled: onPressed != null,
        child: button,
      );
    }
    
    return button;
  }
  
  /// Creates an accessible text button with proper semantics
  Widget buildAccessibleTextButton({
    required VoidCallback? onPressed,
    required String label,
    String? hint,
    String? action,
    Widget? child,
    ButtonStyle? style,
    bool isSemanticButton = true,
  }) {
    final semanticLabel = AccessibilityUtils.getButtonLabel(label, action: action);
    final semanticHint = hint ?? AccessibilityUtils.getButtonHint(action ?? 'activate');
    
    Widget button = TextButton(
      onPressed: onPressed,
      style: style,
      child: child ?? Text(label),
    );
    
    if (isSemanticButton) {
      button = Semantics(
        label: semanticLabel,
        hint: semanticHint,
        button: true,
        enabled: onPressed != null,
        child: button,
      );
    }
    
    return button;
  }
  
  /// Creates an accessible icon button with proper semantics
  Widget buildAccessibleIconButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    String? hint,
    String? action,
    ButtonStyle? style,
    bool isSemanticButton = true,
  }) {
    final semanticLabel = AccessibilityUtils.getIconLabel(label, context: action);
    final semanticHint = hint ?? AccessibilityUtils.getButtonHint(action ?? 'activate');
    
    Widget button = IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: style,
    );
    
    if (isSemanticButton) {
      button = Semantics(
        label: semanticLabel,
        hint: semanticHint,
        button: true,
        enabled: onPressed != null,
        child: button,
      );
    }
    
    return button;
  }
}

/// Mixin for creating accessible form fields
mixin AccessibleFormFieldMixin<T extends StatefulWidget> on State<T> {
  /// Creates an accessible text form field with proper semantics
  Widget buildAccessibleTextFormField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? validationRule,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    FocusNode? focusNode,
    bool isSemanticField = true,
  }) {
    final semanticLabel = AccessibilityUtils.getFormFieldLabel(label);
    final semanticHint = hint ?? AccessibilityUtils.getFormFieldHint(label, validationRule: validationRule);
    
    Widget field = TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onTap: onTap,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) {
        // Announce field changes for accessibility
        if (focusNode?.hasFocus == true) {
          AccessibilityService.announceFieldFocus(context, label);
        }
      },
    );
    
    if (isSemanticField) {
      field = Semantics(
        label: semanticLabel,
        hint: semanticHint,
        textField: true,
        child: field,
      );
    }
    
    return field;
  }
  
  /// Creates an accessible text field with proper semantics
  Widget buildAccessibleTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? validationRule,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    VoidCallback? onTap,
    FocusNode? focusNode,
    bool isSemanticField = true,
  }) {
    final semanticLabel = AccessibilityUtils.getFormFieldLabel(label);
    final semanticHint = hint ?? AccessibilityUtils.getFormFieldHint(label, validationRule: validationRule);
    
    Widget field = TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onTap: onTap,
      focusNode: focusNode,
      onChanged: (value) {
        // Announce field changes for accessibility
        if (focusNode?.hasFocus == true) {
          AccessibilityService.announceFieldFocus(context, label);
        }
      },
    );
    
    if (isSemanticField) {
      field = Semantics(
        label: semanticLabel,
        hint: semanticHint,
        textField: true,
        child: field,
      );
    }
    
    return field;
  }
}

/// Mixin for creating accessible navigation elements
mixin AccessibleNavigationMixin<T extends StatefulWidget> on State<T> {
  /// Creates an accessible navigation button with proper semantics
  Widget buildAccessibleNavigationButton({
    required VoidCallback? onPressed,
    required String destination,
    String? currentLocation,
    required Widget child,
    ButtonStyle? style,
    bool isSemanticButton = true,
  }) {
    final semanticLabel = AccessibilityUtils.getNavigationLabel(destination, currentLocation: currentLocation);
    final semanticHint = AccessibilityUtils.getButtonHint('navigate to $destination');
    
    Widget button = ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
    
    if (isSemanticButton) {
      button = Semantics(
        label: semanticLabel,
        hint: semanticHint,
        button: true,
        enabled: onPressed != null,
        child: button,
      );
    }
    
    return button;
  }
  
  /// Creates an accessible navigation link with proper semantics
  Widget buildAccessibleNavigationLink({
    required VoidCallback? onPressed,
    required String destination,
    String? currentLocation,
    required Widget child,
    ButtonStyle? style,
    bool isSemanticButton = true,
  }) {
    final semanticLabel = AccessibilityUtils.getNavigationLabel(destination, currentLocation: currentLocation);
    final semanticHint = AccessibilityUtils.getButtonHint('navigate to $destination');
    
    Widget link = TextButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
    
    if (isSemanticButton) {
      link = Semantics(
        label: semanticLabel,
        hint: semanticHint,
        button: true,
        enabled: onPressed != null,
        child: link,
      );
    }
    
    return link;
  }
}

/// Mixin for creating accessible status indicators
mixin AccessibleStatusMixin<T extends StatefulWidget> on State<T> {
  /// Creates an accessible loading indicator with proper semantics
  Widget buildAccessibleLoadingIndicator({
    required String action,
    double? value,
    String? label,
    bool isSemanticIndicator = true,
  }) {
    final semanticLabel = label ?? AccessibilityUtils.getLoadingLabel(action);
    final semanticHint = value != null 
        ? AccessibilityUtils.getProgressLabel(action, value)
        : 'Loading in progress';
    
    Widget indicator = value != null
        ? LinearProgressIndicator(value: value)
        : const CircularProgressIndicator();
    
    if (isSemanticIndicator) {
      indicator = Semantics(
        label: semanticLabel,
        hint: semanticHint,
        child: indicator,
      );
    }
    
    return indicator;
  }
  
  /// Creates an accessible error message with proper semantics
  Widget buildAccessibleErrorMessage({
    required String message,
    String? context,
    bool isSemanticMessage = true,
  }) {
    final semanticLabel = AccessibilityUtils.getStatusLabel('Error', context: context);
    
    Widget errorWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
    
    if (isSemanticMessage) {
      errorWidget = Semantics(
        label: semanticLabel,
        child: errorWidget,
      );
    }
    
    return errorWidget;
  }
  
  /// Creates an accessible success message with proper semantics
  Widget buildAccessibleSuccessMessage({
    required String message,
    String? context,
    bool isSemanticMessage = true,
  }) {
    final semanticLabel = AccessibilityUtils.getStatusLabel('Success', context: context);
    
    Widget successWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.green.shade700),
            ),
          ),
        ],
      ),
    );
    
    if (isSemanticMessage) {
      successWidget = Semantics(
        label: semanticLabel,
        child: successWidget,
      );
    }
    
    return successWidget;
  }
}

/// Mixin for creating accessible list elements
mixin AccessibleListMixin<T extends StatefulWidget> on State<T> {
  /// Creates an accessible list item with proper semantics
  Widget buildAccessibleListItem({
    required Widget child,
    required String itemName,
    required int position,
    required int total,
    VoidCallback? onTap,
    bool isSelected = false,
    bool isSemanticItem = true,
  }) {
    final semanticLabel = AccessibilityUtils.getListItemLabel(itemName, position, total);
    final semanticHint = isSelected 
        ? 'Selected item. Double tap to deselect'
        : 'Double tap to select';
    
    Widget listItem = ListTile(
      title: child,
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
    );
    
    if (isSemanticItem) {
      listItem = Semantics(
        label: semanticLabel,
        hint: semanticHint,
        selected: isSelected,
        child: listItem,
      );
    }
    
    return listItem;
  }
  
  /// Creates an accessible list with proper semantics
  Widget buildAccessibleList({
    required List<Widget> children,
    required String listType,
    bool isSemanticList = true,
  }) {
    final semanticLabel = '$listType list with ${children.length} items';
    
    Widget list = ListView(
      children: children,
      padding: const EdgeInsets.all(16),
    );
    
    if (isSemanticList) {
      list = Semantics(
        label: semanticLabel,
        child: list,
      );
    }
    
    return list;
  }
}

/// Base class for accessible screens
abstract class AccessibleScreen extends StatefulWidget {
  const AccessibleScreen({super.key});
  
  /// Returns the screen name for accessibility announcements
  String get screenName;
  
  /// Returns the screen description for accessibility
  String get screenDescription;
}

/// Mixin for accessible screen state management
mixin AccessibleScreenMixin<T extends AccessibleScreen> on State<T> {
  @override
  void initState() {
    super.initState();
    // Announce screen change when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AccessibilityService.announceScreenChange(context, widget.screenName);
    });
  }
  
  @override
  void dispose() {
    // Clean up any accessibility-related resources
    super.dispose();
  }
  
  /// Builds the accessible screen content
  Widget buildAccessibleContent();
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.screenName,
      hint: widget.screenDescription,
      child: buildAccessibleContent(),
    );
  }
}

/// Base class for accessible dialogs
abstract class AccessibleDialog extends StatelessWidget {
  const AccessibleDialog({super.key});
  
  /// Returns the dialog title for accessibility
  String get dialogTitle;
  
  /// Returns the dialog description for accessibility
  String get dialogDescription;
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: dialogTitle,
      hint: dialogDescription,
      child: buildDialogContent(context),
    );
  }
  
  /// Builds the dialog content
  Widget buildDialogContent(BuildContext context);
}

/// Mixin for creating accessible form validation
mixin AccessibleFormValidationMixin<T extends StatefulWidget> on State<T> {
  /// Announces validation errors for accessibility
  void announceValidationError(String fieldName, String error) {
    AccessibilityService.announceValidationError(context, fieldName, error);
  }
  
  /// Announces successful validation for accessibility
  void announceValidationSuccess(String fieldName) {
    AccessibilityService.announceSuccess(context, '$fieldName validation');
  }
  
  /// Announces form submission for accessibility
  void announceFormSubmission(String formName) {
    AccessibilityService.announceFormSubmission(context, formName);
  }
  
  /// Announces form reset for accessibility
  void announceFormReset(String formName) {
    AccessibilityService.announceForAccessibility(context, 'Form reset to default values');
  }
}

/// Mixin for creating accessible keyboard navigation
mixin AccessibleKeyboardNavigationMixin<T extends StatefulWidget> on State<T> {
  /// Handles keyboard navigation for accessibility
  void handleKeyboardNavigation(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.tab:
          // Handle tab navigation
          AccessibilityService.announceForAccessibility(context, 'Tab navigation');
          break;
        case LogicalKeyboardKey.enter:
          // Handle enter key
          AccessibilityService.announceForAccessibility(context, 'Enter key pressed');
          break;
        case LogicalKeyboardKey.escape:
          // Handle escape key
          AccessibilityService.announceForAccessibility(context, 'Escape key pressed');
          break;
        case LogicalKeyboardKey.arrowUp:
          // Handle up arrow
          AccessibilityService.announceForAccessibility(context, 'Up arrow navigation');
          break;
        case LogicalKeyboardKey.arrowDown:
          // Handle down arrow
          AccessibilityService.announceForAccessibility(context, 'Down arrow navigation');
          break;
        case LogicalKeyboardKey.arrowLeft:
          // Handle left arrow
          AccessibilityService.announceForAccessibility(context, 'Left arrow navigation');
          break;
        case LogicalKeyboardKey.arrowRight:
          // Handle right arrow
          AccessibilityService.announceForAccessibility(context, 'Right arrow navigation');
          break;
      }
    }
  }
}
