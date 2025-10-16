import 'package:flutter/material.dart';
import '../../widgets/sutra_logo.dart';
import '../../widgets/golden_button.dart';
import '../../constants/colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/sutra_app_bar.dart';
import '../../constants/theme.dart';

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
    final colors = theme.extension<SutraColors>();
    final textColor = colors?.textOnDark ?? Colors.white;
    final hintColor = textColor.withOpacity(0.9);
    final accent = colors?.accent ?? AppColors.gold;
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: 1.4),
        );
    return Scaffold(
      appBar: const SutraAppBar(
          title: 'Sign Up', showHome: true, showLogout: false),
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors?.gradientStart ?? AppColors.indigoDeep,
                  colors?.gradientEnd ?? AppColors.indigoDarker,
                ],
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
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: accent,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                        errorText: _emailError,
                        enabledBorder: border(accent.withOpacity(.85)),
                        focusedBorder: border(accent),
                        errorBorder: border(Colors.redAccent),
                        focusedErrorBorder: border(Colors.redAccent),
                        filled: true,
                        fillColor: (colors?.surface ?? AppColors.parchment)
                            .withOpacity(.18),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: accent,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: border(accent.withOpacity(.85)),
                        focusedBorder: border(accent),
                        errorBorder: border(Colors.redAccent),
                        focusedErrorBorder: border(Colors.redAccent),
                        filled: true,
                        fillColor: (colors?.surface ?? AppColors.parchment)
                            .withOpacity(.18),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _confirmCtrl,
                      obscureText: true,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: accent,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                        errorText: _confirmError,
                        enabledBorder: border(accent.withOpacity(.85)),
                        focusedBorder: border(accent),
                        errorBorder: border(Colors.redAccent),
                        focusedErrorBorder: border(Colors.redAccent),
                        filled: true,
                        fillColor: (colors?.surface ?? AppColors.parchment)
                            .withOpacity(.18),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
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
