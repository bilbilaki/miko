import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/models/appmodels/profile_model.dart';
import 'package:miko/src/providers/profile_provider.dart';

import 'fingerprint_setup.dart';

class FillProfileScreen extends ConsumerStatefulWidget {
  const FillProfileScreen({super.key});

  @override
  ConsumerState<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends ConsumerState<FillProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullCtl = TextEditingController();
  final _nickCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  String? _gender;
  String? _avatarPath;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    if (profile != null) {
      _fullCtl.text = profile.fullName;
      _nickCtl.text = profile.nickname;
      _emailCtl.text = profile.email ?? '';
      _phoneCtl.text = profile.phone ?? '';
      _gender = profile.gender;
      _avatarPath = profile.avatarPath;
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800, maxHeight: 800);
    if (file != null) {
      setState(() => _avatarPath = file.path);
    }
  }

  Future<void> _saveAndContinue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    final profile = UserProfile(
      fullName: _fullCtl.text.trim(),
      nickname: _nickCtl.text.trim(),
      email: _emailCtl.text.trim(),
      phone: _phoneCtl.text.trim(),
      gender: _gender,
      avatarPath: _avatarPath,
    );
    await ref.read(profileProvider.notifier).save(profile);
    setState(() => _loading = false);
    // Move to fingerprint setup
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const FingerprintSetupScreen()));
  }

  @override
  void dispose() {
    _fullCtl.dispose();
    _nickCtl.dispose();
    _emailCtl.dispose();
    _phoneCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _avatarPath != null ? CircleAvatar(radius: 52, backgroundImage: FileImage(File(_avatarPath!))) : const CircleAvatar(radius: 52, backgroundColor: Colors.white10, child: Icon(Icons.person, size: 48, color: Colors.white24));
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white), title: const Text('Fill Your Profile')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                children: [
                  GestureDetector(onTap: _pickAvatar, child: Stack(alignment: Alignment.bottomRight, children: [avatar, const CircleAvatar(radius: 18, backgroundColor: Colors.green, child: Icon(Icons.edit, color: Colors.white, size: 18))])),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _fullCtl,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(hintText: 'Full Name', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                          validator: (v) => (v == null || v.isEmpty) ? 'Enter full name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nickCtl,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(hintText: 'Nickname', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailCtl,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(prefixIcon: const Icon(Icons.email, color: Colors.white70), hintText: 'Email', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                          validator: (v) => (v == null || v.isEmpty) ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneCtl,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(prefixIcon: const Icon(Icons.phone, color: Colors.white70), hintText: 'Phone Number', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          items: const [
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Female', child: Text('Female')),
                            DropdownMenuItem(value: 'Other', child: Text('Other')),
                          ],
                          onChanged: (v) => setState(() => _gender = v),
                          decoration: InputDecoration(hintText: 'Gender', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(backgroundColor: Colors.grey[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 16)),
                                onPressed: () {
                                  // Skip: mark profile empty and go to fingerprint or home
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const FingerprintSetupScreen()));
                                },
                                child: const Text('Skip', style: TextStyle(color: Colors.white70)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 16)),
                                onPressed: _loading ? null : _saveAndContinue,
                                child: _loading ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)) : const Text('Continue'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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