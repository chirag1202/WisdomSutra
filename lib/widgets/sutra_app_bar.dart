import 'package:flutter/material.dart';
import '../constants/theme.dart';

class SutraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showHome;
  final List<Widget>? actions;
  const SutraAppBar(
      {super.key, required this.title, this.showHome = true, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<SutraColors>();
    final iconColor = ext?.textOnDark ?? Colors.white;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: iconColor,
      iconTheme: IconThemeData(color: iconColor),
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: .3,
              color: iconColor,
            ),
      ),
      leading: Navigator.of(context).canPop()
          ? IconButton(
              tooltip: 'Back',
              icon: Icon(Icons.arrow_back_rounded, color: iconColor),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      actions: [
        if (actions != null) ...actions!,
        if (showHome)
          IconButton(
            tooltip: 'Home',
            icon: Icon(Icons.home_rounded, color: iconColor),
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil('/questions', (r) => false),
          ),
      ],
    );
  }
}
