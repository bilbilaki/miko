import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/ui/dashboard_screen.dart';
import 'package:miko/src/ui/home_screen.dart';

class FingerprintSetupScreen extends ConsumerStatefulWidget {
  const FingerprintSetupScreen({super.key});

  @override
  ConsumerState<FingerprintSetupScreen> createState() => _FingerprintSetupScreenState();
}

class _FingerprintSetupScreenState extends ConsumerState<FingerprintSetupScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _available = false;
  bool _authenticating = false;
  String? _error;
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    try {
      final bool can = await auth.isDeviceSupported() && await auth.canCheckBiometrics;
      setState(() => _available = can);
    } catch (e) {
      setState(() => _available = false);
    }
  }

  Future<void> _authenticate() async {
    setState(() {
      _authenticating = true;
      _error = null;
    });
    try {
      final bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to secure your account',
        options: const AuthenticationOptions(stickyAuth: true, useErrorDialogs: true),
      );
      if (authenticated) {
        // Show success dialog and redirect
        if (!mounted) return;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Center(
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SizedBox(
                width: 320,
                height: 320,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, size: 72, color: Colors.green),
                      const SizedBox(height: 16),
                      const Text('Congratulations!', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Your account is ready to use. You will be redirected to the Home page in a few seconds.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(color: Colors.green),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        // redirect after short delay
        _redirectTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) =>  DashboardScreen()), (_) => false);
          }
        });
      } else {
        setState(() => _error = 'Authentication failed');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _authenticating = false);
    }
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Set Your Fingerprint')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Icon(Icons.fingerprint, size: 96, color: Colors.green),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('Add a fingerprint to make your account secure', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 12),
                        if (_error != null) Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: (!_available || _authenticating) ? null : _authenticate,
                      child: _authenticating ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)) : Text(_available ? 'Set fingerprint' : 'Skip and continue'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  DashboardScreen())),
                    child: const Text('Skip', style: TextStyle(color: Colors.white70)),
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