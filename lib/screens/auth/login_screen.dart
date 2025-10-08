import 'package:flutter/material.dart';
import '../../widgets/sutra_logo.dart';
import '../../widgets/golden_button.dart';
import '../../constants/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.indigoDeep, Color(0xFF3A235C), AppColors.goldDark],
            stops: [0, .55, 1],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
                TextField(decoration: const InputDecoration(hintText: 'Email')),
                const SizedBox(height: 18),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password', suffixIcon: Icon(Icons.visibility, color: AppColors.gold)),
                ),
                const SizedBox(height: 28),
                GoldenButton(
                  label: 'Log in',
                  onPressed: () => Navigator.pushReplacementNamed(context, '/questions'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup'),
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: const [
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(text: 'Sign up', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
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
    );
  }
}
