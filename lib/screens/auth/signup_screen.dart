import 'package:flutter/material.dart';
import '../../widgets/sutra_logo.dart';
import '../../widgets/golden_button.dart';
import '../../constants/colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/sutra_app_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String? _emailError;
  String? _confirmError;
  bool _loading = false;
  final _auth = const AuthService();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_loading) return;
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmCtrl.text;
    final emailOk = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    setState(() {
      _emailError = emailOk ? null : 'Enter a valid email';
      _confirmError = pass == confirm ? null : 'Passwords do not match';
    });
    if (!emailOk || pass != confirm) return;
    if (email.isEmpty || pass.isEmpty) {
      _showError('Email and password are required');
      return;
    }
    setState(() => _loading = true);
    try {
      await _auth.signUp(email: email, password: pass);
      if (!mounted) return;
      // Show success toast and redirect to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfull')),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const SutraAppBar(title: 'Sign Up', showHome: true),
      body: Stack(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.indigoDeep,
                  Color(0xFF3A235C),
                  AppColors.goldDark
                ],
                stops: [0, .55, 1],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    const SutraLogo(size: 90),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Text('Sign Up', style: theme.textTheme.displaySmall),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Email', errorText: _emailError)),
                    const SizedBox(height: 18),
                    TextField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration:
                            const InputDecoration(hintText: 'Password')),
                    const SizedBox(height: 18),
                    TextField(
                        controller: _confirmCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            errorText: _confirmError)),
                    const SizedBox(height: 28),
                    GoldenButton(
                      label: _loading ? 'Please wait…' : 'Sign up',
                      onPressed: _loading ? null : _signup,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: const [
                            TextSpan(text: 'Already have an account? '),
                            TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          // AppBar already has Home; remove overlay button
        ],
      ),
    );
  }
}
