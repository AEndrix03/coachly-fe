import 'package:coachly/core/error/failures.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .login(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Listen to the auth provider for side-effects like navigation or snackbars
    ref.listen(authProvider, (previous, next) {
      if (next is AsyncError) {
        final error = next.error;
        final message = error is Failure
            ? error.message
            : 'Si è verificato un errore.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: colorScheme.error),
        );
      }
      if (next is AsyncData && next.value != null) {
        // Navigate to the main app screen on successful login
        context.go('/workouts');
      }
    });

    final authState = ref.watch(authProvider);

    // --- Style for Social Login Buttons ---
    final socialButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.white54),
      padding: const EdgeInsets.symmetric(vertical: 12),
      backgroundColor: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- BACKGROUND IMAGE ---
          Image.asset(
            'assets/images/auth_page_background.jpg',
            fit: BoxFit.cover,
          ),

          // --- CONTRAST OVERLAY ---
          Container(color: Colors.black.withOpacity(0.5)),

          // --- LOGIN FORM ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),

                    // --- APP LOGO ---
                    Image.asset(
                      'assets/logos/app_logo_no_bg_dark.png',
                      height: 80,
                    ).animate().fade(duration: 900.ms).slideY(begin: -0.5),

                    const SizedBox(height: 16),

                    // --- APP TITLE ---
                    Text(
                          'Coachly',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: textTheme.displaySmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                        .animate()
                        .fade(delay: 300.ms, duration: 900.ms)
                        .slideY(begin: 0.5),

                    const SizedBox(height: 48),

                    // --- EMAIL INPUT ---
                    TextFormField(
                      controller: _emailController,
                      enabled: !authState.isLoading,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          (value == null || !value.contains('@'))
                          ? 'Please enter a valid email'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // --- PASSWORD INPUT ---
                    TextFormField(
                      controller: _passwordController,
                      enabled: !authState.isLoading,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) => (value == null || value.length < 6)
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),

                    // --- FORGOT PASSWORD ---
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: authState.isLoading ? null : () {},
                        child: const Text('Password dimenticata?'),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- LOGIN BUTTON ---
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: authState.isLoading ? null : _submitLogin,
                      child: authState.isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : const Text('Accedi'),
                    ),

                    const SizedBox(height: 24),

                    // --- SOCIAL LOGIN DIVIDER ---
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.white54)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Oppure accedi con',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.white54)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // --- SOCIAL LOGIN BUTTONS ---
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: socialButtonStyle,
                            icon: const Icon(Icons.g_mobiledata),
                            label: const Text('Google'),
                            onPressed: authState.isLoading ? null : () {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: socialButtonStyle,
                            icon: const Icon(Icons.apple),
                            label: const Text('Apple'),
                            onPressed: authState.isLoading ? null : () {},
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 3),

                    // --- REGISTRATION LINK ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Non hai un account?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: authState.isLoading ? null : () {},
                          child: const Text("Registrati ora"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ).animate().fade(delay: 600.ms, duration: 900.ms),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
