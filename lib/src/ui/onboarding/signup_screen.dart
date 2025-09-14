import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.onSignedUp});
  final VoidCallback onSignedUp;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = false;
  bool _obscure = true;

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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const Icon(Icons.local_movies, size: 80, color: Colors.green),
                    const SizedBox(height: 12),
                    Text('Create Your Account', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _email,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(prefixIcon: const Icon(Icons.email), hintText: 'Email', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                      validator: (s) => (s == null || s.isEmpty) ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure)),
                      ),
                      validator: (s) => (s == null || s.length < 6) ? 'Password min 6' : null,
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _remember,
                      onChanged: (v) => setState(() => _remember = v ?? false),
                      title: const Text('Remember me', style: TextStyle(color: Colors.white70)),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            widget.onSignedUp();
                          }
                        },
                        child: const Text('Sign up'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('or continue with', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.facebook, color: Colors.blue)),
                      const SizedBox(width: 12),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.g_mobiledata, color: Colors.red)),
                      const SizedBox(width: 12),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.apple, color: Colors.white)),
                    ]),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Already have an account? Sign in', style: TextStyle(color: Colors.white70))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}