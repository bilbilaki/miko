import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'welcome_screen.dart';
import 'auth_choice_screen.dart';
import 'signup_screen.dart';
import 'interests_screen.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key, required this.onComplete});
  final VoidCallback onComplete;

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  int _step = 0;

  void _next() => setState(() => _step = (_step + 1).clamp(0, 3));
  void _prev() => setState(() => _step = (_step - 1).clamp(0, 3));

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_step) {
      case 0:
        child = WelcomeOnboardingScreen(onFinished: _next);
        break;
      case 1:
        child = AuthChoiceScreen(onSignIn: _next, onSignUp: () {
          _next();
        });
        break;
      case 2:
        child = SignupScreen(onSignedUp: _next);
        break;
      case 3:
      default:
        child = InterestsScreen(onFinish: widget.onComplete);
        break;
    }

    return child;
  }
}