import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../services/auth_service.dart';
import '../state/app_state.dart';

class SutraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showHome;
  final bool showLogout;
  final bool forceBack;
  final bool? showBack; // if false, never show back; if null, auto
  final List<Widget>? actions;
  const SutraAppBar(
      {super.key,
      required this.title,
      this.showHome = true,
      this.showLogout = true,
      this.forceBack = false,
      this.showBack,
      this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<SutraColors>();
    final iconColor = ext?.textOnDark ?? Colors.white;
    final app = context.watch<AppState>();
    final brightnessIcon = app.brightnessOverride == null
        ? Icons.brightness_auto
        : app.brightnessOverride == Brightness.light
            ? Icons.light_mode
            : Icons.dark_mode;
    final brightnessLabel = app.brightnessOverride == null
        ? 'System theme'
        : app.brightnessOverride == Brightness.light
            ? 'Light theme'
            : 'Dark theme';
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: iconColor,
      iconTheme: IconThemeData(color: iconColor),
      automaticallyImplyLeading: showBack != false,
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: .3,
              color: iconColor,
            ),
      ),
      leading: (showBack == false)
          ? null
          : ((forceBack || Navigator.of(context).canPop()))
              ? IconButton(
                  tooltip: 'Back',
                  icon: Icon(Icons.arrow_back_rounded, color: iconColor),
                  onPressed: () => Navigator.of(context).maybePop(),
                )
              : null,
      actions: [
        // Global theme brightness toggle for all screens
        IconButton(
          tooltip: 'Theme: $brightnessLabel (tap to cycle)',
          icon: Icon(brightnessIcon, color: iconColor),
          onPressed: () => context.read<AppState>().cycleBrightness(),
        ),
        if (actions != null) ...actions!,
        if (showHome)
          IconButton(
            tooltip: 'Home',
            icon: Icon(Icons.home_rounded, color: iconColor),
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil('/questions', (r) => false),
          ),
        if (showLogout)
          IconButton(
            tooltip: 'Logout',
            icon: Icon(Icons.power_settings_new_rounded, color: iconColor),
            onPressed: () async {
              try {
                await const AuthService().signOut();
                // Clear stored user name
                // ignore: use_build_context_synchronously
                await context.read<AppState>().setUserName(null);
              } catch (_) {}
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              }
            },
          ),
      ],
    );
  }
}
