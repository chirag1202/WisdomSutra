import 'package:flutter/material.dart';
import '../../widgets/sutra_logo.dart';
import '../../widgets/golden_button.dart';
import '../../constants/colors.dart';
import '../../services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/sutra_app_bar.dart';
import '../../constants/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _emailError;
  bool _loading = false;

  final _auth = const AuthService();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_loading) return;
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    if (email.isEmpty || pass.isEmpty) {
      _showError('Email and password are required');
      return;
    }
    final emailOk = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    setState(() => _emailError = emailOk ? null : 'Enter a valid email');
    if (!emailOk) return;
    setState(() => _loading = true);
    try {
      final res = await _auth.signInWithPassword(email: email, password: pass);
      if (!mounted) return;
      if (res.session != null) {
        Navigator.pushReplacementNamed(context, '/questions');
      } else {
        _showError('Login failed.');
      }
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

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _showError('Enter your email above first');
      return;
    }
    try {
      // Supabase Flutter v2 uses resetPasswordForEmail via GoTrueClient
      const mobileRedirect = 'wisdomsutra://login-callback';
      await Supabase.instance.client.auth
          .resetPasswordForEmail(email, redirectTo: mobileRedirect);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password reset email sent (if account exists).')),
      );
    } catch (e) {
      _showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<SutraColors>();
    final textColor = colors?.textOnDark ?? AppColors.parchment;
    final hintColor = textColor.withOpacity(0.65);
    final accent = colors?.accent ?? AppColors.gold;
    OutlineInputBorder _border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c, width: 1.2),
        );
    return Scaffold(
      appBar: const SutraAppBar(title: 'Login', showHome: true),
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
                      child: Text('Login', style: theme.textTheme.displaySmall),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style:
                          theme.textTheme.bodyLarge?.copyWith(color: textColor),
                      cursorColor: accent,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: theme.textTheme.bodyLarge
                            ?.copyWith(color: hintColor),
                        errorText: _emailError,
                        enabledBorder: _border(accent.withOpacity(.6)),
                        focusedBorder: _border(accent),
                        errorBorder: _border(Colors.redAccent),
                        focusedErrorBorder: _border(Colors.redAccent),
                        filled: true,
                        fillColor: (colors?.surface ?? AppColors.parchment)
                            .withOpacity(.08),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      obscureText: true,
                      controller: _passCtrl,
                      style:
                          theme.textTheme.bodyLarge?.copyWith(color: textColor),
                      cursorColor: accent,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: theme.textTheme.bodyLarge
                            ?.copyWith(color: hintColor),
                        suffixIcon: Icon(Icons.visibility, color: accent),
                        enabledBorder: _border(accent.withOpacity(.6)),
                        focusedBorder: _border(accent),
                        errorBorder: _border(Colors.redAccent),
                        focusedErrorBorder: _border(Colors.redAccent),
                        filled: true,
                        fillColor: (colors?.surface ?? AppColors.parchment)
                            .withOpacity(.08),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 28),
                    GoldenButton(
                        label: _loading ? 'Please wait…' : 'Log in',
                        onPressed: _loading ? null : _login),
                    const SizedBox(height: 16),
                    TextButton(
                        onPressed: _loading ? null : _forgotPassword,
                        child: const Text('Forgot password?')),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/signup'),
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: const [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                                text: 'Sign up',
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
