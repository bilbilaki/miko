import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/providers/auth_state_provider.dart';
import 'package:miko/src/ui/dashboard_screen.dart';
import 'package:miko/src/ui/onboarding/onboarding_flow.dart';
import 'package:miko/src/ui/home_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _nameCtl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _signUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // placeholder: use guest session and then continue to profile flow
      await ref.read(authStateProvider.notifier).signInGuest();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OnboardingFlow(onComplete: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  DashboardScreen()));
          })));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    _nameCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Icon(Icons.local_movies, size: 84, color: Colors.green),
                  const SizedBox(height: 16),
                  Text('Create your account', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameCtl,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(prefixIcon: const Icon(Icons.person, color: Colors.white70), hintText: 'Full name', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                          validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailCtl,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(prefixIcon: const Icon(Icons.email, color: Colors.white70), hintText: 'Email', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                          validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passCtl,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(prefixIcon: const Icon(Icons.lock, color: Colors.white70), hintText: 'Password', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                          validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                        ),
                        const SizedBox(height: 16),
                        if (_error != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            onPressed: _loading ? null : _signUp,
                            child: _loading ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)) : const Text('Sign up'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
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
    );
  }
}