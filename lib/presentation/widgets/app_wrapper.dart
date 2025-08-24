import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/auth_bloc.dart';
import '../../core/models/user_model.dart';
import '../screens/auth/login_screen.dart';
import '../screens/admin/admin_screen.dart';
import '../screens/user/user_screen.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is Authenticated) {
          return _buildAuthenticatedScreen(state.userData);
        }

        // Default to login screen
        return const LoginScreen();
      },
    );
  }

  Widget _buildAuthenticatedScreen(UserModel? userData) {
    if (userData == null) {
      return const LoginScreen();
    }

    // Role-based navigation
    if (userData.isAdmin) {
      return AdminScreen(userData: userData);
    } else {
      return UserScreen(userData: userData);
    }
  }
}
