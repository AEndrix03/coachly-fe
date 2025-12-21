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

    ref.listen(authProvider, (previous, next) {
      final authValue = next.value;
      if (authValue?.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authValue!.errorMessage!),
            backgroundColor: colorScheme.error,
          ),
        );
      }
      if (authValue?.canAccessApp == true) {
        context.go('/workouts');
      }
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState.value?.isLoading ?? false;

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
          Image.asset(
            'assets/images/auth_page_background.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Image.asset(
                        'assets/logos/app_logo_no_bg_dark.png',
                        height: 80,
                      ).animate().fade(duration: 900.ms).slideY(begin: -0.5),
                      const SizedBox(height: 16),
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
                      TextFormField(
                        controller: _emailController,
                        enabled: !isLoading,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            (value == null || !value.contains('@'))
                            ? 'Inserisci una email valida'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (value) =>
                            (value == null || value.length < 6)
                            ? 'La password deve avere almeno 6 caratteri'
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading ? null : () {},
                          child: const Text('Password dimenticata?'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: isLoading ? null : _submitLogin,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : const Text('Accedi'),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(child: Divider(color: Colors.white54)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
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
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: socialButtonStyle,
                              icon: const Icon(Icons.g_mobiledata),
                              label: const Text('Google'),
                              onPressed: isLoading ? null : () {},
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: socialButtonStyle,
                              icon: const Icon(Icons.apple),
                              label: const Text('Apple'),
                              onPressed: isLoading ? null : () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Non hai un account?",
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: isLoading ? null : () {},
                            child: const Text("Registrati ora"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ).animate().fade(delay: 600.ms, duration: 900.ms),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
