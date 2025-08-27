import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/semantics.dart';
import '../../../core/blocs/auth_bloc.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/accessibility_utils.dart';
import '../../../core/services/accessibility_service.dart';
import '../../../core/widgets/accessible_widgets.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends AccessibleScreen {
  const LoginScreen({super.key});

  @override
  String get screenName => 'Login Screen';

  @override
  String get screenDescription => 'Sign in to your BrightWay account with email and password';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> 
    with AccessibleScreenMixin, 
         AccessibleButtonMixin, 
         AccessibleFormFieldMixin,
         AccessibleFormValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Announce form submission for accessibility
      announceFormSubmission('login');
      
      context.read<AuthBloc>().add(
        SignInRequested(
          _emailController.text.trim(),
          _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget buildAccessibleContent() {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            setState(() => _isLoading = false);
            // Announce error for accessibility
            AccessibilityService.announceError(context, 'signing in', state.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                // Enhanced accessibility for snackbar
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          } else if (state is Authenticated) {
            setState(() => _isLoading = false);
            // Announce success for accessibility
            AccessibilityService.announceAuthStatus(context, true);
            // Navigation will be handled by the main app
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo/Title with accessibility
                  Semantics(
                    label: AccessibilityUtils.getIconLabel('BrightWay logo', context: 'Application logo'),
                    child: Icon(
                      Icons.brightness_7,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    label: AccessibilityUtils.appTitleLabel,
                    header: true,
                    child: Text(
                      AppConstants.appName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    label: AccessibilityUtils.welcomeMessageLabel,
                    child: Text(
                      'Welcome back!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email Field with accessibility
                  buildAccessibleTextFormField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email address to sign in',
                    validationRule: 'Must be a valid email address',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 16),

                  // Password Field with accessibility
                  buildAccessibleTextFormField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password to sign in',
                    validationRule: 'Must be at least 6 characters',
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: buildAccessibleIconButton(
                      icon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      label: 'Password visibility',
                      hint: 'Toggle password visibility',
                      action: 'toggle password visibility',
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                        // Announce password visibility change for accessibility
                        AccessibilityService.announcePasswordVisibility(context, _obscurePassword);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button with accessibility
                  buildAccessibleButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    label: 'Login',
                    action: 'sign in to your account',
                    child: _isLoading
                        ? Semantics(
                            label: AccessibilityUtils.loadingIndicatorLabel,
                            child: const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Forgot Password Link with accessibility
                  buildAccessibleTextButton(
                    onPressed: () {
                      // Announce navigation for accessibility
                      AccessibilityService.announceNavigation(context, 'Login', 'Forgot Password');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    label: 'Forgot Password?',
                    action: 'reset your password',
                  ),
                  const SizedBox(height: 16),

                  // Register Link with accessibility
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Semantics(
                        label: 'Question about account',
                        child: Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      buildAccessibleTextButton(
                        onPressed: () {
                          // Announce navigation for accessibility
                          AccessibilityService.announceNavigation(context, 'Login', 'Register');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        label: 'Register',
                        action: 'create a new account',
                  ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
