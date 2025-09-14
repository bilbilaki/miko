import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key, required this.onSignIn, required this.onSignUp});
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  Widget _socialButton(BuildContext c, String label, Color bg, IconData icon) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black54,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        icon: Icon(icon, color: bg),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPhone = ResponsiveBreakpoints.of(context).isMobile;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isPhone ? double.infinity : 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const Icon(Icons.local_movies, size: 96, color: Colors.green),
                  const SizedBox(height: 24),
                  Text("Let's you in", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Welcome back! Please sign in to continue.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 24),
                  _socialButton(context, 'Continue with Facebook', Colors.blue, Icons.facebook),
                  const SizedBox(height: 12),
                  _socialButton(context, 'Continue with Google', Colors.red, Icons.g_mobiledata),
                  const SizedBox(height: 12),
                  _socialButton(context, 'Continue with Apple', Colors.white, Icons.apple),
                  const SizedBox(height: 18),
                  Row(children: const [Expanded(child: Divider(color: Colors.white24)), Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('or', style: TextStyle(color: Colors.white54))), Expanded(child: Divider(color: Colors.white24))]),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: onSignIn,
                      child: const Text('Sign in with password'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onSignUp,
                    child: const Text("Don't have an account? Sign up", style: TextStyle(color: Colors.white70)),
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