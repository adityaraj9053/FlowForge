import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import 'providers/auth_provider.dart';
import 'services/firebase_service.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_employee_screen.dart';
import 'screens/dashboard/manager_dashboard.dart';
import 'screens/dashboard/employee_dashboard.dart';
import 'screens/dashboard/client_dashboard.dart';
import 'screens/splash_screen.dart';
import 'screens/projects/project_form_screen.dart';
import 'screens/tasks/task_form_screen.dart';
=======
import 'business_logic/providers/auth_provider.dart';
import 'database/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'ui/auth/login_screen.dart';
import 'ui/manager/manager_workspace.dart';
import 'ui/employee/employee_workspace.dart';
import 'ui/client/client_workspace.dart';
import 'ui/auth/auth_theme.dart';
import 'ui/auth/verify_email_screen.dart';
import 'ui/splash_screen.dart';
>>>>>>> 718cc7ec2ded39f1cc39b169000c96f7e96d29d4

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseService.initialize();
    runApp(const FlowForgeApp());
  } catch (error) {
    runApp(FirebaseConfigurationApp(error: error));
  }
}

class FirebaseConfigurationApp extends StatelessWidget {
  const FirebaseConfigurationApp({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowForge setup required',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(title: const Text('FlowForge setup required')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Firebase is not configured for this app.',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Run “flutterfire configure” for your Firebase project, '
                        'then restart the application.',
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        'Startup error: $error',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FlowForgeApp extends StatelessWidget {
  const FlowForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
      ],
      child: MaterialApp(
        title: 'FlowForge',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        builder: (context, child) {
          final auth = context.watch<AuthProvider>();
          if (auth.isManager && child != null) {
            return ManagerTheme(child: child);
          }
          if (auth.isEmployee && child != null) {
            return EmployeeTheme(child: child);
          }
          if (auth.isClient && child != null) {
            return ClientTheme(child: child);
          }
          if (!auth.isManager &&
              !auth.isEmployee &&
              !auth.isClient &&
              child != null) {
            return AuthTheme(child: child);
          }
          return child ?? const SizedBox.shrink();
        },
        home: const AuthWrapper(),
      ),
    );
  }
}

typedef SprintFlowApp = FlowForgeApp;

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const SplashScreen();
        }
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }
        if (authProvider.userData == null) {
          if (authProvider.hasPendingRegistration) {
            // Signed up but email not verified yet: no database record
            // exists, so the user waits here until verification completes.
            return VerifyEmailScreen(
              email: authProvider.pendingEmail ?? '',
            );
          }
          // Authenticated but no user document resolved yet.
          return const _AccountMissingScreen();
        }
        if (!authProvider.isEmailVerified) {
          // Signed in but the email address is not verified yet.
          // No unverified (possibly mistyped) address can reach a dashboard.
          return VerifyEmailScreen(email: authProvider.userData!.email);
        }
        if (authProvider.isManager) {
          return const ManagerWorkspace();
        } else if (authProvider.isEmployee) {
          return const EmployeeWorkspace();
        } else if (authProvider.isClient) {
          return const ClientWorkspace();
        }
        return const LoginScreen();
      },
    );
  }
}

class _AccountMissingScreen extends StatelessWidget {
  const _AccountMissingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SprintFlow')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off_outlined, size: 64),
              const SizedBox(height: 16),
              const Text('Account not fully set up'),
              const SizedBox(height: 8),
              Text(
                'We could not find your profile. Please sign out and sign in again.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Consumer<AuthProvider>(
                builder:
                    (context, authProvider, child) => OutlinedButton.icon(
                      onPressed:
                          authProvider.isLoading ? null : authProvider.signOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign out'),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
